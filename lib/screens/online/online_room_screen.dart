import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../theme/app_theme.dart';
import '../../services/auth_service.dart';
import '../../services/room_service.dart';
import 'online_category_screen.dart';
import 'online_game_controller.dart';

class OnlineRoomScreen extends StatefulWidget {
  final String roomCode;
  const OnlineRoomScreen({super.key, required this.roomCode});

  @override
  State<OnlineRoomScreen> createState() => _OnlineRoomScreenState();
}

class _OnlineRoomScreenState extends State<OnlineRoomScreen> {
  bool _navigated = false;

  @override
  Widget build(BuildContext context) {
    final user = AuthService.currentUser;
    if (user == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
      });
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    final uid = user.uid;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        await RoomService.leaveRoom(roomCode: widget.roomCode, uid: uid);
        if (context.mounted) Navigator.pop(context);
      },
      child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: RoomService.roomStream(widget.roomCode),
        builder: (context, snapshot) {
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Scaffold(
              appBar: AppBar(title: const Text('Oda')),
              body: const Center(
                child: Text(
                  'Oda bulunamadı veya silindi',
                  style: TextStyle(color: AppTheme.textSecondary),
                ),
              ),
            );
          }

          final data = snapshot.data!.data()!;
          final players = List<Map<String, dynamic>>.from(
            data['players'] ?? [],
          );
          final hostUid = data['hostUid'] as String;
          final isHost = uid == hostUid;
          final status = data['status'] as String;
          final phase = data['phase'] as String? ?? 'lobby';

          // Oyun başladıysa game controller'a yönlendir (host olmayan oyuncular icin)
          if (status == 'playing' && !_navigated) {
            _navigated = true;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (context.mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        OnlineGameController(roomCode: widget.roomCode),
                  ),
                );
              }
            });
          }

          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                onPressed: () async {
                  await RoomService.leaveRoom(
                    roomCode: widget.roomCode,
                    uid: uid,
                  );
                  if (context.mounted) Navigator.pop(context);
                },
              ),
              title: const Text('Bekleme Odası'),
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 16),

                  // Oda Kodu
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.primaryOrange.withValues(alpha: 0.2),
                          AppTheme.primaryOrange.withValues(alpha: 0.05),
                        ],
                      ),
                      border: Border.all(
                        color: AppTheme.primaryOrange.withValues(alpha: 0.4),
                      ),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'ODA KODU',
                          style: TextStyle(
                            color: AppTheme.primaryOrange,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.roomCode,
                          style: const TextStyle(
                            color: AppTheme.textPrimary,
                            fontSize: 42,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 10,
                          ),
                        ),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () {
                            Clipboard.setData(
                              ClipboardData(text: widget.roomCode),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Kod kopyalandı!'),
                                duration: Duration(seconds: 1),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryOrange.withValues(
                                alpha: 0.15,
                              ),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.copy,
                                  size: 14,
                                  color: AppTheme.primaryOrange,
                                ),
                                SizedBox(width: 6),
                                Text(
                                  'Kodu Kopyala',
                                  style: TextStyle(
                                    color: AppTheme.primaryOrange,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Oyuncu listesi başlığı
                  Row(
                    children: [
                      const Text(
                        'Oyuncular',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.cyan.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          '${players.length}/8',
                          style: const TextStyle(
                            color: AppTheme.cyan,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Oyuncu listesi
                  Expanded(
                    child: ListView.separated(
                      itemCount: players.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final player = players[index];
                        final isPlayerHost = player['uid'] == hostUid;
                        final isMe = player['uid'] == uid;

                        return Container(
                          height: 52,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: isMe
                                ? AppTheme.primaryOrange.withValues(alpha: 0.1)
                                : const Color(0xFF1A1F2B),
                            borderRadius: BorderRadius.circular(12),
                            border: isMe
                                ? Border.all(
                                    color: AppTheme.primaryOrange.withValues(
                                      alpha: 0.3,
                                    ),
                                  )
                                : null,
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryOrange.withValues(
                                    alpha: 0.2,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    ((player['name'] ?? '') as String).isNotEmpty ? player['name'][0].toUpperCase() : '?',
                                    style: const TextStyle(
                                      color: AppTheme.primaryOrange,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  player['name'] + (isMe ? ' (Sen)' : ''),
                                  style: const TextStyle(
                                    color: AppTheme.textPrimary,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              if (isPlayerHost)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppTheme.primaryOrange,
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: const Text(
                                    'HOST',
                                    style: TextStyle(
                                      color: AppTheme.background,
                                      fontSize: 9,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  // Başlat butonu (sadece host)
                  if (isHost) ...[
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.cardColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppTheme.divider),
                      ),
                      child: Text(
                        players.length < 2
                            ? 'Oyun başlatmak için en az 2 oyuncu gerekli'
                            : '${players.length} oyuncu hazır. Oyunu başlatabilirsin!',
                        style: const TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 11,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: players.length >= 2
                            ? () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => OnlineCategoryScreen(
                                    roomCode: widget.roomCode,
                                  ),
                                ),
                              )
                            : null,
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Kategori Seç & Başlat'),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_forward, size: 18),
                          ],
                        ),
                      ),
                    ),
                  ] else ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.tealBg,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppTheme.cyan.withValues(alpha: 0.3),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppTheme.cyan,
                            ),
                          ),
                          SizedBox(width: 12),
                          Text(
                            'Host oyunu başlatmasını bekliyor...',
                            style: TextStyle(
                              color: AppTheme.cyan,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 14),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
