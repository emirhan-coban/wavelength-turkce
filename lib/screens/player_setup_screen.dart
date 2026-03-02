import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/player.dart';
import 'category_selection_screen.dart';

class PlayerSetupScreen extends StatefulWidget {
  const PlayerSetupScreen({super.key});

  @override
  State<PlayerSetupScreen> createState() => _PlayerSetupScreenState();
}

class _PlayerSetupScreenState extends State<PlayerSetupScreen> {
  final List<Player> _players = [
    Player(name: 'Oyuncu 1'),
    Player(name: 'Oyuncu 2'),
    Player(name: 'Oyuncu 3'),
  ];

  final List<String> _defaultNames = [
    'Oyuncu 1',
    'Oyuncu 2',
    'Oyuncu 3',
    'Oyuncu 4',
    'Oyuncu 5',
    'Oyuncu 6',
    'Oyuncu 7',
    'Oyuncu 8',
  ];

  void _addPlayer() {
    if (_players.length >= 8) return;
    setState(() {
      _players.add(Player(name: _defaultNames[_players.length]));
    });
  }

  void _removePlayer(int index) {
    if (_players.length <= 2) return;
    setState(() => _players.removeAt(index));
  }

  void _changeCount(int delta) {
    if (delta > 0) {
      _addPlayer();
      return;
    }
    if (_players.length > 2) {
      _removePlayer(_players.length - 1);
    }
  }

  void _editName(int index) {
    final controller = TextEditingController(text: _players[index].name);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'İsim Düzenle',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        content: TextField(
          controller: controller,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(hintText: 'Oyuncu adı'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                setState(() {
                  _players[index].name = controller.text.trim();
                });
              }
              Navigator.pop(ctx);
            },
            child: const Text('Kaydet'),
          ),
        ],
      ),
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
        title: const Text('Oyuncuları Ayarla'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  colors: [
                    AppTheme.primaryOrange.withValues(alpha: 0.16),
                    AppTheme.primaryOrange.withValues(alpha: 0.05),
                  ],
                ),
                border: Border.all(
                  color: AppTheme.primaryOrange.withValues(alpha: 0.25),
                ),
              ),
              child: Column(
                children: [
                  const Text(
                    'OYUNCU SAYISI',
                    style: TextStyle(
                      color: AppTheme.primaryOrange,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _roundCountButton(Icons.remove, () => _changeCount(-1)),
                      const SizedBox(width: 34),
                      Text(
                        '${_players.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 42,
                          fontWeight: FontWeight.w700,
                          height: 0.95,
                        ),
                      ),
                      const SizedBox(width: 34),
                      _roundCountButton(Icons.add, () => _changeCount(1)),
                    ],
                  ),
                  const Text(
                    'Kişi',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Text(
                  'Oyuncu İsimleri',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'DÜZENLE',
                    style: TextStyle(
                      fontSize: 10,
                      color: AppTheme.primaryOrange,
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: ListView.separated(
                itemCount: _players.length,
                separatorBuilder: (context2, index2) =>
                    const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final player = _players[index];
                  return Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1F2B),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 10),
                        Container(
                          width: 22,
                          height: 22,
                          decoration: const BoxDecoration(
                            color: Color(0xFF2C1B10),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${index + 1}.',
                              style: const TextStyle(
                                color: AppTheme.primaryOrange,
                                fontWeight: FontWeight.w700,
                                fontSize: 9,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            player.name,
                            style: const TextStyle(
                              color: AppTheme.textPrimary,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.edit_outlined,
                            size: 16,
                            color: AppTheme.textSecondary,
                          ),
                          onPressed: () => _editName(index),
                          splashRadius: 20,
                        ),
                        if (_players.length > 2)
                          IconButton(
                            icon: const Icon(
                              Icons.close,
                              size: 14,
                              color: AppTheme.textSecondary,
                            ),
                            onPressed: () => _removePlayer(index),
                            splashRadius: 20,
                          ),
                        const SizedBox(width: 4),
                      ],
                    ),
                  );
                },
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: AppTheme.cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.divider),
              ),
              child: Text(
                '${_players.length} oyuncu seçildi. Bu oyun modu için ideal bir sayı! Herkes hazırsa oyuna başlayabilirsin.',
                style: const TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 11,
                ),
              ),
            ),
            const SizedBox(height: 16),
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
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CategorySelectionScreen(players: _players),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Oyuna Başla'),
                    SizedBox(width: 8),
                    Icon(Icons.play_arrow_rounded, size: 16),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),
          ],
        ),
      ),
    );
  }

  Widget _roundCountButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 34,
        height: 34,
        decoration: const BoxDecoration(
          color: AppTheme.primaryOrange,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: AppTheme.background, size: 20),
      ),
    );
  }
}
