import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/player.dart';
import '../models/game_category.dart';
import '../models/game_state.dart';
import 'turn_change_screen.dart';

class CategorySelectionScreen extends StatefulWidget {
  final List<Player> players;
  const CategorySelectionScreen({super.key, required this.players});

  @override
  State<CategorySelectionScreen> createState() =>
      _CategorySelectionScreenState();
}

class _CategorySelectionScreenState extends State<CategorySelectionScreen> {
  GameCategory? _selected;

  void _startGame() {
    if (_selected == null) return;
    final gameState = GameState(
      players: widget.players,
      categoryId: _selected!.id,
    );
    gameState.startNewRound();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => TurnChangeScreen(gameState: gameState)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Kategori Seç'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 8),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.95,
                children: GameCategory.all.map((cat) {
                  final isSelected = _selected == cat;
                  return GestureDetector(
                    onTap: () => setState(() => _selected = cat),
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Color.fromARGB(15, 244, 123, 37),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected
                                  ? AppTheme.primaryOrange
                                  : AppTheme.primaryOrange.withValues(
                                      alpha: 0.3,
                                    ),
                            ),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: AppTheme.primaryOrange.withValues(
                                        alpha: 0.25,
                                      ),
                                      blurRadius: 16,
                                      spreadRadius: 1,
                                    ),
                                  ]
                                : null,
                          ),
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  cat.icon,
                                  color: isSelected
                                      ? AppTheme.primaryOrange
                                      : AppTheme.textSecondary,
                                  size: 26,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  cat.name,
                                  style: TextStyle(
                                    color: isSelected
                                        ? AppTheme.primaryOrange
                                        : AppTheme.textPrimary,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (isSelected)
                          Positioned(
                            top: 7,
                            right: 7,
                            child: Container(
                              width: 18,
                              height: 18,
                              decoration: const BoxDecoration(
                                color: AppTheme.primaryOrange,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.check,
                                size: 12,
                                color: Colors.black,
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: const LinearGradient(
                  colors: [AppTheme.primaryOrange, AppTheme.primaryOrangeLight],
                ),
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                ),
                onPressed: _selected != null ? _startGame : null,
                child: const Text('Devam Et'),
              ),
            ),
            const SizedBox(height: 14),
          ],
        ),
      ),
    );
  }
}
