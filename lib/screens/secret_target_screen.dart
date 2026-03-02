import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/game_state.dart';
import '../widgets/target_indicator.dart';
import 'guess_screen.dart';

class SecretTargetScreen extends StatelessWidget {
  final GameState gameState;
  const SecretTargetScreen({super.key, required this.gameState});

  @override
  Widget build(BuildContext context) {
    final target = gameState.targetPosition;
    final categoryLabel = gameState.categoryId.toUpperCase();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Gizli Hedef'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                color: AppTheme.tealBg,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                'KATEGORİ: $categoryLabel',
                style: const TextStyle(
                  color: AppTheme.cyan,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.7,
                ),
              ),
            ),
            const SizedBox(height: 22),
            const Text(
              'Hedef Belirlendi',
              style: TextStyle(
                fontSize: 40,
                height: 1,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Bu pozisyonu kimseye gösterme',
              style: TextStyle(color: AppTheme.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 18),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
              decoration: BoxDecoration(
                color: AppTheme.cardColor,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppTheme.divider),
              ),
              child: Column(
                children: [TargetIndicator(targetPosition: target)],
              ),
            ),
            const SizedBox(height: 26),
            const Text(
              'Hedefi aklında tut',
              style: TextStyle(
                fontSize: 30,
                height: 1,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Grup geri kalanına ipucunu verirken bu\nnoktayı temsil eden bir şey söylemelisin.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 13,
                height: 1.4,
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => GuessScreen(gameState: gameState),
                ),
              ),
              child: const Text('Hazırım'),
            ),
            const SizedBox(height: 8),
            Text(
              'OYUN LİDERİ EKRANI',
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
