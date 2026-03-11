import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/game_provider.dart';
import '../widgets/app_widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              // ── Top Bar ──
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Logo
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.orange,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Text(
                            'Z',
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Zihindar',
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  // Info button
                  GestureDetector(
                    onTap: () => _showHowToPlay(context),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceLight,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.info_outline_rounded,
                        color: AppColors.greyLight,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // ── Hero Card ──
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(24),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.orange.withOpacity(0.25),
                      AppColors.surfaceLight,
                      AppColors.surface,
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    // Decorative circles
                    Positioned(
                      right: -20,
                      top: -20,
                      child: Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.orange.withOpacity(0.08),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 30,
                      top: 20,
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.orange.withOpacity(0.12),
                        ),
                      ),
                    ),
                    // Emoji group
                    Positioned(
                      right: 24,
                      top: 0,
                      bottom: 0,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: AppColors.orange.withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: const Center(
                                child: Text('Z', style: TextStyle(
                                  color: AppColors.orange,
                                  fontSize: 28,
                                  fontWeight: FontWeight.w900,
                                )),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Text(
                            'Kelime Avı',
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Arkadaşlarınla\neğlenceye hazır mısın?',
                            style: TextStyle(
                              color: AppColors.white.withOpacity(0.7),
                              fontSize: 14,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              InfoChip(
                                label: '2-8 Oyuncu',
                                icon: Icons.people_rounded,
                                color: AppColors.orange,
                              ),
                              const SizedBox(width: 8),
                              InfoChip(
                                label: '15 Dakika',
                                icon: Icons.timer_outlined,
                                color: AppColors.greyLight,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ── Stats row ──
              Row(
                children: [
                  _StatCard(label: '100+', sublabel: 'Oyun Kartı'),
                  const SizedBox(width: 12),
                  _StatCard(label: '6', sublabel: 'Kategori'),
                  const SizedBox(width: 12),
                  _StatCard(
                    label: '15dk',
                    sublabel: 'Süre',
                  ),
                ],
              ),

              const Spacer(),

              // ── Buttons ──
              PrimaryButton(
                text: 'Oyuna Başla',
                icon: Icons.play_arrow_rounded,
                onPressed: () {
                  context.read<GameProvider>().startSetup();
                },
              ),
              const SizedBox(height: 12),
              SecondaryButton(
                text: 'Nasıl Oynanır?',
                icon: Icons.help_outline_rounded,
                onPressed: () => _showHowToPlay(context),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  void _showHowToPlay(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      isScrollControlled: true,
      builder: (_) => const _HowToPlaySheet(),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String sublabel;

  const _StatCard({
    required this.label,
    required this.sublabel,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              sublabel,
              style: const TextStyle(color: AppColors.grey, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}

class _HowToPlaySheet extends StatelessWidget {
  const _HowToPlaySheet();

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      maxChildSize: 0.93,
      minChildSize: 0.4,
      expand: false,
      builder: (_, controller) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.greyDark,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Nasıl Oynanır?',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView(
                  controller: controller,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  children: const [
                    SizedBox(height: 12),
                    _HowToStep(
                      number: '1',
                      title: 'Psişik Seçilir',
                      desc:
                          'Her turda bir oyuncu psişik olur. Telefon o oyuncuya verilir.',
                    ),
                    _HowToStep(
                      number: '2',
                      title: 'Gizli Hedef',
                      desc:
                          'Psişik, spektrum üzerindeki gizli hedef noktasını görür. Başka kimse göremez!',
                    ),
                    _HowToStep(
                      number: '3',
                      title: 'İpucu Ver',
                      desc:
                          'Psişik, kartın iki kutbu arasındaki spektrumda hedefin konumunu anlatan bir kelime veya cümle söyler.',
                    ),
                    _HowToStep(
                      number: '4',
                      title: 'Grup Tahmin Eder',
                      desc:
                          'Gruptaki diğer oyuncular tartışarak ibrenin nereye yerleştirileceğine karar verir.',
                    ),
                    _HowToStep(
                      number: '5',
                      title: 'Puan Hesaplanır',
                      desc:
                          'İbre hedefe ne kadar yakınsa o kadar çok puan kazanırsınız! Tam isabette 4 puan.',
                    ),
                    SizedBox(height: 8),
                    _PointsTable(),
                    SizedBox(height: 32),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _HowToStep extends StatelessWidget {
  final String number;
  final String title;
  final String desc;

  const _HowToStep({
    required this.number,
    required this.title,
    required this.desc,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              color: AppColors.orange,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  color: AppColors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  desc,
                  style: const TextStyle(
                    color: AppColors.greyLight,
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PointsTable extends StatelessWidget {
  const _PointsTable();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Puan Tablosu',
            style: TextStyle(
              color: AppColors.white,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          _PointRow(
            range: 'Tam İsabet',
            points: '+40',
            color: AppColors.orange,
          ),
          _PointRow(
            range: 'Çok Yakın',
            points: '+30',
            color: AppColors.success,
          ),
          _PointRow(range: 'Yakın', points: '+20', color: Color(0xFF4A90D9)),
          _PointRow(
            range: 'Fena Değil',
            points: '+10',
            color: AppColors.greyLight,
          ),
          _PointRow(range: 'Kaçırdınız', points: '+0', color: AppColors.error),
        ],
      ),
    );
  }
}

class _PointRow extends StatelessWidget {
  final String range;
  final String points;
  final Color color;

  const _PointRow({
    required this.range,
    required this.points,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              const SizedBox(width: 10),
              Text(
                range,
                style: const TextStyle(
                  color: AppColors.greyLight,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          Text(
            points,
            style: TextStyle(
              color: color,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
