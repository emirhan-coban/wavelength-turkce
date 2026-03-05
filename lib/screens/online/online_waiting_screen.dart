import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/auth_service.dart';
import '../../services/room_service.dart';

class OnlineWaitingScreen extends StatelessWidget {
  final String roomCode;
  final Map<String, dynamic> data;
  final String message;
  final String submessage;

  const OnlineWaitingScreen({
    super.key,
    required this.roomCode,
    required this.data,
    required this.message,
    required this.submessage,
  });

  @override
  Widget build(BuildContext context) {
    final pair = data['currentPair'] as Map<String, dynamic>?;
    final clue = data['clue'] as String?;
    final currentRound = data['currentRound'] as int? ?? 0;
    final totalRounds = data['totalRounds'] as int? ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: Text('Tur $currentRound/$totalRounds'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app, size: 20),
            tooltip: 'Oyundan Ayrıl',
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  backgroundColor: AppTheme.cardColor,
                  title: const Text('Oyundan Ayrıl'),
                  content: const Text(
                    'Oyundan ayrılmak istediğine emin misin?',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      child: const Text('İptal'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      child: const Text(
                        'Ayrıl',
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
                    roomCode: roomCode,
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
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: AppTheme.primaryOrange,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                message,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                submessage,
                style: const TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              if (pair != null) ...[
                const SizedBox(height: 32),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.cardColor,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppTheme.divider),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'KAVRAM \u00c7\u0130FT\u0130',
                        style: TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${pair['leftConcept']} \u2194 ${pair['rightConcept']}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.primaryOrange,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              if (clue != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryOrange.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: AppTheme.primaryOrange.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'L\u0130DER\u0130N \u0130PUCU',
                        style: TextStyle(
                          color: AppTheme.primaryOrange,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '"$clue"',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.primaryOrange,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
