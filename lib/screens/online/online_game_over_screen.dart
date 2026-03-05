import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/auth_service.dart';
import '../../services/room_service.dart';

class OnlineGameOverScreen extends StatelessWidget {
  final String roomCode;
  final Map<String, dynamic> data;

  const OnlineGameOverScreen({
    super.key,
    required this.roomCode,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final players = List<Map<String, dynamic>>.from(data['players'] ?? []);
    final sorted = List<Map<String, dynamic>>.from(players)
      ..sort((a, b) => (b['score'] as int).compareTo(a['score'] as int));
    final winner = sorted.first;
    final uid = AuthService.currentUser?.uid ?? '';
    final isHost = uid == data['hostUid'];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close, size: 18),
          onPressed: () =>
              Navigator.of(context).popUntil((route) => route.isFirst),
        ),
        title: const Text('OYUN BİTTİ'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 8),
            Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                color: AppTheme.primaryOrangeLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.emoji_events_outlined,
                size: 42,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Şampiyon',
              style: TextStyle(
                color: AppTheme.primaryOrange,
                fontSize: 13,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${winner['name']}!',
              style: const TextStyle(
                fontSize: 40,
                height: 1,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              '${winner['score']} puan',
              style: const TextStyle(
                color: AppTheme.primaryOrange,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'FİNAL SKORLARI',
                style: TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.cardColor,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: ListView(
                  children: sorted.asMap().entries.map((entry) {
                    final i = entry.key;
                    final p = entry.value;
                    final isMe = p['uid'] == uid;

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: i == 0
                              ? AppTheme.primaryOrange.withValues(alpha: 0.92)
                              : isMe
                              ? AppTheme.primaryOrange.withValues(alpha: 0.1)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: i == 0
                                    ? Colors.white.withValues(alpha: 0.32)
                                    : AppTheme.cardColorLight,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  '${i + 1}',
                                  style: TextStyle(
                                    color: i == 0
                                        ? Colors.white
                                        : AppTheme.textSecondary,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 9,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: i == 0
                                    ? Colors.white.withValues(alpha: 0.28)
                                    : AppTheme.cyan.withValues(alpha: 0.25),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  ((p['name'] ?? '') as String).isNotEmpty ? p['name'][0] : '?',
                                  style: TextStyle(
                                    color: i == 0
                                        ? Colors.white
                                        : AppTheme.cyan,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                '${p['name']}${isMe ? " (Sen)" : ""}',
                                style: TextStyle(
                                  color: i == 0
                                      ? Colors.white
                                      : AppTheme.textPrimary,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Text(
                              '${p['score']}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 22,
                                height: 1,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'PUAN',
                              style: TextStyle(
                                color: i == 0
                                    ? Colors.white.withValues(alpha: 0.9)
                                    : AppTheme.textSecondary,
                                fontWeight: FontWeight.w700,
                                fontSize: 8,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            const SizedBox(height: 12),

            if (isHost) ...[
              OutlinedButton(
                onPressed: () async {
                  await RoomService.restartGame(roomCode: roomCode);
                },
                style: OutlinedButton.styleFrom(
                  backgroundColor: AppTheme.primaryOrange,
                  side: BorderSide.none,
                  foregroundColor: AppTheme.background,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.refresh, size: 16),
                    SizedBox(width: 8),
                    Text('Tekrar Oyna'),
                  ],
                ),
              ),
              const SizedBox(height: 8),
            ],
            OutlinedButton(
              onPressed: () async {
                await RoomService.leaveRoom(roomCode: roomCode, uid: uid);
                if (context.mounted) {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                }
              },
              style: OutlinedButton.styleFrom(
                backgroundColor: AppTheme.tealBg,
                side: BorderSide(color: AppTheme.cyan.withValues(alpha: 0.4)),
                foregroundColor: AppTheme.cyan,
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.home_outlined, size: 16),
                  SizedBox(width: 8),
                  Text('Ana Menü'),
                ],
              ),
            ),
            const SizedBox(height: 14),
          ],
        ),
      ),
    );
  }
}
