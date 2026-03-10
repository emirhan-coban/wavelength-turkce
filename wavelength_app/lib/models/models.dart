import 'package:flutter/material.dart';

// ─── Renkler & Tema ───────────────────────────────────────────────────────────
class AppColors {
  static const Color background = Color(0xFF1A1A1A);
  static const Color surface = Color(0xFF242424);
  static const Color surfaceLight = Color(0xFF2E2E2E);
  static const Color orange = Color(0xFFFF6B00);
  static const Color orangeLight = Color(0xFFFF8C00);
  static const Color orangeDark = Color(0xFFE55A00);
  static const Color white = Color(0xFFFFFFFF);
  static const Color grey = Color(0xFF888888);
  static const Color greyLight = Color(0xFFAAAAAA);
  static const Color greyDark = Color(0xFF444444);
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE53935);
  static const Color cardBg = Color(0xFF2A2A2A);
  static const Color divider = Color(0xFF333333);
}

// ─── Oyuncu Modeli ────────────────────────────────────────────────────────────
class Player {
  final String id;
  String name;
  int score;
  int avatarIndex;

  Player({
    required this.id,
    required this.name,
    this.score = 0,
    this.avatarIndex = 0,
  });

  Player copyWith({String? name, int? score, int? avatarIndex}) {
    return Player(
      id: id,
      name: name ?? this.name,
      score: score ?? this.score,
      avatarIndex: avatarIndex ?? this.avatarIndex,
    );
  }

  static List<Color> avatarColors = [
    AppColors.orange,
    const Color(0xFF4A90D9),
    const Color(0xFF7B68EE),
    const Color(0xFF50C878),
    const Color(0xFFFF6B9D),
    const Color(0xFFFFD700),
    const Color(0xFF00CED1),
    const Color(0xFFFF7F50),
  ];

  Color get avatarColor => avatarColors[avatarIndex % avatarColors.length];
}

// ─── Kategori Modeli ──────────────────────────────────────────────────────────
enum CategoryType {
  eglence,
  maceraci,
  zihinOyunlari,
  klasik,
  rekabetci,
  sosyal,
}

class GameCategory {
  final CategoryType type;
  final String name;
  final String emoji;
  final String description;

  const GameCategory({
    required this.type,
    required this.name,
    required this.emoji,
    required this.description,
  });

  static const List<GameCategory> all = [
    GameCategory(
      type: CategoryType.eglence,
      name: 'Eğlence',
      emoji: '🎉',
      description: 'Eğlenceli ve komik kartlar',
    ),
    GameCategory(
      type: CategoryType.maceraci,
      name: 'Maceracı',
      emoji: '⚔️',
      description: 'Cesur ve macera dolu kartlar',
    ),
    GameCategory(
      type: CategoryType.zihinOyunlari,
      name: 'Zihin Oyunları',
      emoji: '🧠',
      description: 'Zekâ ve strateji kartları',
    ),
    GameCategory(
      type: CategoryType.klasik,
      name: 'Klasik',
      emoji: '📚',
      description: 'Klasik wavelength kartları',
    ),
    GameCategory(
      type: CategoryType.rekabetci,
      name: 'Rekabetçi',
      emoji: '🏆',
      description: 'Rekabetçi ve yarışmacı kartlar',
    ),
    GameCategory(
      type: CategoryType.sosyal,
      name: 'Sosyal',
      emoji: '👥',
      description: 'Sosyal ve grup kartları',
    ),
  ];
}

// ─── Oyun Kartı Modeli ────────────────────────────────────────────────────────
class GameCard {
  final String id;
  final String leftLabel;
  final String rightLabel;
  final CategoryType category;

  const GameCard({
    required this.id,
    required this.leftLabel,
    required this.rightLabel,
    required this.category,
  });
}

// ─── Tur Sonucu ───────────────────────────────────────────────────────────────
class RoundResult {
  final Player psychic; // İpucu veren oyuncu
  final GameCard card;
  final double targetPosition; // 0.0 – 1.0 (gizli hedef)
  final double guessPosition; // 0.0 – 1.0 (grup tahmini)
  final int pointsEarned;
  final String clue;

