import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../theme/app_theme.dart';
import '../../services/auth_service.dart';
import '../../services/room_service.dart';
import 'online_target_screen.dart';
import 'online_clue_screen.dart';
import 'online_waiting_screen.dart';
import 'online_guess_screen.dart';
import 'online_result_screen.dart';
import 'online_game_over_screen.dart';

class OnlineGameController extends StatelessWidget {
  final String roomCode;
  const OnlineGameController({super.key, required this.roomCode});

  @override
  Widget build(BuildContext context) {
    final uid = AuthService.currentUser!.uid;

    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: RoomService.roomStream(roomCode),
      builder: (context, snapshot) {
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Oda kapatıldı',
                    style: TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Navigator.of(
                      context,
                    ).popUntil((route) => route.isFirst),
                    child: const Text('Ana Menü'),
                  ),
                ],
              ),
            ),
          );
        }

        final data = snapshot.data!.data()!;
        final phase = data['phase'] as String? ?? 'lobby';
        final players = List<Map<String, dynamic>>.from(data['players'] ?? []);
        final leaderIndex = data['currentLeaderIndex'] as int? ?? 0;
        final isLeader =
            leaderIndex < players.length && players[leaderIndex]['uid'] == uid;

        switch (phase) {
          case 'showing_target':
            if (isLeader) {
              return OnlineTargetScreen(roomCode: roomCode, data: data);
            } else {
              return OnlineWaitingScreen(
                roomCode: roomCode,
                data: data,
                message: 'Lider hedefi görüyor...',
                submessage: '${players[leaderIndex]['name']} hedefi inceliyor',
              );
            }

          case 'waiting_clue':
            if (isLeader) {
              return OnlineClueScreen(roomCode: roomCode, data: data);
            } else {
              return OnlineWaitingScreen(
                roomCode: roomCode,
                data: data,
                message: 'İpucu bekleniyor...',
                submessage: '${players[leaderIndex]['name']} ipucu yazıyor',
              );
            }

          case 'guessing':
            if (isLeader) {
              final guesses = Map<String, dynamic>.from(data['guesses'] ?? {});
              return OnlineWaitingScreen(
                roomCode: roomCode,
                data: data,
                message: 'Tahminler bekleniyor...',
                submessage:
                    '${guesses.length}/${players.length - 1} oyuncu tahmin yaptı',
              );
            } else {
              final guesses = Map<String, dynamic>.from(data['guesses'] ?? {});
              if (guesses.containsKey(uid)) {
                return OnlineWaitingScreen(
                  roomCode: roomCode,
                  data: data,
                  message: 'Tahminin gönderildi!',
                  submessage:
                      '${guesses.length}/${players.length - 1} oyuncu tahmin yaptı',
                );
              }
              return OnlineGuessScreen(roomCode: roomCode, data: data);
            }

          case 'results':
            return OnlineResultScreen(roomCode: roomCode, data: data);

          case 'game_over':
            return OnlineGameOverScreen(roomCode: roomCode, data: data);

          default:
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(
                      color: AppTheme.primaryOrange,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Yükleniyor... ($phase)',
                      style: const TextStyle(color: AppTheme.textSecondary),
                    ),
                  ],
                ),
              ),
            );
        }
      },
    );
  }
}
