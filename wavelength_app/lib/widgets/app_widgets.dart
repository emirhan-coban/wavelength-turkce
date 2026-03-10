import 'package:flutter/material.dart';
import '../models/models.dart';

// ─── Primary Button ──────────────────────────────────────────────────────────
class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final double? width;
  final double height;
  final Color? color;

  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.width,
    this.height = 56,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? AppColors.orange,
          foregroundColor: AppColors.white,
          disabledBackgroundColor: AppColors.orange.withOpacity(0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        child: isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  color: AppColors.white,
                  strokeWidth: 2.5,
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    text,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.3,
                    ),
                  ),
                  if (icon != null) ...[
                    const SizedBox(width: 8),
                    Icon(icon, size: 20),
                  ],
                ],
              ),
      ),
    );
  }
}

// ─── Secondary / Outline Button ──────────────────────────────────────────────
class SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final double? width;
  final double height;
  final Color? borderColor;
  final Color? textColor;

  const SecondaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.width,
    this.height = 56,
    this.borderColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final clr = textColor ?? AppColors.white;
    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: clr,
          side: BorderSide(
            color: borderColor ?? AppColors.greyDark,
            width: 1.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: clr,
              ),
            ),
            if (icon != null) ...[
              const SizedBox(width: 8),
              Icon(icon, size: 20, color: clr),
            ],
          ],
        ),
      ),
    );
  }
}

// ─── Player Avatar ───────────────────────────────────────────────────────────
class PlayerAvatar extends StatelessWidget {
  final Player player;
  final double size;
  final bool showName;
  final bool showScore;
  final bool isHighlighted;
  final VoidCallback? onTap;

  const PlayerAvatar({
    super.key,
    required this.player,
    this.size = 48,
    this.showName = false,
    this.showScore = false,
    this.isHighlighted = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: player.avatarColor,
              shape: BoxShape.circle,
              border: isHighlighted
                  ? Border.all(color: AppColors.orange, width: 3)
                  : null,
              boxShadow: isHighlighted
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
                player.name.isNotEmpty ? player.name[0].toUpperCase() : '?',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: size * 0.4,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          if (showName) ...[
            const SizedBox(height: 6),
            Text(
              player.name,
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          if (showScore) ...[
            const SizedBox(height: 2),
            Text(
              '${player.score} puan',
              style: const TextStyle(color: AppColors.grey, fontSize: 11),
            ),
          ],
        ],
      ),
    );
  }
}

// ─── Leaderboard Row ─────────────────────────────────────────────────────────
class LeaderboardRow extends StatelessWidget {
  final Player player;
  final int rank;
  final bool highlight;

