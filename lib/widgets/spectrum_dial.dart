import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SpectrumDial extends StatelessWidget {
  final double value;
  final double? targetValue;
  final ValueChanged<double>? onChanged;

  const SpectrumDial({
    super.key,
    required this.value,
    this.targetValue,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final knobLeft = (value * (width - 26)).clamp(0.0, width - 26);
        final targetLeft = targetValue != null
            ? (targetValue! * (width - 12)).clamp(0.0, width - 12)
            : null;

        return SizedBox(
          height: 54,
          child: GestureDetector(
            onPanDown: onChanged == null
                ? null
                : (details) => _update(details.localPosition.dx, width),
            onPanUpdate: onChanged == null
                ? null
                : (details) => _update(details.localPosition.dx, width),
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  right: 0,
                  top: 22,
                  child: Container(
                    height: 8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(999),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF4A2D1C), AppTheme.blueTrack],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: width * (1 - value),
                  top: 22,
                  child: Container(
                    height: 8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(999),
                      gradient: const LinearGradient(
                        colors: [
                          AppTheme.primaryOrange,
                          AppTheme.primaryOrangeLight,
                        ],
                      ),
                    ),
                  ),
                ),
                if (targetLeft != null)
                  Positioned(
                    left: targetLeft,
                    top: 18,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: const BoxDecoration(
                        color: AppTheme.cyan,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        size: 9,
                        color: AppTheme.background,
                      ),
                    ),
                  ),
                Positioned(
                  left: knobLeft,
                  top: 11,
                  child: Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.primaryOrange,
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primaryOrange.withValues(alpha: 0.45),
                          blurRadius: 14,
                          spreadRadius: 1,
                        ),
                      ],
                      border: Border.all(color: AppTheme.background, width: 2),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _update(double localX, double width) {
    final normalized = (localX / width).clamp(0.0, 1.0);
    onChanged?.call(normalized);
  }
}
