import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/target_indicator.dart';
import '../../services/room_service.dart';

class OnlineTargetScreen extends StatelessWidget {
  final String roomCode;
  final Map<String, dynamic> data;

  const OnlineTargetScreen({
    super.key,
    required this.roomCode,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final target = (data['targetPosition'] as num).toDouble();
    final categoryLabel = (data['categoryId'] as String).toUpperCase();

    return Scaffold(
      appBar: AppBar(title: const Text('Gizli Hedef')),
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
            const SizedBox(height: 22),
            const Text(
              'Hedef Belirlendi',
              style: TextStyle(
                fontSize: 40,
                height: 1,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Bu hedefi sadece sen görebilirsin',
              style: TextStyle(color: AppTheme.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 18),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
              decoration: BoxDecoration(
                color: AppTheme.cardColor,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppTheme.divider),
              ),
              child: Column(
                children: [TargetIndicator(targetPosition: target)],
              ),
            ),
            const SizedBox(height: 26),
            _buildPairInfo(),
            const SizedBox(height: 10),
            const Text(
              'Bu kavram çifti için hedefe uygun\nbir ipucu düşün.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 13,
                height: 1.4,
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () async {
                await RoomService.advanceToCluePhase(roomCode: roomCode);
              },
              child: const Text('İpucu Yaz'),
            ),
            const SizedBox(height: 8),
            Text(
              'ONLINE LİDER EKRANI',
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

  Widget _buildPairInfo() {
    final pair = data['currentPair'] as Map<String, dynamic>?;
    if (pair == null) return const SizedBox();

    return Column(
      children: [
        const Text(
          'Kavram Çifti',
          style: TextStyle(
            fontSize: 14,
            color: AppTheme.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '${pair['leftConcept']} ↔ ${pair['rightConcept']}',
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: AppTheme.primaryOrange,
          ),
        ),
      ],
    );
  }
}
