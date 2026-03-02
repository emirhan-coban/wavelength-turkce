import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/game_state.dart';
import '../widgets/spectrum_dial.dart';
import 'result_screen.dart';

class GuessScreen extends StatefulWidget {
  final GameState gameState;
  const GuessScreen({super.key, required this.gameState});

  @override
  State<GuessScreen> createState() => _GuessScreenState();
}

class _GuessScreenState extends State<GuessScreen> {
  double _guessValue = 0.5;

  void _submitGuess() {
    widget.gameState.submitGuess(_guessValue);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ResultScreen(gameState: widget.gameState),
      ),
    );
  }

  void _showExitDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Oyundan Çık',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        content: const Text(
          'Oyundan çıkmak istediğine emin misin?',
          style: TextStyle(color: AppTheme.textSecondary, fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            child: const Text('Çık', style: TextStyle(color: AppTheme.error)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pair = widget.gameState.currentPair!;
    final categoryLabel = widget.gameState.categoryId.toUpperCase();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close, size: 22),
          onPressed: _showExitDialog,
        ),
        title: const Text('Tahmin Ekranı'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, size: 22),
            onPressed: () {},
          ),
        ],
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
            const SizedBox(height: 18),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.divider),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  opacity: 0.22,
                  image: const NetworkImage(
                    'https://images.unsplash.com/photo-1516450360452-9312f5e86fc7?w=1200&q=80',
                  ),
                  colorFilter: ColorFilter.mode(
                    AppTheme.primaryOrange.withValues(alpha: 0.25),
                    BlendMode.screen,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${pair.leftConcept} vs ${pair.rightConcept}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 27,
                      fontWeight: FontWeight.w800,
                      height: 1.05,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'İbreyi uygun noktaya kaydırın',
                    style: TextStyle(
                      color: AppTheme.textSecondary.withValues(alpha: 0.85),
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Text(
                        pair.leftConcept,
                        style: const TextStyle(
                          color: Color(0xFFCD7D37),
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          height: 1,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Spacer(),
                      Text(
                        pair.rightConcept,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          height: 1,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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
            const SizedBox(height: 18),
            const Text(
              'Grup kararını bekliyor...',
              style: TextStyle(color: AppTheme.textSecondary, fontSize: 12),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _submitGuess,
              child: const Row(
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
              'OFFLINE PARTY MODE',
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
