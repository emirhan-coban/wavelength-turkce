import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/game_provider.dart';
import '../widgets/app_widgets.dart';

// ═══════════════════════════════════════════════════════════════════════════════
// ROUND RESULT SCREEN
// ═══════════════════════════════════════════════════════════════════════════════
class RoundResultScreen extends StatefulWidget {
  const RoundResultScreen({super.key});

  @override
  State<RoundResultScreen> createState() => _RoundResultScreenState();
}

class _RoundResultScreenState extends State<RoundResultScreen>
    with TickerProviderStateMixin {
  late AnimationController _slideCtrl;
  late AnimationController _scoreCtrl;
  late Animation<Offset> _slideAnim;
  late Animation<double> _scoreFade;
  late Animation<double> _scoreScale;

  @override
  void initState() {
    super.initState();
    _slideCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _scoreCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideCtrl, curve: Curves.easeOutCubic));

    _scoreFade = CurvedAnimation(parent: _scoreCtrl, curve: Curves.easeOut);
    _scoreScale = Tween<double>(
      begin: 0.4,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _scoreCtrl, curve: Curves.elasticOut));

    _slideCtrl.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _scoreCtrl.forward();
    });
  }

  @override
  void dispose() {
    _slideCtrl.dispose();
    _scoreCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, provider, _) {
        final result = provider.lastRoundResult;
        if (result == null) return const SizedBox.shrink();

        final isLastRound = provider.state.isLastRound;
        final nextPsychic = provider.nextPsychic;
        final points = result.pointsEarned;

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: ZihindarAppBar(
            title: 'Sonuç',
            showBack: false,
            trailing: _RoundBadge(
              current: provider.currentRound,
              total: provider.state.totalRounds,
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SlideTransition(
                position: _slideAnim,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 24),

                    // ── Round progress ──────────────────────────────────────
                    RoundProgressBar(
                      current: provider.currentRound,
                      total: provider.state.totalRounds,
                    ),

                    const SizedBox(height: 32),

                    // ── Result label ────────────────────────────────────────
                    Text(
                      result.resultLabel,
                      style: TextStyle(
                        color: _resultColor(points),
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 6),

                    Text(
                      _resultSubtitle(points),
                      style: const TextStyle(
                        color: AppColors.greyLight,
                        fontSize: 14,
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 28),

                    // ── Animated score badge ────────────────────────────────
                    FadeTransition(
                      opacity: _scoreFade,
                      child: ScaleTransition(
                        scale: _scoreScale,
                        child: _BigScoreBadge(
                          points: points,
                          pointsLabel: '+${points * 10} Puan',
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    // ── Revealed slider ─────────────────────────────────────
                    _RevealedSlider(result: result),

                    const SizedBox(height: 24),

                    // ── Clue recap ──────────────────────────────────────────
                    _ClueRecap(result: result),

                    const SizedBox(height: 20),

                    // ── Updated leaderboard ─────────────────────────────────
                    _ResultLeaderboard(
                      players: provider.leaderboard,
                      psychicId: result.psychic.id,
                    ),

                    const SizedBox(height: 28),

                    // ── Next psychic preview ────────────────────────────────
                    if (!isLastRound && nextPsychic != null)
                      _NextPsychicPreview(player: nextPsychic),

                    const SizedBox(height: 20),

                    // ── Buttons ─────────────────────────────────────────────
                    if (isLastRound)
                      PrimaryButton(
                        text: 'Sonuçları Gör',
                        icon: Icons.emoji_events_rounded,
                        onPressed: () => provider.nextRound(),
                      )
                    else
                      PrimaryButton(
                        text: 'Sonraki Tur',
                        icon: Icons.arrow_forward_rounded,
                        onPressed: () => provider.nextRound(),
                      ),

                    const SizedBox(height: 36),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Color _resultColor(int points) {
    if (points >= 4) return AppColors.orange;
    if (points >= 3) return AppColors.success;
    if (points >= 2) return const Color(0xFF4A90D9);
    if (points >= 1) return AppColors.greyLight;
    return AppColors.error;
  }

  String _resultSubtitle(int points) {
    if (points >= 4) return 'Tam İsabet';
    if (points >= 3) return 'Başarılı Tahmin';
    if (points >= 2) return 'Fena Değil';
    if (points >= 1) return 'Biraz Daha Yaklaşabilirdiniz';
    return 'İsabet Yok';
  }
}

// ─── Big Score Badge ──────────────────────────────────────────────────────────
class _BigScoreBadge extends StatelessWidget {
  final int points;
  final String pointsLabel;

  const _BigScoreBadge({required this.points, required this.pointsLabel});

  Color get _color {
    if (points >= 4) return AppColors.orange;
    if (points >= 3) return AppColors.success;
    if (points >= 2) return const Color(0xFF4A90D9);
    if (points >= 1) return AppColors.greyLight;
    return AppColors.error;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      height: 140,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _color.withOpacity(0.12),
        border: Border.all(color: _color, width: 3),
        boxShadow: [
          BoxShadow(
            color: _color.withOpacity(0.3),
            blurRadius: 24,
            spreadRadius: 4,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            pointsLabel,
            style: TextStyle(
              color: _color,
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Revealed Slider ─────────────────────────────────────────────────────────
class _RevealedSlider extends StatelessWidget {
  final RoundResult result;

  const _RevealedSlider({required this.result});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.greyDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Hedef Ne Kadardı?',
            style: TextStyle(
              color: AppColors.greyLight,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          WavelengthSlider(
            leftLabel: result.card.leftLabel,
            rightLabel: result.card.rightLabel,
            value: result.guessPosition,
            targetValue: result.targetPosition,
            interactive: false,
            height: 80,
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _LegendItem(
                color: AppColors.orange,
                label: 'Hedef',
                icon: Icons.arrow_drop_down_rounded,
              ),
              _LegendItem(
                color: AppColors.white,
                label: 'Tahmin',
                icon: Icons.circle,
              ),
              _LegendItem(
                color: AppColors.greyLight,
                label:
                    'Mesafe: ${((result.targetPosition - result.guessPosition).abs() * 100).round()}%',
                icon: Icons.straighten_rounded,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final IconData icon;

  const _LegendItem({
    required this.color,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 14),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

// ─── Clue Recap ───────────────────────────────────────────────────────────────
class _ClueRecap extends StatelessWidget {
  final RoundResult result;

  const _ClueRecap({required this.result});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.greyDark),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: result.psychic.avatarColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                result.psychic.name.isNotEmpty
                    ? result.psychic.name[0].toUpperCase()
                    : '?',
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${result.psychic.name}\'in İpucu',
                  style: const TextStyle(color: AppColors.grey, fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  '"${result.clue}"',
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.italic,
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

// ─── Result Leaderboard ───────────────────────────────────────────────────────
class _ResultLeaderboard extends StatelessWidget {
  final List<Player> players;
  final String psychicId;

  const _ResultLeaderboard({required this.players, required this.psychicId});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Sıralama',
          style: TextStyle(
            color: AppColors.greyLight,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        ...players.asMap().entries.map((e) {
          return LeaderboardRow(
            player: e.value,
            rank: e.key + 1,
            highlight: e.value.id == psychicId,
          );
        }),
      ],
    );
  }
}

// ─── Next Psychic Preview ─────────────────────────────────────────────────────
class _NextPsychicPreview extends StatelessWidget {
  final Player player;

  const _NextPsychicPreview({required this.player});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.orange.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.orange.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: player.avatarColor,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.orange, width: 2),
            ),
            child: Center(
              child: Text(
                player.name.isNotEmpty ? player.name[0].toUpperCase() : '?',
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Sıradaki Lider',
                  style: TextStyle(color: AppColors.grey, fontSize: 12),
                ),
                Text(
                  player.name,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios_rounded,
            color: AppColors.orange,
            size: 16,
          ),
        ],
      ),
    );
  }
}

// ─── Round Badge ──────────────────────────────────────────────────────────────
class _RoundBadge extends StatelessWidget {
  final int current;
  final int total;

  const _RoundBadge({required this.current, required this.total});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        'Tur $current / $total',
        style: const TextStyle(
          color: AppColors.greyLight,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// GAME OVER SCREEN
// ═══════════════════════════════════════════════════════════════════════════════
class GameOverScreen extends StatefulWidget {
  const GameOverScreen({super.key});

  @override
  State<GameOverScreen> createState() => _GameOverScreenState();
}

class _GameOverScreenState extends State<GameOverScreen>
    with TickerProviderStateMixin {
  late AnimationController _confettiCtrl;
  late AnimationController _entryCtrl;
  late Animation<double> _entryFade;
  late Animation<Offset> _entrySlide;

  @override
  void initState() {
    super.initState();
    _confettiCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..forward();

    _entryCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();

    _entryFade = CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOut);
    _entrySlide = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOutCubic));
  }

  @override
  void dispose() {
    _confettiCtrl.dispose();
    _entryCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, provider, _) {
        final winner = provider.winner;
        final players = provider.leaderboard;
        if (winner == null) return const SizedBox.shrink();

        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: FadeTransition(
              opacity: _entryFade,
              child: SlideTransition(
                position: _entrySlide,
                child: Column(
                  children: [
                    // ── Custom AppBar ───────────────────────────────────────
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () => provider.goHome(),
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: AppColors.surfaceLight,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close_rounded,
                                color: AppColors.greyLight,
                                size: 20,
                              ),
                            ),
                          ),
                          const Text(
                            'OYUN BİTTİ',
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 2,
                            ),
                          ),
                          const SizedBox(width: 40),
                        ],
                      ),
                    ),

                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          children: [
                            const SizedBox(height: 16),

                            // ── Trophy + Winner ─────────────────────────────
                            _WinnerSection(winner: winner),

                            const SizedBox(height: 32),

                            // ── Final scores ────────────────────────────────
                            _FinalScores(players: players),

                            const SizedBox(height: 32),

                            // ── Stats ────────────────────────────────────────
                            _GameStats(
                              totalRounds: provider.state.totalRounds,
                              history: provider.roundHistory,
                            ),

                            const SizedBox(height: 32),
                          ],
                        ),
                      ),
                    ),

                    // ── Bottom buttons ──────────────────────────────────────
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
                      child: Column(
                        children: [
                          PrimaryButton(
                            text: 'Hazırım',
                            icon: Icons.replay_rounded,
                            onPressed: () => provider.restartGame(),
                          ),
                          const SizedBox(height: 10),
                          SecondaryButton(
                            text: 'Ana Menü',
                            icon: Icons.home_rounded,
                            onPressed: () => provider.goHome(),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// ─── Winner Section ───────────────────────────────────────────────────────────
class _WinnerSection extends StatelessWidget {
  final Player winner;

  const _WinnerSection({required this.winner});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Trophy emoji with glow
        Stack(
          alignment: Alignment.topRight,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: winner.avatarColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: winner.avatarColor.withOpacity(0.5),
                    blurRadius: 30,
                    spreadRadius: 8,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  winner.name.isNotEmpty ? winner.name[0].toUpperCase() : '?',
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 44,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.orange,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.background, width: 2),
              ),
              child: const Center(
                child: Icon(Icons.emoji_events_rounded, size: 20, color: AppColors.background),
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        const Text(
          'ŞAMPIYON',
          style: TextStyle(
            color: AppColors.orange,
            fontSize: 12,
            fontWeight: FontWeight.w800,
            letterSpacing: 3,
          ),
        ),

        const SizedBox(height: 6),

        Text(
          'Kazanan: ${winner.name}!',
          style: const TextStyle(
            color: AppColors.white,
            fontSize: 28,
            fontWeight: FontWeight.w800,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 8),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.orange.withOpacity(0.15),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.orange.withOpacity(0.4)),
          ),
          child: Text(
            '${winner.score} Puan',
            style: const TextStyle(
              color: AppColors.orange,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),

        const SizedBox(height: 10),

        const Text(
          'Harika bir performans sergiledi!',
          style: TextStyle(color: AppColors.greyLight, fontSize: 14),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

// ─── Final Scores ─────────────────────────────────────────────────────────────
class _FinalScores extends StatelessWidget {
  final List<Player> players;

  const _FinalScores({required this.players});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'FİNAL SKORLARI',
          style: TextStyle(
            color: AppColors.grey,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 12),
        ...players.asMap().entries.map(
          (e) => LeaderboardRow(
            player: e.value,
            rank: e.key + 1,
            highlight: e.key == 0,
          ),
        ),
      ],
    );
  }
}

// ─── Game Stats ───────────────────────────────────────────────────────────────
class _GameStats extends StatelessWidget {
  final int totalRounds;
  final List<RoundResult> history;

  const _GameStats({required this.totalRounds, required this.history});

  @override
  Widget build(BuildContext context) {
    if (history.isEmpty) return const SizedBox.shrink();

    final perfectHits = history.where((r) => r.pointsEarned == 4).length;
    final totalPoints = history.fold<int>(
      0,
      (sum, r) => sum + r.pointsEarned * 10,
    );
    final avgPoints = history.isEmpty ? 0 : totalPoints ~/ history.length;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.greyDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'OYUN İSTATİSTİKLERİ',
            style: TextStyle(
              color: AppColors.grey,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _StatTile(
                value: '$perfectHits',
                label: 'Tam İsabet',
              ),
              _StatTile(
                value: '$totalRounds',
                label: 'Toplam Tur',
              ),
              _StatTile(value: '$avgPoints', label: 'Ort. Puan'),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String value;
  final String label;

  const _StatTile({
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            label,
            style: const TextStyle(color: AppColors.grey, fontSize: 11),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
