import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/game_provider.dart';
import '../widgets/app_widgets.dart';

// ═══════════════════════════════════════════════════════════════════════════════
// PHONE PASS SCREEN — "Telefonu X'e Ver"
// ═══════════════════════════════════════════════════════════════════════════════
class PhonePassScreen extends StatelessWidget {
  const PhonePassScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, provider, _) {
        final psychic = provider.currentPsychic;
        if (psychic == null) return const SizedBox.shrink();

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: ZihindarAppBar(
            title: 'Sıra Değişimi',
            onBack: () => provider.goHome(),
            trailing: _RoundBadge(
              current: provider.currentRound,
              total: provider.state.totalRounds,
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                children: [
                  const SizedBox(height: 32),

                  // ── Progress ──────────────────────────────────────────────
                  RoundProgressBar(
                    current: provider.currentRound,
                    total: provider.state.totalRounds,
                  ),

                  const Spacer(),

                  // ── Big Avatar ────────────────────────────────────────────
                  _PulsingAvatar(player: psychic),

                  const SizedBox(height: 32),

                  // ── Instruction text ──────────────────────────────────────
                  Text.rich(
                    TextSpan(
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        color: AppColors.white,
                        height: 1.3,
                      ),
                      children: [
                        const TextSpan(text: 'Telefonu '),
                        TextSpan(
                          text: psychic.name,
                          style: const TextStyle(color: AppColors.orange),
                        ),
                        const TextSpan(text: "'e\nVer"),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 16),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.lock_outline_rounded,
                          color: AppColors.grey,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Sadece ${psychic.name} bakmalı!',
                          style: const TextStyle(
                            color: AppColors.grey,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'Diğer ${provider.players.length - 1} oyuncunun görmediğinden emin ol.',
                    style: const TextStyle(color: AppColors.grey, fontSize: 13),
                    textAlign: TextAlign.center,
                  ),

                  const Spacer(),

                  // ── Players row preview ───────────────────────────────────
                  _PlayersPreview(
                    players: provider.players,
                    psychicId: psychic.id,
                  ),

                  const SizedBox(height: 28),

                  PrimaryButton(
                    text: 'Hazırım',
                    icon: Icons.visibility_rounded,
                    onPressed: () => provider.psychicReady(),
                  ),

                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// SECRET TARGET SCREEN — Psychic sees hidden target
// ═══════════════════════════════════════════════════════════════════════════════
class SecretTargetScreen extends StatefulWidget {
  const SecretTargetScreen({super.key});

  @override
  State<SecretTargetScreen> createState() => _SecretTargetScreenState();
}

class _SecretTargetScreenState extends State<SecretTargetScreen>
    with SingleTickerProviderStateMixin {
  bool _revealed = false;
  late AnimationController _controller;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnim = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _reveal() {
    setState(() => _revealed = true);
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, provider, _) {
        final card = provider.currentCard;
        final psychic = provider.currentPsychic;
        if (card == null || psychic == null) return const SizedBox.shrink();

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: ZihindarAppBar(
            title: 'Gizli Hedef',
            onBack: () => provider.goToPhase(GamePhase.phonePass),
            trailing: _CategoryBadge(
              categoryName: provider.currentCategoryName,
              emoji: provider.currentCategoryEmoji,
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  // ── Card poles ────────────────────────────────────────────
                  _CardPolesDisplay(card: card),

                  const Spacer(),

                  if (!_revealed) ...[
                    // ── Tap to reveal ─────────────────────────────────────
                    GestureDetector(
                      onTap: _reveal,
                      child: Column(
                        children: [
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              color: AppColors.orange.withOpacity(0.15),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.orange,
                                width: 2,
                              ),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.visibility_off_rounded,
                                color: AppColors.orange,
                                size: 48,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Hedefi Görmek İçin\nEkrana Dokun',
                            style: TextStyle(
                              color: AppColors.greyLight,
                              fontSize: 16,
                              height: 1.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Sadece ${psychic.name} bakmalı!',
                            style: const TextStyle(
                              color: AppColors.orange,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ] else ...[
                    // ── Revealed: show slider with target ─────────────────
                    FadeTransition(
                      opacity: _fadeAnim,
                      child: Column(
                        children: [
                          const Text(
                            'Hedef Belirlendi',
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Bu pozisyonu kimseye gösterme',
                            style: TextStyle(
                              color: AppColors.grey,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 32),
                          WavelengthSlider(
                            leftLabel: card.leftLabel,
                            rightLabel: card.rightLabel,
                            value: provider.targetPosition,
                            targetValue: provider.targetPosition,
                            interactive: false,
                            height: 80,
                          ),
                          const SizedBox(height: 24),
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: AppColors.orange.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppColors.orange.withOpacity(0.4),
                              ),
                            ),
                            child: const Row(
                              children: [
                                Icon(
                                  Icons.lightbulb_outline_rounded,
                                  color: AppColors.orange,
                                  size: 18,
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    'Hedefe ne kadar yaklaştığını kontrol et ve bunu anlatan bir ipucu düşün!',
                                    style: TextStyle(
                                      color: AppColors.greyLight,
                                      fontSize: 13,
                                      height: 1.5,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const Spacer(),

                  PrimaryButton(
                    text: 'Hazırım',
                    icon: Icons.arrow_forward_rounded,
                    onPressed: _revealed
                        ? () => provider.psychicSawTarget()
                        : null,
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// CLUE GIVING SCREEN — Psychic types / speaks clue, others must not see target
// ═══════════════════════════════════════════════════════════════════════════════
class ClueGivingScreen extends StatefulWidget {
  const ClueGivingScreen({super.key});

  @override
  State<ClueGivingScreen> createState() => _ClueGivingScreenState();
}

class _ClueGivingScreenState extends State<ClueGivingScreen> {
  final TextEditingController _clueController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    final provider = context.read<GameProvider>();
    _clueController.text = provider.state.clue;
    _clueController.addListener(() {
      provider.setClue(_clueController.text);
    });
    // Auto-focus
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _clueController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, provider, _) {
        final card = provider.currentCard;
        final psychic = provider.currentPsychic;
        if (card == null || psychic == null) return const SizedBox.shrink();
        final clue = provider.state.clue.trim();

        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            backgroundColor: AppColors.background,
            resizeToAvoidBottomInset: true,
            appBar: ZihindarAppBar(
              title: 'İpucu Ver',
              onBack: () => provider.goToPhase(GamePhase.secretTarget),
              trailing: _CategoryBadge(
                categoryName: provider.currentCategoryName,
                emoji: provider.currentCategoryEmoji,
              ),
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),

                    // ── Poles bar ─────────────────────────────────────────
                    _CardPolesDisplay(card: card),

                    const SizedBox(height: 28),

                    // ── Slider (target hidden) ────────────────────────────
                    WavelengthSlider(
                      leftLabel: card.leftLabel,
                      rightLabel: card.rightLabel,
                      value: 0.5,
                      targetValue: null, // hidden
                      interactive: false,
                      height: 70,
                    ),

                    const SizedBox(height: 28),

                    // ── Psychic info ──────────────────────────────────────
                    Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: psychic.avatarColor,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              psychic.name.isNotEmpty
                                  ? psychic.name[0].toUpperCase()
                                  : '?',
                              style: const TextStyle(
                                color: AppColors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              psychic.name,
                              style: const TextStyle(
                                color: AppColors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const Text(
                              'ipucunu yazıyor...',
                              style: TextStyle(
                                color: AppColors.grey,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // ── Clue input ────────────────────────────────────────
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceLight,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: clue.isNotEmpty
                              ? AppColors.orange
                              : AppColors.greyDark,
                          width: clue.isNotEmpty ? 2 : 1,
                        ),
                      ),
                      child: TextField(
                        controller: _clueController,
                        focusNode: _focusNode,
                        style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 3,
                        minLines: 2,
                        decoration: const InputDecoration(
                          hintText: 'İpucunu buraya yaz...',
                          hintStyle: TextStyle(
                            color: AppColors.grey,
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                          ),
                          border: InputBorder.none,
                          isDense: true,
                        ),
                        textCapitalization: TextCapitalization.sentences,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // ── Rules reminder ────────────────────────────────────
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.greyDark),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Row(
                            children: [
                              Icon(
                                Icons.rule_rounded,
                                color: AppColors.orange,
                                size: 16,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Kurallar',
                                style: TextStyle(
                                  color: AppColors.orange,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          _RuleItem(
                            text: 'Sadece bir kelime veya kısa cümle söyle',
                          ),
                          _RuleItem(text: 'Sayı veya pozisyon ipucu verme'),
                          _RuleItem(text: 'Kartın tam kelimelerini kullanma'),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    PrimaryButton(
                      text: 'İpucunu Gönder',
                      icon: Icons.send_rounded,
                      onPressed: clue.isEmpty
                          ? null
                          : () => provider.submitClue(),
                    ),

                    const SizedBox(height: 12),
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

// ═══════════════════════════════════════════════════════════════════════════════
// GROUP GUESS SCREEN — Everyone sees card poles and clue, moves the dial
// ═══════════════════════════════════════════════════════════════════════════════
class GroupGuessScreen extends StatelessWidget {
  const GroupGuessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, provider, _) {
        final card = provider.currentCard;
        final psychic = provider.currentPsychic;
        if (card == null || psychic == null) return const SizedBox.shrink();

        final isLocked = provider.isGuessLocked;

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: ZihindarAppBar(
            title: 'Tahmin Ekranı',
            onBack: null,
            showBack: false,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _CategoryBadge(
                  categoryName: provider.currentCategoryName,
                  emoji: provider.currentCategoryEmoji,
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => _showRules(context),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceLight,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.help_outline_rounded,
                      color: AppColors.greyLight,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 16),

                  // ── Card poles ────────────────────────────────────────────
                  _CardPolesDisplay(card: card),

                  const SizedBox(height: 24),

                  // ── Clue display ──────────────────────────────────────────
                  _ClueDisplay(clue: provider.state.clue, psychic: psychic),

                  const SizedBox(height: 32),

                  // ── Interactive slider ────────────────────────────────────
                  WavelengthSlider(
                    leftLabel: card.leftLabel,
                    rightLabel: card.rightLabel,
                    value: provider.guessPosition,
                    targetValue: null,
                    interactive: !isLocked,
                    onChanged: isLocked ? null : (v) => provider.updateGuess(v),
                    height: 90,
                  ),

                  const SizedBox(height: 16),

                  // ── Lock / position indicator ─────────────────────────────
                  if (!isLocked) ...[
                    const Text(
                      'İbreyi sürükleyerek konumlandır',
                      style: TextStyle(color: AppColors.grey, fontSize: 13),
                      textAlign: TextAlign.center,
                    ),
                  ] else ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.success.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.success.withOpacity(0.4),
                        ),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.lock_rounded,
                            color: AppColors.success,
                            size: 14,
                          ),
                          SizedBox(width: 6),
                          Text(
                            'Tahmin kilitlendi',
                            style: TextStyle(
                              color: AppColors.success,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const Spacer(),

                  // ── Leaderboard mini ──────────────────────────────────────
                  _MiniLeaderboard(
                    players: provider.leaderboard,
                    psychicId: psychic.id,
                  ),

                  const SizedBox(height: 20),

                  // ── Bottom buttons ────────────────────────────────────────
                  if (!isLocked)
                    PrimaryButton(
                      text: 'Tahmini Kilitle',
                      icon: Icons.lock_rounded,
                      onPressed: () => provider.lockGuess(),
                      color: AppColors.orangeDark,
                    )
                  else
                    PrimaryButton(
                      text: 'Tahmin Yap',
                      icon: Icons.arrow_forward_rounded,
                      onPressed: () => provider.submitGuess(),
                    ),

                  const SizedBox(height: 8),

                  Text(
                    'OFFLINE PARTY MODE',
                    style: TextStyle(
                      color: AppColors.grey.withOpacity(0.5),
                      fontSize: 10,
                      letterSpacing: 2,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showRules(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Tahmin Kuralları',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 16),
            _RuleItem(
              text: 'Psişik hariç herkes ibreyi konumlandırabilir',
              icon: Icons.people_alt_rounded,
            ),
            _RuleItem(
              text: 'Grup tartışarak ortak bir karar almalı',
              icon: Icons.forum_rounded,
            ),
            _RuleItem(
              text: 'İbrenin hedef bölgeye yakınlığı puanı belirler',
              icon: Icons.gps_fixed_rounded,
            ),
            _RuleItem(
              text: 'Tahmini kilitlemeden önce herkes hemfikir olmalı',
              icon: Icons.how_to_vote_rounded,
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// SHARED SUB-WIDGETS
// ═══════════════════════════════════════════════════════════════════════════════

// ── Round badge ───────────────────────────────────────────────────────────────
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
        '$current / $total',
        style: const TextStyle(
          color: AppColors.greyLight,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// ── Category badge ────────────────────────────────────────────────────────────
class _CategoryBadge extends StatelessWidget {
  final String categoryName;
  final String emoji;

  const _CategoryBadge({required this.categoryName, required this.emoji});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.orange.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.orange.withOpacity(0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 12)),
          const SizedBox(width: 4),
          Text(
            'KATEGORİ: $categoryName',
            style: const TextStyle(
              color: AppColors.orange,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Card poles display ────────────────────────────────────────────────────────
class _CardPolesDisplay extends StatelessWidget {
  final GameCard card;

  const _CardPolesDisplay({required this.card});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.greyDark),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'BAŞLANGIÇ',
                  style: TextStyle(
                    color: AppColors.grey,
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  card.leftLabel,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 1,
            height: 40,
            color: AppColors.greyDark,
            margin: const EdgeInsets.symmetric(horizontal: 16),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text(
                  'BİTİŞ',
                  style: TextStyle(
                    color: AppColors.grey,
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  card.rightLabel,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.end,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Clue display ──────────────────────────────────────────────────────────────
class _ClueDisplay extends StatelessWidget {
  final String clue;
  final Player psychic;

  const _ClueDisplay({required this.clue, required this.psychic});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: AppColors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.orange.withOpacity(0.35),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: psychic.avatarColor,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    psychic.name.isNotEmpty
                        ? psychic.name[0].toUpperCase()
                        : '?',
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${psychic.name} diyor ki:',
                style: const TextStyle(
                  color: AppColors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            '"$clue"',
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 22,
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.italic,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Mini Leaderboard (inside GroupGuessScreen) ───────────────────────────────
class _MiniLeaderboard extends StatelessWidget {
  final List<Player> players;
  final String psychicId;

  const _MiniLeaderboard({required this.players, required this.psychicId});

  @override
  Widget build(BuildContext context) {
    final shown = players.take(4).toList();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.leaderboard_rounded,
            color: AppColors.orange,
            size: 18,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Row(
              children: shown.map((p) {
                final isPsychic = p.id == psychicId;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 26,
                        height: 26,
                        decoration: BoxDecoration(
                          color: p.avatarColor,
                          shape: BoxShape.circle,
                          border: isPsychic
                              ? Border.all(color: AppColors.orange, width: 2)
                              : null,
                        ),
                        child: Center(
                          child: Text(
                            p.name.isNotEmpty ? p.name[0].toUpperCase() : '?',
                            style: const TextStyle(
                              color: AppColors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${p.score}',
                        style: const TextStyle(
                          color: AppColors.greyLight,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          if (players.length > 4)
            Text(
              '+${players.length - 4} daha',
              style: const TextStyle(color: AppColors.grey, fontSize: 11),
            ),
        ],
      ),
    );
  }
}

// ── Players Preview (Phone Pass screen) ──────────────────────────────────────
class _PlayersPreview extends StatelessWidget {
  final List<Player> players;
  final String psychicId;

  const _PlayersPreview({required this.players, required this.psychicId});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: players.map((p) {
        final isPsychic = p.id == psychicId;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Column(
            children: [
              Container(
                width: isPsychic ? 52 : 40,
                height: isPsychic ? 52 : 40,
                decoration: BoxDecoration(
                  color: p.avatarColor,
                  shape: BoxShape.circle,
                  border: isPsychic
                      ? Border.all(color: AppColors.orange, width: 3)
                      : null,
                  boxShadow: isPsychic
                      ? [
                          BoxShadow(
                            color: AppColors.orange.withOpacity(0.4),
                            blurRadius: 12,
                            spreadRadius: 2,
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: Text(
                    p.name.isNotEmpty ? p.name[0].toUpperCase() : '?',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: isPsychic ? 20 : 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                p.name.split(' ').first,
                style: TextStyle(
                  color: isPsychic ? AppColors.orange : AppColors.grey,
                  fontSize: 11,
                  fontWeight: isPsychic ? FontWeight.w700 : FontWeight.w400,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

// ── Pulsing Avatar (Phone Pass screen) ───────────────────────────────────────
class _PulsingAvatar extends StatefulWidget {
  final Player player;

  const _PulsingAvatar({required this.player});

  @override
  State<_PulsingAvatar> createState() => _PulsingAvatarState();
}

class _PulsingAvatarState extends State<_PulsingAvatar>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _scale = Tween<double>(
      begin: 0.95,
      end: 1.05,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer glow ring
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widget.player.avatarColor.withOpacity(0.15),
            ),
          ),
          // Mid ring
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widget.player.avatarColor.withOpacity(0.25),
              border: Border.all(
                color: widget.player.avatarColor.withOpacity(0.5),
                width: 2,
              ),
            ),
          ),
          // Inner avatar
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              color: widget.player.avatarColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                widget.player.name.isNotEmpty
                    ? widget.player.name[0].toUpperCase()
                    : '?',
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          // Phone icon badge
          Positioned(
            bottom: 8,
            right: 8,
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.orange,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.background, width: 2),
              ),
              child: const Icon(
                Icons.smartphone_rounded,
                color: AppColors.white,
                size: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Rule Item ─────────────────────────────────────────────────────────────────
class _RuleItem extends StatelessWidget {
  final String text;
  final IconData? icon;

  const _RuleItem({required this.text, this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon ?? Icons.check_circle_outline_rounded,
            color: AppColors.orange,
            size: 15,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: AppColors.greyLight,
                fontSize: 12,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
