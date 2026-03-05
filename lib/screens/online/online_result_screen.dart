import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/auth_service.dart';
import '../../services/room_service.dart';
import '../../widgets/spectrum_dial.dart';

class OnlineResultScreen extends StatelessWidget {
  final String roomCode;
  final Map<String, dynamic> data;

  const OnlineResultScreen({
    super.key,
    required this.roomCode,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final target = (data['targetPosition'] as num).toDouble();
    final guesses = Map<String, dynamic>.from(data['guesses'] ?? {});
    final players = List<Map<String, dynamic>>.from(data['players'] ?? []);
    final hostUid = data['hostUid'] as String;
    final uid = AuthService.currentUser!.uid;
    final isHost = uid == hostUid;
    final currentRound = data['currentRound'] as int? ?? 0;
    final totalRounds = data['totalRounds'] as int? ?? 0;

    // Kendi tahminimi bul
    final myGuess = guesses[uid];
    final myPosition = myGuess != null
        ? (myGuess['position'] as num).toDouble()
        : null;
    final myScore = myGuess != null ? myGuess['score'] as int : null;

    // Ortalama skor
    int totalScore = 0;
    guesses.forEach((_, v) => totalScore += (v['score'] as int));
    final avgScore = guesses.isNotEmpty
        ? (totalScore / guesses.length).round()
        : 0;

    String feedback;
    Color feedbackColor;
    if (avgScore >= 30) {
      feedback = 'Mükemmel! 🎯';
      feedbackColor = AppTheme.success;
    } else if (avgScore >= 10) {
      feedback = 'İyi Tahmin! 👍';
      feedbackColor = AppTheme.primaryOrange;
    } else {
      feedback = 'Uzak Kaldı 😅';
      feedbackColor = AppTheme.error;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Sonuç - Tur $currentRound/$totalRounds'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 14),
            // Feedback banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppTheme.primaryOrange.withValues(alpha: 0.34),
                    AppTheme.cyan.withValues(alpha: 0.24),
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    feedback,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: feedbackColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Ortalama: $avgScore puan',
                    style: TextStyle(
                      color: AppTheme.textSecondary.withValues(alpha: 0.9),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // Spectrum - ortalama tahmini göster (veya kendi tahminimi)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(14, 16, 14, 12),
              decoration: BoxDecoration(
                color: AppTheme.cardColor,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: [
                  SpectrumDial(
                    value: myPosition ?? 0.5,
                    targetValue: target,
                    onChanged: null,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        myScore != null ? 'SENİN TAHMİNİN' : 'TAHMİN',
                        style: TextStyle(
                          color: AppTheme.primaryOrange.withValues(alpha: 0.95),
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const Spacer(),
                      const Text(
                        'HEDEF',
                        style: TextStyle(
                          color: AppTheme.cyan,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // Tüm oyuncuların puanları
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.cardColor,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: ListView(
                  children: guesses.entries.map((entry) {
                    final playerUid = entry.key;
                    final guess = entry.value;
                    final score = guess['score'] as int;
                    final playerName = players.firstWhere(
                      (p) => p['uid'] == playerUid,
                      orElse: () => {'name': '?'},
                    )['name'];
                    final isMe = playerUid == uid;

                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      margin: const EdgeInsets.only(bottom: 4),
                      decoration: BoxDecoration(
                        color: isMe
                            ? AppTheme.primaryOrange.withValues(alpha: 0.1)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: AppTheme.primaryOrange.withValues(
                                alpha: 0.2,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                playerName[0].toUpperCase(),
                                style: const TextStyle(
                                  color: AppTheme.primaryOrange,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              '$playerName${isMe ? " (Sen)" : ""}',
                              style: const TextStyle(
                                color: AppTheme.textPrimary,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Text(
                            '+$score',
                            style: TextStyle(
                              color: score >= 30
                                  ? AppTheme.success
                                  : score >= 10
                                  ? AppTheme.primaryOrange
                                  : AppTheme.textSecondary,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Sonraki tur butonu (sadece host)
            if (isHost)
              ElevatedButton(
                onPressed: () async {
                  await RoomService.nextRound(roomCode: roomCode);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      currentRound >= totalRounds
                          ? 'Sonuçları Gör'
                          : 'Sonraki Tur',
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward, size: 18),
                  ],
                ),
              )
            else
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppTheme.tealBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.cyan.withValues(alpha: 0.3),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppTheme.cyan,
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Host sonraki turu başlatacak...',
                      style: TextStyle(
                        color: AppTheme.cyan,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 14),
          ],
        ),
      ),
    );
  }
}
