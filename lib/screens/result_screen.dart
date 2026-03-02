import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/game_state.dart';
import '../widgets/spectrum_dial.dart';
import 'turn_change_screen.dart';
import 'game_over_screen.dart';

class ResultScreen extends StatefulWidget {
  final GameState gameState;
  const ResultScreen({super.key, required this.gameState});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animCtrl;
  late Animation<double> _scoreAnim;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    final score = widget.gameState.lastScore ?? 0;
    _scoreAnim = Tween<double>(
      begin: 0,
      end: score.toDouble(),
    ).animate(CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut));
    _animCtrl.forward();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  void _nextRound() {
    final gs = widget.gameState;
    if (gs.currentRound >= gs.totalRounds) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => GameOverScreen(gameState: gs)),
      );
    } else {
      gs.startNewRound();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => TurnChangeScreen(gameState: gs)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final gs = widget.gameState;
    final guess = gs.lastGuessPosition ?? 0.5;
    final target = gs.targetPosition;
    final score = gs.lastScore ?? 0;

    String feedback;
    Color feedbackColor;
    if (score >= 30) {
      feedback = 'Mükemmel! \u{1F3AF}';
      feedbackColor = AppTheme.success;
    } else if (score >= 10) {
      feedback = 'İyi Tahmin! \u{1F44D}';
      feedbackColor = AppTheme.primaryOrange;
    } else {
      feedback = 'Uzak Kaldı \u{1F605}';
      feedbackColor = AppTheme.error;
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Sonuç'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppTheme.primaryOrange.withValues(alpha: 0.34),
                    AppTheme.cyan.withValues(alpha: 0.24),
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.auto_graph_rounded,
                    size: 34,
                    color: AppTheme.primaryOrange.withValues(alpha: 0.6),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    feedback,
                    style: TextStyle(
                      fontSize: 28,
                      height: 1,
                      fontWeight: FontWeight.w800,
                      color: feedbackColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Hedefe ne kadar yaklaştığını kontrol et.',
                    style: TextStyle(
                      color: AppTheme.textSecondary.withValues(alpha: 0.9),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(14, 16, 14, 12),
              decoration: BoxDecoration(
                color: AppTheme.cardColor,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: [
                  SpectrumDial(
                    value: guess,
                    targetValue: target,
                    onChanged: null,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        'TAHMİN',
                        style: TextStyle(
                          color: AppTheme.primaryOrange.withValues(alpha: 0.95),
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const Spacer(),
                      const Text(
                        'HEDEF',
                        style: TextStyle(
                          color: AppTheme.cyan,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
              decoration: BoxDecoration(
                color: AppTheme.primaryOrange.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(
                  color: AppTheme.primaryOrange.withValues(alpha: 0.45),
                ),
              ),
              child: AnimatedBuilder(
                animation: _scoreAnim,
                builder: (context2, child) => Text(
                  '+${_scoreAnim.value.toInt()} Puan',
                  style: const TextStyle(
                    fontSize: 34,
                    height: 1,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.primaryOrange,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Toplam Puan: ${gs.currentLeader.score}',
              style: TextStyle(
                color: AppTheme.textSecondary.withValues(alpha: 0.9),
                fontSize: 13,
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _nextRound,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    gs.currentRound >= gs.totalRounds
                        ? 'Sonuçları Gör'
                        : 'Sonraki Tur',
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward, size: 18),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