  const LeaderboardRow({
    super.key,
    required this.player,
    required this.rank,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    final isFirst = rank == 1;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: highlight
            ? AppColors.orange.withOpacity(0.15)
            : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(14),
        border: highlight
            ? Border.all(color: AppColors.orange.withOpacity(0.4), width: 1)
            : null,
      ),
      child: Row(
        children: [
          // Rank badge
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: isFirst
                  ? AppColors.orange
                  : AppColors.greyDark.withOpacity(0.6),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: isFirst
                  ? const Text('🏆', style: TextStyle(fontSize: 14))
                  : Text(
                      '$rank',
                      style: const TextStyle(
                        color: AppColors.greyLight,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
            ),
          ),
          const SizedBox(width: 12),
          // Avatar
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: player.avatarColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                player.name.isNotEmpty ? player.name[0].toUpperCase() : '?',
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Name
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  player.name,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (isFirst)
                  const Text(
                    'Lider',
                    style: TextStyle(
                      color: AppColors.orange,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
          ),
          // Score
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: isFirst
                  ? AppColors.orange
                  : AppColors.greyDark.withOpacity(0.7),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${player.score}',
              style: TextStyle(
                color: isFirst ? AppColors.white : AppColors.greyLight,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Wavelength Slider ───────────────────────────────────────────────────────
class WavelengthSlider extends StatelessWidget {
  final String leftLabel;
  final String rightLabel;
  final double value; // 0.0 – 1.0 (guess position)
  final double? targetValue; // null = hidden
  final bool interactive;
  final ValueChanged<double>? onChanged;
  final double height;

  const WavelengthSlider({
    super.key,
    required this.leftLabel,
    required this.rightLabel,
    required this.value,
    this.targetValue,
    this.interactive = false,
    this.onChanged,
    this.height = 120,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Spektrum çubuğu
        SizedBox(
          height: height,
          child: LayoutBuilder(
            builder: (ctx, constraints) {
              final w = constraints.maxWidth;
              return GestureDetector(
                onHorizontalDragUpdate: interactive
                    ? (d) {
                        final newVal = (value + d.delta.dx / w).clamp(0.0, 1.0);
                        onChanged?.call(newVal);
                      }
                    : null,
                onTapDown: interactive
                    ? (d) {
                        final newVal = (d.localPosition.dx / w).clamp(0.0, 1.0);
                        onChanged?.call(newVal);
                      }
                    : null,
                child: CustomPaint(
                  painter: _SliderPainter(
                    guessPosition: value,
                    targetPosition: targetValue,
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        // Etiketler
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              leftLabel,
              style: const TextStyle(
                color: AppColors.greyLight,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              rightLabel,
              style: const TextStyle(
                color: AppColors.greyLight,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SliderPainter extends CustomPainter {
  final double guessPosition;
  final double? targetPosition;

  _SliderPainter({required this.guessPosition, this.targetPosition});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final centerY = h / 2;
    const trackH = 12.0;
    const radius = 8.0;

    // ── Gradient track ──
    final trackRect = Rect.fromLTWH(0, centerY - trackH / 2, w, trackH);
    final trackRRect = RRect.fromRectAndRadius(
      trackRect,
      const Radius.circular(radius),
    );

    final gradient = LinearGradient(
      colors: [
        AppColors.greyDark,
        AppColors.grey.withOpacity(0.6),
        AppColors.greyDark,
      ],
    );
    final trackPaint = Paint()
      ..shader = gradient.createShader(trackRect)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(trackRRect, trackPaint);

    // ── Hedef bölgesi (gösteriliyorsa) ──
    if (targetPosition != null) {
      final tx = targetPosition! * w;

      // 4 puan bölgesi (koyu turuncu)
      _drawZone(
        canvas,
        w,
        centerY,
        trackH,
        tx,
        0.08 * w,
        AppColors.orange.withOpacity(0.85),
      );
      // 3 puan bölgesi
      _drawZone(
        canvas,
        w,
        centerY,
        trackH,
        tx,
        0.16 * w,
        AppColors.orange.withOpacity(0.55),
      );
      // 2 puan bölgesi
      _drawZone(
        canvas,
        w,
        centerY,
        trackH,
        tx,
        0.25 * w,
        AppColors.orange.withOpacity(0.30),
      );
      // 1 puan bölgesi
      _drawZone(
        canvas,
        w,
        centerY,
        trackH,
        tx,
        0.35 * w,
        AppColors.orange.withOpacity(0.15),
      );

      // Hedef ibresi
      final targetPaint = Paint()
        ..color = AppColors.orange
        ..style = PaintingStyle.fill;
      final targetPath = Path()
        ..moveTo(tx, centerY - trackH / 2 - 14)
        ..lineTo(tx - 8, centerY - trackH / 2 - 2)
        ..lineTo(tx + 8, centerY - trackH / 2 - 2)
        ..close();
      canvas.drawPath(targetPath, targetPaint);

      // HEDEF yazısı
      final textPainter = TextPainter(
        text: const TextSpan(
          text: 'HEDEF',
          style: TextStyle(
            color: AppColors.orange,
            fontSize: 9,
            fontWeight: FontWeight.w700,
            letterSpacing: 1,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      textPainter.paint(
        canvas,
        Offset(tx - textPainter.width / 2, centerY - trackH / 2 - 30),
      );
    }

    // ── Guess ibreleri ──
    final gx = guessPosition * w;
    final guessPaint = Paint()
      ..color = AppColors.white
      ..style = PaintingStyle.fill;

    // Beyaz daire ibge
    canvas.drawCircle(Offset(gx, centerY), 14, guessPaint);

    final innerPaint = Paint()
      ..color = AppColors.surface
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(gx, centerY), 7, innerPaint);

    // TAHMIN yazısı
    final tPainter = TextPainter(
      text: const TextSpan(
        text: 'TAHMİN',
        style: TextStyle(
          color: AppColors.greyLight,
          fontSize: 9,
          fontWeight: FontWeight.w700,
          letterSpacing: 1,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tPainter.paint(
      canvas,
      Offset(gx - tPainter.width / 2, centerY + trackH / 2 + 8),
    );
  }

  void _drawZone(
    Canvas canvas,
    double w,
    double centerY,
    double trackH,
    double tx,
    double halfW,
    Color color,
  ) {
    final left = (tx - halfW).clamp(0.0, w);
    final right = (tx + halfW).clamp(0.0, w);
    final zoneRect = Rect.fromLTWH(
      left,
      centerY - trackH / 2,
      right - left,
      trackH,
    );
    canvas.drawRect(zoneRect, Paint()..color = color);
  }

  @override
  bool shouldRepaint(_SliderPainter old) =>
      old.guessPosition != guessPosition ||
      old.targetPosition != targetPosition;
}

// ─── Score Chip ───────────────────────────────────────────────────────────────
class ScoreChip extends StatelessWidget {
  final int points;
  final String label;
  final bool large;

  const ScoreChip({
    super.key,
    required this.points,
    required this.label,
    this.large = false,
  });

  @override
  Widget build(BuildContext context) {
    final size = large ? 80.0 : 56.0;
    final fontSize = large ? 22.0 : 15.0;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: _pointColor(points).withOpacity(0.15),
            shape: BoxShape.circle,
            border: Border.all(color: _pointColor(points), width: 2),
          ),
          child: Center(
            child: Text(
              '+${points * 10}',
              style: TextStyle(
                color: _pointColor(points),
                fontSize: fontSize,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
        if (label.isNotEmpty) ...[
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(color: AppColors.greyLight, fontSize: 12),
          ),
        ],
      ],
    );
  }

  Color _pointColor(int p) {
    if (p >= 4) return AppColors.orange;
    if (p >= 3) return AppColors.success;
    if (p >= 2) return const Color(0xFF4A90D9);
    if (p >= 1) return AppColors.greyLight;
    return AppColors.error;
  }
}

// ─── Top App Bar ──────────────────────────────────────────────────────────────
class ZihindarAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBack;
  final VoidCallback? onBack;
  final Widget? trailing;
  final bool showLogo;

  const ZihindarAppBar({
    super.key,
    this.title = '',
    this.showBack = true,
    this.onBack,
    this.trailing,
    this.showLogo = false,
  });

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60 + MediaQuery.of(context).padding.top,
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      color: AppColors.background,
      child: Row(
        children: [
          if (showBack)
            IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: AppColors.white,
                size: 20,
              ),
              onPressed: onBack ?? () => Navigator.of(context).maybePop(),
            )
          else
            const SizedBox(width: 16),
          if (showLogo) ...[
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.orange,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(
                child: Text(
                  'Z',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
          ],
          Expanded(
            child: Text(
              showLogo ? 'Zihindar' : title,
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          if (trailing != null) ...[
            trailing!,
            const SizedBox(width: 8),
          ] else
            const SizedBox(width: 16),
        ],
      ),
    );
  }
}

// ─── Category Card ────────────────────────────────────────────────────────────
class CategoryCard extends StatelessWidget {
  final GameCategory category;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.orange.withOpacity(0.15)
              : AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.orange : AppColors.greyDark,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(category.emoji, style: const TextStyle(fontSize: 32)),
                  const SizedBox(height: 8),
                  Text(
                    category.name,
                    style: TextStyle(
                      color: isSelected ? AppColors.orange : AppColors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            if (isSelected)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  width: 22,
                  height: 22,
                  decoration: const BoxDecoration(
                    color: AppColors.orange,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: AppColors.white,
                    size: 14,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ─── Round Progress Bar ───────────────────────────────────────────────────────
class RoundProgressBar extends StatelessWidget {
  final int current;
  final int total;

  const RoundProgressBar({
    super.key,
    required this.current,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Tur $current / $total',
              style: const TextStyle(
                color: AppColors.greyLight,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '${((current / total) * 100).round()}%',
              style: const TextStyle(
                color: AppColors.orange,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: current / total,
            minHeight: 6,
            backgroundColor: AppColors.greyDark,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.orange),
          ),
        ),
      ],
    );
  }
}

// ─── Info Chip ────────────────────────────────────────────────────────────────
class InfoChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Color? color;

  const InfoChip({super.key, required this.label, this.icon, this.color});

  @override
  Widget build(BuildContext context) {
    final clr = color ?? AppColors.greyDark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: clr.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: clr.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, color: clr, size: 14),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: TextStyle(
              color: clr,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Player Count Selector ────────────────────────────────────────────────────
class PlayerCountSelector extends StatelessWidget {
  final int count;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;

  const PlayerCountSelector({
    super.key,
    required this.count,
    this.min = 2,
    this.max = 8,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _CircleButton(
          icon: Icons.remove,
          onPressed: count > min ? () => onChanged(count - 1) : null,
        ),
        const SizedBox(width: 24),
        Column(
          children: [
            Text(
              '$count',
              style: const TextStyle(
                color: AppColors.orange,
                fontSize: 42,
                fontWeight: FontWeight.w800,
              ),
            ),
            const Text(
              'Kişi',
              style: TextStyle(color: AppColors.grey, fontSize: 13),
            ),
          ],
        ),
        const SizedBox(width: 24),
        _CircleButton(
          icon: Icons.add,
          onPressed: count < max ? () => onChanged(count + 1) : null,
        ),
      ],
    );
  }
}

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;

  const _CircleButton({required this.icon, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: enabled
              ? AppColors.surfaceLight
              : AppColors.greyDark.withOpacity(0.3),
          shape: BoxShape.circle,
          border: Border.all(
            color: enabled
                ? AppColors.greyDark
                : AppColors.greyDark.withOpacity(0.3),
          ),
        ),
        child: Icon(
          icon,
          color: enabled ? AppColors.white : AppColors.grey.withOpacity(0.3),
          size: 22,
        ),
      ),
    );
  }
}
