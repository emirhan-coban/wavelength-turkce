import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/game_state.dart';
import 'secret_target_screen.dart';

class TurnChangeScreen extends StatelessWidget {
  final GameState gameState;
  const TurnChangeScreen({super.key, required this.gameState});

  @override
  Widget build(BuildContext context) {
    final leader = gameState.currentLeader;
    final isFirstRound = gameState.currentRound == 1;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            size: 18,
            color: AppTheme.textPrimary.withValues(alpha: 0.9),
          ),
          onPressed: () =>
              Navigator.of(context).popUntil((route) => route.isFirst),
        ),
        title: const Text('Sıra Değişimi'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: isFirstRound
            ? _buildFirstRound(context, leader.name)
            : _buildSubsequentRound(context, leader.name),
      ),
    );
  }

  Widget _buildFirstRound(BuildContext ctx, String name) {
    return Column(
      children: [
        const Spacer(),
        Container(
          width: 112,
          height: 112,
          decoration: BoxDecoration(
            color: AppTheme.primaryOrange,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryOrange.withValues(alpha: 0.32),
                blurRadius: 24,
              ),
            ],
          ),
          child: const Icon(
            Icons.person_add_alt_1_rounded,
            size: 46,
            color: AppTheme.background,
          ),
        ),
        const SizedBox(height: 34),
        const Text(
          'Telefonu',
          style: TextStyle(
            fontSize: 16,
            color: AppTheme.textSecondary,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '$name\'e Ver',
          style: const TextStyle(
            fontSize: 40,
            height: 1,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 18),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            color: const Color(0xFF35261A),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: AppTheme.primaryOrange.withValues(alpha: 0.35),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.visibility_off_outlined,
                size: 16,
                color: AppTheme.primaryOrange,
              ),
              const SizedBox(width: 8),
              Text(
                'Sadece lider baksın',
                style: const TextStyle(
                  color: AppTheme.primaryOrange,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Text(
          'Gizlilik için ekran $name\'e uzatılırken\ndiğer oyuncuların görmediğinden emin\nolun.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppTheme.textSecondary.withValues(alpha: 0.8),
            fontSize: 11,
            height: 1.4,
          ),
        ),
        const Spacer(),
        ElevatedButton(
          onPressed: () => Navigator.pushReplacement(
            ctx,
            MaterialPageRoute(
              builder: (_) => SecretTargetScreen(gameState: gameState),
            ),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Hazırım'),
              SizedBox(width: 6),
              Icon(Icons.play_circle_outline, size: 16),
            ],
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildSubsequentRound(BuildContext ctx, String name) {
    return Column(
      children: [
        const SizedBox(height: 24),
        Container(
          width: 94,
          height: 94,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppTheme.cardColorLight,
            border: Border.all(color: AppTheme.primaryOrange, width: 2),
          ),
          child: Center(
            child: Text(
              name.isNotEmpty ? name[0].toUpperCase() : '?',
              style: const TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryOrange,
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Transform.translate(
            offset: const Offset(-12, -14),
            child: Container(
              width: 24,
              height: 24,
              decoration: const BoxDecoration(
                color: AppTheme.primaryOrange,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.person, color: Colors.white, size: 13),
            ),
          ),
        ),
        const SizedBox(height: 18),
        const Text(
          'Sıradaki Lider:',
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 34,
            fontWeight: FontWeight.w700,
            height: 1,
          ),
          textAlign: TextAlign.center,
        ),
        Text(
          name,
          style: const TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryOrange,
            height: 1,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Lütfen telefonu $name\'e teslim edin.',
          style: TextStyle(
            color: AppTheme.textSecondary.withValues(alpha: 0.9),
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 26),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFF35261A),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: AppTheme.primaryOrange.withValues(alpha: 0.35),
            ),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.visibility_off_outlined,
                size: 14,
                color: AppTheme.primaryOrange,
              ),
              SizedBox(width: 6),
              Text(
                'Diğer oyuncular görmemeli!',
                style: TextStyle(
                  color: AppTheme.primaryOrange,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        ElevatedButton(
          onPressed: () => Navigator.pushReplacement(
            ctx,
            MaterialPageRoute(
              builder: (_) => SecretTargetScreen(gameState: gameState),
            ),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Hazırım'),
              SizedBox(width: 6),
              Icon(Icons.play_arrow, size: 16),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'OYUN DEVAM EDİYOR',
          style: TextStyle(
            color: AppTheme.textTertiary.withValues(alpha: 0.8),
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