  const RoundResult({
    required this.psychic,
    required this.card,
    required this.targetPosition,
    required this.guessPosition,
    required this.pointsEarned,
    required this.clue,
  });

  /// Hedefe olan mesafeye göre puan hesapla
  static int calculatePoints(double target, double guess) {
    final distance = (target - guess).abs();
    if (distance <= 0.08) return 4; // Tam isabet
    if (distance <= 0.16) return 3; // Çok yakın
    if (distance <= 0.25) return 2; // Yakın
    if (distance <= 0.35) return 1; // Fena değil
    return 0;
  }

  String get resultLabel {
    final distance = (targetPosition - guessPosition).abs();
    if (distance <= 0.08) return 'Mükemmel!';
    if (distance <= 0.16) return 'Harika Bir Tahmin!';
    if (distance <= 0.25) return 'İyi Tahmin!';
    if (distance <= 0.35) return 'Fena Değil!';
    return 'Kaçırdınız!';
  }
}

// ─── Oyun Aşamaları ───────────────────────────────────────────────────────────
enum GamePhase {
  home, // Ana ekran
  playerSetup, // Oyuncu ayarları
  categorySelect, // Kategori seçimi
  phonePass, // Telefonu ver (psychic'e)
  secretTarget, // Psychic gizli hedefi görüyor
  clueGiving, // Psychic ipucu veriyor (diğerleri görmez)
  groupGuess, // Grup tahmin yapıyor
  roundResult, // Tur sonucu
  gameOver, // Oyun bitti
}

// ─── Ana Oyun Durumu ─────────────────────────────────────────────────────────
class GameState {
  final List<Player> players;
  final List<GameCategory> selectedCategories;
  final GamePhase phase;
  final int currentRound;
  final int totalRounds;
  final int currentPsychicIndex;
  final GameCard? currentCard;
  final double targetPosition; // Psychic'in gizli hedefi
  final double guessPosition; // Grup ibresi
  final String clue;
  final List<RoundResult> roundHistory;
  final bool isGuessLocked;
  final int maxScore;

  const GameState({
    this.players = const [],
    this.selectedCategories = const [],
    this.phase = GamePhase.home,
    this.currentRound = 1,
    this.totalRounds = 8,
    this.currentPsychicIndex = 0,
    this.currentCard,
    this.targetPosition = 0.5,
    this.guessPosition = 0.5,
    this.clue = '',
    this.roundHistory = const [],
    this.isGuessLocked = false,
    this.maxScore = 200,
  });

  Player? get currentPsychic =>
      players.isEmpty ? null : players[currentPsychicIndex % players.length];

  Player? get leader {
    if (players.isEmpty) return null;
    return players.reduce((a, b) => a.score > b.score ? a : b);
  }

  Player? get nextPsychic {
    if (players.length < 2) return null;
    return players[(currentPsychicIndex + 1) % players.length];
  }

  List<Player> get sortedPlayers {
    final sorted = List<Player>.from(players);
    sorted.sort((a, b) => b.score.compareTo(a.score));
    return sorted;
  }

  bool get isLastRound => currentRound >= totalRounds;

  GameState copyWith({
    List<Player>? players,
    List<GameCategory>? selectedCategories,
    GamePhase? phase,
    int? currentRound,
    int? totalRounds,
    int? currentPsychicIndex,
    GameCard? currentCard,
    double? targetPosition,
    double? guessPosition,
    String? clue,
    List<RoundResult>? roundHistory,
    bool? isGuessLocked,
    int? maxScore,
  }) {
    return GameState(
      players: players ?? this.players,
      selectedCategories: selectedCategories ?? this.selectedCategories,
      phase: phase ?? this.phase,
      currentRound: currentRound ?? this.currentRound,
      totalRounds: totalRounds ?? this.totalRounds,
      currentPsychicIndex: currentPsychicIndex ?? this.currentPsychicIndex,
      currentCard: currentCard ?? this.currentCard,
      targetPosition: targetPosition ?? this.targetPosition,
      guessPosition: guessPosition ?? this.guessPosition,
      clue: clue ?? this.clue,
      roundHistory: roundHistory ?? this.roundHistory,
      isGuessLocked: isGuessLocked ?? this.isGuessLocked,
      maxScore: maxScore ?? this.maxScore,
    );
  }
}
