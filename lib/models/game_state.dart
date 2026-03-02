import 'dart:math';
import 'player.dart';
import '../data/spectrum_data.dart';

class GameState {
  final List<Player> players;
  final String categoryId;
  final int totalRounds;
  int currentRound = 0;
  int _currentLeaderIndex = 0;
  double targetPosition = 0.5;
  double? lastGuessPosition;
  int? lastScore;
  SpectrumPair? currentPair;
  final List<SpectrumPair> _availablePairs;
  final Random _random = Random();

  GameState({required this.players, required this.categoryId, int? rounds})
    : totalRounds = rounds ?? players.length * 2,
      _availablePairs = List.from(SpectrumData.getPairsForCategory(categoryId));

  Player get currentLeader => players[_currentLeaderIndex];
  int get currentLeaderIndex => _currentLeaderIndex;
  bool get isGameOver => currentRound >= totalRounds;

  String get scoreMessage {
    if (lastScore == null) return '';
    if (lastScore! >= 50) return 'Harika Bir Tahmin!';
    if (lastScore! >= 30) return 'Çok İyi!';
    if (lastScore! >= 20) return 'İyi Tahmin!';
    if (lastScore! >= 10) return 'Fena Değil!';
    return 'Bir Dahaki Sefere!';
  }

  void startNewRound() {
    currentRound++;
    _currentLeaderIndex = (currentRound - 1) % players.length;

    // Generate random target position (avoid extremes)
    targetPosition = _random.nextDouble() * 0.7 + 0.15; // 0.15 to 0.85

    // Pick a random pair
    if (_availablePairs.isEmpty) {
      _availablePairs.addAll(SpectrumData.getPairsForCategory(categoryId));
    }
    _availablePairs.shuffle(_random);
    currentPair = _availablePairs.removeLast();

    lastGuessPosition = null;
    lastScore = null;
  }

  int submitGuess(double guessPosition) {
    lastGuessPosition = guessPosition;
    double diff = (guessPosition - targetPosition).abs();

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

    lastScore = score;
    currentLeader.addScore(score);
    return score;
  }

  Player get winner => players.reduce((a, b) => a.score >= b.score ? a : b);

  List<Player> get sortedPlayers {
    final sorted = List<Player>.from(players);
    sorted.sort((a, b) => b.score.compareTo(a.score));
    return sorted;
  }

  void reset() {
    currentRound = 0;
    _currentLeaderIndex = 0;
    for (final player in players) {
      player.resetScore();
    }
    _availablePairs
      ..clear()
      ..addAll(SpectrumData.getPairsForCategory(categoryId));
    lastGuessPosition = null;
    lastScore = null;
  }
}
