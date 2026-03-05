import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

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
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
                      'KAVRAM ÇİFTİ',
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${pair['leftConcept']} ↔ ${pair['rightConcept']}',
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
                      'LİDERİN İPUCU',
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
    );
  }
}
