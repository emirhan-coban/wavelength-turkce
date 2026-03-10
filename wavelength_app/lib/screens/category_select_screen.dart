import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/game_provider.dart';
import '../widgets/app_widgets.dart';

class CategorySelectScreen extends StatelessWidget {
  const CategorySelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, provider, _) {
        final selected = provider.state.selectedCategories;
        final allSelected = selected.length == GameCategory.all.length;

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: ZihindarAppBar(
            title: 'Kategori Seç',
            onBack: () => provider.goToPhase(GamePhase.playerSetup),
          ),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Header ────────────────────────────────────────
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Oynamak istediğiniz',
                                  style: TextStyle(
                                    color: AppColors.greyLight,
                                    fontSize: 14,
                                  ),
                                ),
                                const Text(
                                  'kategorileri seçin',
                                  style: TextStyle(
                                    color: AppColors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                            // Select all / clear toggle
                            GestureDetector(
                              onTap: () {
                                if (allSelected) {
                                  provider.clearCategories();
                                } else {
                                  provider.selectAllCategories();
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: allSelected
                                      ? AppColors.orange.withOpacity(0.15)
                                      : AppColors.surfaceLight,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: allSelected
                                        ? AppColors.orange
                                        : AppColors.greyDark,
                                  ),
                                ),
                                child: Text(
                                  allSelected ? 'Tümünü Kaldır' : 'Tümünü Seç',
                                  style: TextStyle(
                                    color: allSelected
                                        ? AppColors.orange
                                        : AppColors.greyLight,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        // Selected count indicator
                        Text(
                          '${selected.length} / ${GameCategory.all.length} kategori seçildi',
                          style: const TextStyle(
                            color: AppColors.grey,
                            fontSize: 13,
                          ),
                        ),

                        const SizedBox(height: 20),

                        // ── Category Grid ─────────────────────────────────
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: 1.2,
                              ),
                          itemCount: GameCategory.all.length,
                          itemBuilder: (context, index) {
                            final category = GameCategory.all[index];
                            final isSelected = provider.isCategorySelected(
                              category,
                            );
                            return CategoryCard(
                              category: category,
                              isSelected: isSelected,
                              onTap: () => provider.toggleCategory(category),
                            );
                          },
                        ),

                        const SizedBox(height: 20),

                        // ── Info Banner ───────────────────────────────────
                        if (selected.isEmpty)
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: AppColors.error.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppColors.error.withOpacity(0.4),
                              ),
                            ),
                            child: const Row(
                              children: [
                                Icon(
                                  Icons.warning_amber_rounded,
                                  color: AppColors.error,
                                  size: 18,
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    'En az bir kategori seçmelisiniz.',
                                    style: TextStyle(
                                      color: AppColors.error,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        else
                          _SelectedCategoryPreview(selected: selected),

                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),

                // ── Bottom Button ─────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  child: PrimaryButton(
                    text: 'Devam Et',
                    icon: Icons.arrow_forward_rounded,
                    onPressed: selected.isEmpty
                        ? null
                        : () => provider.startGame(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ─── Selected Category Preview ────────────────────────────────────────────────
class _SelectedCategoryPreview extends StatelessWidget {
  final List<GameCategory> selected;

  const _SelectedCategoryPreview({required this.selected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.greyDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.check_circle_outline_rounded,
                color: AppColors.success,
                size: 16,
              ),
              SizedBox(width: 8),
              Text(
                'Seçilen Kategoriler',
                style: TextStyle(
                  color: AppColors.greyLight,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: selected
                .map(
                  (cat) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.orange.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.orange.withOpacity(0.4),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(cat.emoji, style: const TextStyle(fontSize: 13)),
                        const SizedBox(width: 6),
                        Text(
                          cat.name,
                          style: const TextStyle(
                            color: AppColors.orange,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
