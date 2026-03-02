import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/game_state.dart';
import 'turn_change_screen.dart';

class GameOverScreen extends StatelessWidget {
  final GameState gameState;
  const GameOverScreen({super.key, required this.gameState});

  @override
  Widget build(BuildContext context) {
    final sorted = List.of(gameState.players)
      ..sort((a, b) => b.score.compareTo(a.score));
    final winner = sorted.first;

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
              decoration: BoxDecoration(
                color: AppTheme.primaryOrangeLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.emoji_events_outlined,
                size: 42,
                color: Colors.white,
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Transform.translate(
                offset: const Offset(-98, -18),
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: const BoxDecoration(
                    color: AppTheme.cyan,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.star, size: 16, color: Colors.white),
                ),
              ),
            ),
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
              'Kazanan: ${winner.name}!',
              style: const TextStyle(
                fontSize: 43,
                height: 1,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Harika bir performans sergilendi.',
              style: TextStyle(
                color: AppTheme.textSecondary.withValues(alpha: 0.9),
                fontSize: 13,
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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ...sorted.asMap().entries.map((entry) {
                      final i = entry.key;
                      final p = entry.value;
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
                                    p.name[0],
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
                              Text(
                                p.name,
                                style: TextStyle(
                                  color: i == 0
                                      ? Colors.white
                                      : AppTheme.textPrimary,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                '${p.score}',
                                style: TextStyle(
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
                    }),
                  ],
                ),
              ),
            ),
            OutlinedButton(
              onPressed: () {
                gameState.reset();
                gameState.startNewRound();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TurnChangeScreen(gameState: gameState),
                  ),
                );
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
            OutlinedButton(
              onPressed: () =>
                  Navigator.of(context).popUntil((route) => route.isFirst),
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
