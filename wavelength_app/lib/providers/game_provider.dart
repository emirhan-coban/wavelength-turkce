import 'dart:math';
import 'package:flutter/foundation.dart';
import '../models/models.dart';
import '../data/game_cards.dart';

class GameProvider extends ChangeNotifier {
  GameState _state = const GameState();
  List<GameCard> _deck = [];
  int _deckIndex = 0;
  final Random _random = Random();

  GameState get state => _state;
  GamePhase get phase => _state.phase;
  List<Player> get players => _state.players;
  Player? get currentPsychic => _state.currentPsychic;
  Player? get nextPsychic => _state.nextPsychic;
  GameCard? get currentCard => _state.currentCard;
  double get targetPosition => _state.targetPosition;
  double get guessPosition => _state.guessPosition;
  int get currentRound => _state.currentRound;
  int get totalRounds => _state.totalRounds;
  List<RoundResult> get roundHistory => _state.roundHistory;
  bool get isGuessLocked => _state.isGuessLocked;

  // ─── Oyuncu Yönetimi ────────────────────────────────────────────────────────

  void setPlayerCount(int count) {
    final clampedCount = count.clamp(2, 8);
    final current = List<Player>.from(_state.players);

    while (current.length < clampedCount) {
      current.add(
        Player(
          id: 'p${current.length + 1}',
          name: 'Oyuncu ${current.length + 1}',
          avatarIndex: current.length,
        ),
      );
    }

    while (current.length > clampedCount) {
      current.removeLast();
    }

    _state = _state.copyWith(players: current);
    notifyListeners();
  }

  void updatePlayerName(int index, String name) {
    if (index < 0 || index >= _state.players.length) return;
    final updated = List<Player>.from(_state.players);
    updated[index] = updated[index].copyWith(
      name: name.trim().isEmpty ? 'Oyuncu ${index + 1}' : name.trim(),
    );
    _state = _state.copyWith(players: updated);
    notifyListeners();
  }

  void updatePlayerAvatar(int index, int avatarIndex) {
    if (index < 0 || index >= _state.players.length) return;
    final updated = List<Player>.from(_state.players);
    updated[index] = updated[index].copyWith(avatarIndex: avatarIndex);
    _state = _state.copyWith(players: updated);
    notifyListeners();
  }

  // ─── Kategori Seçimi ────────────────────────────────────────────────────────

  void toggleCategory(GameCategory category) {
    final selected = List<GameCategory>.from(_state.selectedCategories);
    if (selected.any((c) => c.type == category.type)) {
      selected.removeWhere((c) => c.type == category.type);
    } else {
      selected.add(category);
    }
    _state = _state.copyWith(selectedCategories: selected);
    notifyListeners();
  }

  bool isCategorySelected(GameCategory category) {
    return _state.selectedCategories.any((c) => c.type == category.type);
  }

  void selectAllCategories() {
    _state = _state.copyWith(selectedCategories: List.from(GameCategory.all));
    notifyListeners();
  }

  void clearCategories() {
    _state = _state.copyWith(selectedCategories: []);
    notifyListeners();
  }

  // ─── Faz Geçişleri ──────────────────────────────────────────────────────────

  void goToPhase(GamePhase phase) {
    _state = _state.copyWith(phase: phase);
    notifyListeners();
  }

  void goHome() {
    _state = const GameState();
    _deck = [];
    _deckIndex = 0;
    notifyListeners();
  }

  void startSetup() {
    if (_state.players.isEmpty) {
      setPlayerCount(4);
    }
    _state = _state.copyWith(phase: GamePhase.playerSetup);
    notifyListeners();
  }

  void goToCategorySelect() {
    if (_state.selectedCategories.isEmpty) {
      selectAllCategories();
    }
    _state = _state.copyWith(phase: GamePhase.categorySelect);
    notifyListeners();
  }

  void startGame() {
    // Kart destesini hazırla
    final categoryTypes = _state.selectedCategories.isEmpty
        ? GameCategory.all.map((c) => c.type).toList()
        : _state.selectedCategories.map((c) => c.type).toList();

    _deck = GameCards.getShuffled(categoryTypes);
    _deckIndex = 0;

    // Toplam tur sayısı = oyuncu sayısı * 2 (en az 8, en fazla 16)
    final rounds = (_state.players.length * 2).clamp(8, 16);

    // Sıfırlanmış oyuncular
    final freshPlayers = _state.players
        .map((p) => p.copyWith(score: 0))
        .toList();

    _state = _state.copyWith(
      players: freshPlayers,
      phase: GamePhase.phonePass,
      currentRound: 1,
      totalRounds: rounds,
      currentPsychicIndex: 0,
      roundHistory: [],
      isGuessLocked: false,
    );

    _prepareNextCard();
    notifyListeners();
  }

