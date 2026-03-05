import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/auth_service.dart';
import '../../services/room_service.dart';
import '../../widgets/spectrum_dial.dart';

class OnlineGuessScreen extends StatefulWidget {
  final String roomCode;
  final Map<String, dynamic> data;

  const OnlineGuessScreen({
    super.key,
    required this.roomCode,
    required this.data,
  });

  @override
  State<OnlineGuessScreen> createState() => _OnlineGuessScreenState();
}

class _OnlineGuessScreenState extends State<OnlineGuessScreen> {
  double _guessValue = 0.5;
  bool _isSubmitting = false;

  Future<void> _submitGuess() async {
    setState(() => _isSubmitting = true);
    try {
      await RoomService.submitGuess(
        roomCode: widget.roomCode,
        uid: AuthService.currentUser?.uid ?? '',
        guessPosition: _guessValue,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Hata: $e')));
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final pair = widget.data['currentPair'] as Map<String, dynamic>?;
    final clue = widget.data['clue'] as String?;
    final currentRound = widget.data['currentRound'] as int? ?? 0;
    final totalRounds = widget.data['totalRounds'] as int? ?? 0;
    final players = List<Map<String, dynamic>>.from(
      widget.data['players'] ?? [],
    );
    final leaderIndex = widget.data['currentLeaderIndex'] as int? ?? 0;
    final leaderName = leaderIndex < players.length
        ? players[leaderIndex]['name']
        : '?';

    return Scaffold(
      appBar: AppBar(
        title: Text('Tur $currentRound/$totalRounds'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app, size: 20),
            tooltip: 'Oyundan Ayr\u0131l',
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  backgroundColor: AppTheme.cardColor,
                  title: const Text('Oyundan Ayr\u0131l'),
                  content: const Text(
                    'Oyundan ayr\u0131lmak istedi\u011fine emin misin?',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      child: const Text('\u0130ptal'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      child: const Text(
                        'Ayr\u0131l',
                        style: TextStyle(color: AppTheme.error),
                      ),
                    ),
                  ],
                ),
              );
              if (confirm == true && context.mounted) {
                final user = AuthService.currentUser;
                if (user != null) {
                  await RoomService.leaveRoom(
                    roomCode: widget.roomCode,
                    uid: user.uid,
                  );
                }
                if (context.mounted) {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                }
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 8),
            // Lider ipucu bilgisi
            if (clue != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.primaryOrange.withValues(alpha: 0.15),
                      AppTheme.primaryOrange.withValues(alpha: 0.05),
                    ],
                  ),
                  border: Border.all(
                    color: AppTheme.primaryOrange.withValues(alpha: 0.3),
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      '$leaderName\'in İpucu:',
                      style: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '"$clue"',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.primaryOrange,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 18),

            // Kavram çifti ve slider
            if (pair != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.divider),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${pair['leftConcept']} vs ${pair['rightConcept']}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        height: 1.05,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'İbreyi uygun noktaya kaydır',
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            pair['leftConcept'],
                            style: const TextStyle(
                              color: Color(0xFFCD7D37),
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        Text(
                          pair['rightConcept'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    SpectrumDial(
                      value: _guessValue,
                      onChanged: (v) => setState(() => _guessValue = v),
                    ),
                  ],
                ),
              ),

            const Spacer(),
            ElevatedButton(
              onPressed: _isSubmitting ? null : _submitGuess,
              child: _isSubmitting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppTheme.background,
                      ),
                    )
                  : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_circle_outline, size: 16),
                        SizedBox(width: 8),
                        Text('Tahmin Yap'),
                      ],
                    ),
            ),
            const SizedBox(height: 8),
            Text(
              'ONLINE MODE',
              style: TextStyle(
                color: AppTheme.textTertiary.withValues(alpha: 0.8),
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
