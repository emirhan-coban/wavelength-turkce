import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/game_provider.dart';
import '../widgets/app_widgets.dart';

class PlayerSetupScreen extends StatefulWidget {
  const PlayerSetupScreen({super.key});

  @override
  State<PlayerSetupScreen> createState() => _PlayerSetupScreenState();
}

class _PlayerSetupScreenState extends State<PlayerSetupScreen> {
  final List<TextEditingController> _controllers = [];
  final List<FocusNode> _focusNodes = [];

  @override
  void initState() {
    super.initState();
    final provider = context.read<GameProvider>();
    _syncControllers(provider.players);
  }

  void _syncControllers(List<Player> players) {
    // Dispose extras
    while (_controllers.length > players.length) {
      _controllers.removeLast().dispose();
      _focusNodes.removeLast().dispose();
    }
    // Add missing
    while (_controllers.length < players.length) {
      final idx = _controllers.length;
      _controllers.add(TextEditingController(text: players[idx].name));
      _focusNodes.add(FocusNode());
    }
    // Sync text
    for (int i = 0; i < players.length; i++) {
      if (_controllers[i].text != players[i].name) {
        _controllers[i].text = players[i].name;
      }
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, provider, _) {
        final players = provider.players;
        _syncControllers(players);

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: ZihindarAppBar(
            title: 'Oyuncuları Ayarla',
            onBack: () => provider.goHome(),
          ),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 24),

                        // ── Player Count ──────────────────────────────────
                        Center(
                          child: Column(
                            children: [
                              const Text(
                                'OYUNCU SAYISI',
                                style: TextStyle(
                                  color: AppColors.orange,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1.5,
                                ),
                              ),
                              const SizedBox(height: 16),
                              PlayerCountSelector(
                                count: players.length,
                                min: 2,
                                max: 8,
                                onChanged: (count) {
                                  provider.setPlayerCount(count);
                                },
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 32),
                        const Divider(color: AppColors.divider, height: 1),
                        const SizedBox(height: 24),

                        // ── Player Names ──────────────────────────────────
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Oyuncu İsimleri',
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => _showEditDialog(context, provider),
                              child: const Text(
                                'DÜZENLE',
                                style: TextStyle(
                                  color: AppColors.orange,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Player list
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: players.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            return _PlayerNameRow(
                              index: index,
                              player: players[index],
                              controller: _controllers[index],
                              focusNode: _focusNodes[index],
                              onNameChanged: (name) {
                                provider.updatePlayerName(index, name);
                              },
                              onAvatarTap: () {
                                _showAvatarPicker(context, provider, index);
                              },
                            );
                          },
                        ),

                        const SizedBox(height: 24),

                        // ── Info ──────────────────────────────────────────
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceLight,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.greyDark,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.info_outline_rounded,
                                color: AppColors.grey,
                                size: 18,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  '${players.length} oyuncu seçildi. Bu oyun modu için ideal bir sayı! Herkes hazırsa oyuna başlayabilirsiniz.',
                                  style: const TextStyle(
                                    color: AppColors.grey,
                                    fontSize: 12,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),

                // ── Bottom Button ─────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  child: PrimaryButton(
                    text: 'Oyuna Başla',
                    icon: Icons.arrow_forward_rounded,
                    onPressed: () => provider.goToCategorySelect(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showEditDialog(BuildContext context, GameProvider provider) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'İsimleri Düzenle',
          style: TextStyle(color: AppColors.white, fontWeight: FontWeight.w700),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(provider.players.length, (i) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: TextField(
                  controller: _controllers[i],
                  focusNode: _focusNodes[i],
                  style: const TextStyle(color: AppColors.white),
                  decoration: InputDecoration(
                    labelText: 'Oyuncu ${i + 1}',
                    labelStyle: const TextStyle(color: AppColors.grey),
                    filled: true,
                    fillColor: AppColors.surfaceLight,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: AppColors.orange,
                        width: 2,
                      ),
                    ),
                    prefixIcon: Container(
                      margin: const EdgeInsets.all(8),
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: provider.players[i].avatarColor,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          provider.players[i].name.isNotEmpty
                              ? provider.players[i].name[0].toUpperCase()
                              : '?',
                          style: const TextStyle(
                            color: AppColors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                  onChanged: (v) => provider.updatePlayerName(i, v),
                  textInputAction: i < provider.players.length - 1
                      ? TextInputAction.next
                      : TextInputAction.done,
                  onSubmitted: (_) {
                    if (i < provider.players.length - 1) {
                      _focusNodes[i + 1].requestFocus();
                    } else {
                      Navigator.of(context).pop();
                    }
                  },
                ),
              );
            }),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Tamam',
              style: TextStyle(
                color: AppColors.orange,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAvatarPicker(
    BuildContext context,
    GameProvider provider,
    int playerIndex,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Renk Seç',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: List.generate(Player.avatarColors.length, (i) {
                  final isSelected =
                      provider.players[playerIndex].avatarIndex == i;
                  return GestureDetector(
                    onTap: () {
                      provider.updatePlayerAvatar(playerIndex, i);
                      Navigator.of(context).pop();
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: Player.avatarColors[i],
                        shape: BoxShape.circle,
                        border: isSelected
                            ? Border.all(color: AppColors.white, width: 3)
                            : null,
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: Player.avatarColors[i].withOpacity(
                                    0.5,
                                  ),
                                  blurRadius: 12,
                                  spreadRadius: 2,
                                ),
                              ]
                            : null,
                      ),
                      child: isSelected
                          ? const Icon(
                              Icons.check_rounded,
                              color: AppColors.white,
                              size: 24,
                            )
                          : null,
                    ),
                  );
                }),
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }
}

// ─── Player Name Row ──────────────────────────────────────────────────────────
class _PlayerNameRow extends StatelessWidget {
  final int index;
  final Player player;
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onNameChanged;
  final VoidCallback onAvatarTap;

  const _PlayerNameRow({
    required this.index,
    required this.player,
    required this.controller,
    required this.focusNode,
    required this.onNameChanged,
    required this.onAvatarTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          // Rank number
          SizedBox(
            width: 24,
            child: Text(
              '${index + 1}.',
              style: const TextStyle(
                color: AppColors.grey,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Avatar (tappable)
          GestureDetector(
            onTap: onAvatarTap,
            child: Stack(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: player.avatarColor,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      player.name.isNotEmpty
                          ? player.name[0].toUpperCase()
                          : '?',
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: const BoxDecoration(
                      color: AppColors.greyDark,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.edit,
                      color: AppColors.greyLight,
                      size: 9,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),

          // Name field
          Expanded(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
                hintText: 'İsim gir...',
                hintStyle: TextStyle(color: AppColors.grey, fontSize: 15),
              ),
              onChanged: onNameChanged,
              textInputAction: TextInputAction.next,
            ),
          ),
        ],
      ),
    );
  }
}