  void _prepareNextCard() {
    if (_deck.isEmpty) return;
    if (_deckIndex >= _deck.length) {
      _deck.shuffle();
      _deckIndex = 0;
    }
    final card = _deck[_deckIndex++];
    final target = _random.nextDouble() * 0.7 + 0.15; // 0.15 – 0.85 arası

    _state = _state.copyWith(
      currentCard: card,
      targetPosition: target,
      guessPosition: 0.5,
      clue: '',
      isGuessLocked: false,
    );
  }

  // ─── Psychic Aşaması ────────────────────────────────────────────────────────

  void psychicReady() {
    // Telefonu psychic'e verdik, şimdi gizli hedefi göster
    _state = _state.copyWith(phase: GamePhase.secretTarget);
    notifyListeners();
  }

  void psychicSawTarget() {
    // Psychic hedefi gördü, şimdi ipucu verme aşaması
    _state = _state.copyWith(phase: GamePhase.clueGiving);
    notifyListeners();
  }

  void setClue(String clue) {
    _state = _state.copyWith(clue: clue);
    notifyListeners();
  }

  void submitClue() {
    if (_state.clue.trim().isEmpty) return;
    _state = _state.copyWith(phase: GamePhase.groupGuess);
    notifyListeners();
  }

  // ─── Grup Tahmin Aşaması ─────────────────────────────────────────────────────

  void updateGuess(double position) {
    if (_state.isGuessLocked) return;
    _state = _state.copyWith(guessPosition: position.clamp(0.0, 1.0));
    notifyListeners();
  }

  void lockGuess() {
    _state = _state.copyWith(isGuessLocked: true);
    notifyListeners();
  }

  void submitGuess() {
    final card = _state.currentCard;
    final psychic = _state.currentPsychic;
    if (card == null || psychic == null) return;

    final points = RoundResult.calculatePoints(
      _state.targetPosition,
      _state.guessPosition,
    );

    final result = RoundResult(
      psychic: psychic,
      card: card,
      targetPosition: _state.targetPosition,
      guessPosition: _state.guessPosition,
      pointsEarned: points,
      clue: _state.clue,
    );

    // Psychic'e puan ekle (grup başarısına göre)
    final updatedPlayers = List<Player>.from(_state.players);
    final psychicIdx = _state.currentPsychicIndex % updatedPlayers.length;
    updatedPlayers[psychicIdx] = updatedPlayers[psychicIdx].copyWith(
      score: updatedPlayers[psychicIdx].score + points * 10,
    );

    // Bonus: 4 puan alırsa psychic ekstra 20 puan
    if (points == 4) {
      updatedPlayers[psychicIdx] = updatedPlayers[psychicIdx].copyWith(
        score: updatedPlayers[psychicIdx].score + 20,
      );
    }

    final updatedHistory = [..._state.roundHistory, result];

    _state = _state.copyWith(
      players: updatedPlayers,
      roundHistory: updatedHistory,
      phase: GamePhase.roundResult,
    );

    notifyListeners();
  }

  // ─── Tur Geçişi ─────────────────────────────────────────────────────────────

  void nextRound() {
    if (_state.isLastRound) {
      _state = _state.copyWith(phase: GamePhase.gameOver);
      notifyListeners();
      return;
    }

    final nextRound = _state.currentRound + 1;
    final nextPsychicIdx =
        (_state.currentPsychicIndex + 1) % _state.players.length;

    _state = _state.copyWith(
      currentRound: nextRound,
      currentPsychicIndex: nextPsychicIdx,
      phase: GamePhase.phonePass,
    );

    _prepareNextCard();
    notifyListeners();
  }

  void restartGame() {
    final freshPlayers = _state.players
        .map((p) => p.copyWith(score: 0))
        .toList();

    _state = _state.copyWith(
      players: freshPlayers,
      phase: GamePhase.categorySelect,
      currentRound: 1,
      currentPsychicIndex: 0,
      roundHistory: [],
    );

    notifyListeners();
  }

  // ─── Yardımcılar ─────────────────────────────────────────────────────────────

  int get remainingRounds => _state.totalRounds - _state.currentRound;

  double get progressPercent => _state.currentRound / _state.totalRounds;

  String get currentCategoryName {
    final card = _state.currentCard;
    if (card == null) return '';
    try {
      return GameCategory.all
          .firstWhere((c) => c.type == card.category)
          .name
          .toUpperCase();
    } catch (_) {
      return '';
    }
  }

  String get currentCategoryEmoji {
    final card = _state.currentCard;
    if (card == null) return '';
    try {
      return GameCategory.all.firstWhere((c) => c.type == card.category).emoji;
    } catch (_) {
      return '';
    }
  }

  /// Son turdaki sonuç
  RoundResult? get lastRoundResult {
    if (_state.roundHistory.isEmpty) return null;
    return _state.roundHistory.last;
  }

  /// Sıralamaya göre oyuncular
  List<Player> get leaderboard => _state.sortedPlayers;

  /// Kazanan oyuncu (oyun bittiyse)
  Player? get winner =>
      _state.phase == GamePhase.gameOver ? _state.leader : null;
}
