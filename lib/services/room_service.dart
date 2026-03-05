import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/spectrum_data.dart';

class RoomService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  static final Random _random = Random();

  /// 6 haneli benzersiz oda kodu oluştur
  static String _generateRoomCode() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    return List.generate(6, (_) => chars[_random.nextInt(chars.length)]).join();
  }

  /// Oda oluştur
  static Future<String> createRoom({
    required String hostUid,
    required String hostName,
  }) async {
    String roomCode;
    bool exists = true;

    // Benzersiz kod bul
    do {
      roomCode = _generateRoomCode();
      final doc = await _db.collection('rooms').doc(roomCode).get();
      exists = doc.exists;
    } while (exists);

    await _db.collection('rooms').doc(roomCode).set({
      'hostUid': hostUid,
      'status': 'waiting', // waiting, playing, finished
      'phase':
          'lobby', // lobby, category_select, showing_target, waiting_clue, guessing, results, game_over
      'categoryId': null,
      'totalRounds': 0,
      'currentRound': 0,
      'currentLeaderIndex': 0,
      'targetPosition': 0,
      'clue': null,
      'currentPair': null,
      'createdAt': FieldValue.serverTimestamp(),
      'players': [
        {
          'uid': hostUid,
          'name': hostName,
          'score': 0,
          'order': 0,
          'isConnected': true,
        },
      ],
      'guesses': {},
      'usedPairIndices': [],
    });

    return roomCode;
  }

  /// Odaya katıl
  static Future<bool> joinRoom({
    required String roomCode,
    required String uid,
    required String name,
  }) async {
    final ref = _db.collection('rooms').doc(roomCode);

    return _db.runTransaction<bool>((transaction) async {
      final doc = await transaction.get(ref);
      if (!doc.exists) return false;

      final data = doc.data()!;
      if (data['status'] != 'waiting') return false;

      final players = List<Map<String, dynamic>>.from(data['players'] ?? []);

      // Zaten varsa güncelle
      final existingIdx = players.indexWhere((p) => p['uid'] == uid);
      if (existingIdx >= 0) {
        players[existingIdx]['isConnected'] = true;
        players[existingIdx]['name'] = name;
      } else {
        if (players.length >= 8) return false;
        players.add({
          'uid': uid,
          'name': name,
          'score': 0,
          'order': players.length,
          'isConnected': true,
        });
      }

      transaction.update(ref, {'players': players});
      return true;
    });
  }

  /// Odadan ayrıl
  static Future<void> leaveRoom({
    required String roomCode,
    required String uid,
  }) async {
    final ref = _db.collection('rooms').doc(roomCode);

    await _db.runTransaction((transaction) async {
      final doc = await transaction.get(ref);
      if (!doc.exists) return;

      final data = doc.data()!;
      final players = List<Map<String, dynamic>>.from(data['players'] ?? []);
      players.removeWhere((p) => p['uid'] == uid);

      if (players.isEmpty) {
        transaction.delete(ref);
      } else {
        // Eğer host çıktıysa, yeni host ata
        String hostUid = data['hostUid'];
        if (hostUid == uid) {
          hostUid = players.first['uid'];
        }
        transaction.update(ref, {'players': players, 'hostUid': hostUid});
      }
    });
  }

  /// Oda stream'i
  static Stream<DocumentSnapshot<Map<String, dynamic>>> roomStream(
    String roomCode,
  ) {
    return _db.collection('rooms').doc(roomCode).snapshots();
  }

  /// Kategori seç ve oyunu başlat (sadece host)
  static Future<void> startGame({
    required String roomCode,
    required String categoryId,
  }) async {
    final ref = _db.collection('rooms').doc(roomCode);
    final doc = await ref.get();
    final players = List<Map<String, dynamic>>.from(
      doc.data()!['players'] ?? [],
    );
    final totalRounds = players.length * 2;

    // İlk turu hazırla
    final pairs = SpectrumData.getPairsForCategory(categoryId);
    pairs.shuffle(_random);
    final firstPair = pairs.first;
    final targetPosition = _random.nextDouble() * 0.7 + 0.15;

    // Tüm oyuncu skorlarını sıfırla
    for (var p in players) {
      p['score'] = 0;
    }

    await ref.update({
      'status': 'playing',
      'phase': 'showing_target',
      'categoryId': categoryId,
      'totalRounds': totalRounds,
      'currentRound': 1,
      'currentLeaderIndex': 0,
      'targetPosition': targetPosition,
      'clue': null,
      'currentPair': {
        'leftConcept': firstPair.leftConcept,
        'rightConcept': firstPair.rightConcept,
        'categoryId': firstPair.categoryId,
      },
      'players': players,
      'guesses': {},
      'usedPairIndices': [0],
    });
  }

  /// Lider ipucu gönder
  static Future<void> submitClue({
    required String roomCode,
    required String clue,
  }) async {
    await _db.collection('rooms').doc(roomCode).update({
      'clue': clue,
      'phase': 'guessing',
      'guesses': {},
    });
  }

  /// Oyuncu tahmin gönder
  static Future<void> submitGuess({
    required String roomCode,
    required String uid,
    required double guessPosition,
  }) async {
    final ref = _db.collection('rooms').doc(roomCode);

    await _db.runTransaction((transaction) async {
      final doc = await transaction.get(ref);
      if (!doc.exists) return;

      final data = doc.data()!;
      final target = (data['targetPosition'] as num).toDouble();
      final guesses = Map<String, dynamic>.from(data['guesses'] ?? {});
      final players = List<Map<String, dynamic>>.from(data['players'] ?? []);
      final leaderIndex = data['currentLeaderIndex'] as int;

      // Skor hesapla
      double diff = (guessPosition - target).abs();
      int score;
      if (diff <= 0.05) {
        score = 50;
      } else if (diff <= 0.12) {
        score = 30;
      } else if (diff <= 0.20) {
        score = 20;
      } else if (diff <= 0.35) {
        score = 10;
      } else {
        score = 0;
      }

      guesses[uid] = {'position': guessPosition, 'score': score};

      // Liderin skoruna ekle (tüm tahminlerin ortalaması değil, takım puanı)
      // Wavelength'de lider'e puan gider
      // Burada her oyuncuya kendi puanını verelim
      for (var p in players) {
        if (p['uid'] == uid) {
          p['score'] = (p['score'] as int) + score;
          break;
        }
      }

      // Tüm oyuncular (lider hariç) tahmin etti mi?
      int expectedGuessCount = players.length - 1; // lider hariç
      bool allGuessed = guesses.length >= expectedGuessCount;

      Map<String, dynamic> updateData = {
        'guesses': guesses,
        'players': players,
      };

      if (allGuessed) {
        updateData['phase'] = 'results';
      }

      transaction.update(ref, updateData);
    });
  }

  /// Sonraki tura geç (sadece host)
  static Future<void> nextRound({required String roomCode}) async {
    final ref = _db.collection('rooms').doc(roomCode);

    await _db.runTransaction((transaction) async {
      final doc = await transaction.get(ref);
      if (!doc.exists) return;

      final data = doc.data()!;
      final currentRound = data['currentRound'] as int;
      final totalRounds = data['totalRounds'] as int;
      final players = List<Map<String, dynamic>>.from(data['players'] ?? []);
      final categoryId = data['categoryId'] as String;
      final usedIndices = List<int>.from(data['usedPairIndices'] ?? []);

      if (currentRound >= totalRounds) {
        transaction.update(ref, {'phase': 'game_over', 'status': 'finished'});
        return;
      }

      // Yeni pair seç
      final allPairs = SpectrumData.getPairsForCategory(categoryId);
      int newPairIdx;
      if (usedIndices.length >= allPairs.length) {
        usedIndices.clear();
      }
      do {
        newPairIdx = _random.nextInt(allPairs.length);
      } while (usedIndices.contains(newPairIdx));

      final newPair = allPairs[newPairIdx];
      usedIndices.add(newPairIdx);

      final newLeaderIndex = currentRound % players.length;
      final newTarget = _random.nextDouble() * 0.7 + 0.15;

      transaction.update(ref, {
        'currentRound': currentRound + 1,
        'currentLeaderIndex': newLeaderIndex,
        'targetPosition': newTarget,
        'clue': null,
        'phase': 'showing_target',
        'currentPair': {
          'leftConcept': newPair.leftConcept,
          'rightConcept': newPair.rightConcept,
          'categoryId': newPair.categoryId,
        },
        'guesses': {},
        'usedPairIndices': usedIndices,
      });
    });
  }

  /// Oyunu yeniden başlat
  static Future<void> restartGame({required String roomCode}) async {
    final ref = _db.collection('rooms').doc(roomCode);
    final doc = await ref.get();
    if (!doc.exists) return;

    final data = doc.data()!;
    final players = List<Map<String, dynamic>>.from(data['players'] ?? []);

    for (var p in players) {
      p['score'] = 0;
    }

    await ref.update({
      'status': 'waiting',
      'phase': 'lobby',
      'currentRound': 0,
      'currentLeaderIndex': 0,
      'targetPosition': 0,
      'clue': null,
      'currentPair': null,
      'guesses': {},
      'usedPairIndices': [],
      'players': players,
      'categoryId': null,
    });
  }

  /// Odayı sil
  static Future<void> deleteRoom(String roomCode) async {
    await _db.collection('rooms').doc(roomCode).delete();
  }
}
