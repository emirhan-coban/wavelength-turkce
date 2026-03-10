import { create } from "zustand";
import type {
  GameState,
  GamePhase,
  Player,
  GameCategory,
  GameCard,
  RoundResult,
} from "../types";
import {
  ALL_CATEGORIES,
  createPlayer,
  calculatePoints,
  getCurrentPsychic,
  isLastRound,
  getSortedPlayers,
  getLeader,
} from "../types";
import { getShuffledCards } from "../data/gameCards";

interface GameStore extends GameState {
  // Player actions
  setPlayerCount: (count: number) => void;
  updatePlayerName: (index: number, name: string) => void;
  updatePlayerAvatar: (index: number, avatarIndex: number) => void;

  // Category actions
  toggleCategory: (category: GameCategory) => void;
  selectAllCategories: () => void;
  clearCategories: () => void;
  isCategorySelected: (category: GameCategory) => boolean;

  // Phase navigation
  goToPhase: (phase: GamePhase) => void;
  goHome: () => void;
  startSetup: () => void;
  goToCategorySelect: () => void;

  // Game flow
  startGame: () => void;
  psychicReady: () => void;
  psychicSawTarget: () => void;
  setClue: (clue: string) => void;
  submitClue: () => void;
  updateGuess: (position: number) => void;
  lockGuess: () => void;
  submitGuess: () => void;
  nextRound: () => void;
  restartGame: () => void;

  // Derived helpers
  currentPsychic: () => Player | null;
  nextPsychic: () => Player | null;
  leaderboard: () => Player[];
  winner: () => Player | null;
  lastRoundResult: () => RoundResult | null;
  currentCategoryName: () => string;
  currentCategoryEmoji: () => string;
  progressPercent: () => number;
}

const initialState: GameState = {
  players: [],
  selectedCategories: [],
  phase: "home",
  currentRound: 1,
  totalRounds: 8,
  currentPsychicIndex: 0,
  currentCard: null,
  targetPosition: 0.5,
  guessPosition: 0.5,
  clue: "",
  roundHistory: [],
  isGuessLocked: false,
  deck: [],
  deckIndex: 0,
};

function prepareNextCard(
  deck: GameCard[],
  deckIndex: number,
): { card: GameCard; deck: GameCard[]; deckIndex: number; target: number } {
  let d = deck;
  let idx = deckIndex;
  if (d.length === 0 || idx >= d.length) {
    d = getShuffledCards([]);
    idx = 0;
  }
  const card = d[idx];
  const target = Math.random() * 0.7 + 0.15; // 0.15 – 0.85
  return { card, deck: d, deckIndex: idx + 1, target };
}

export const useGameStore = create<GameStore>((set, get) => ({
  ...initialState,

  // ─── Player actions ──────────────────────────────────────────────────────────

  setPlayerCount: (count) => {
    const clamped = Math.max(2, Math.min(8, count));
    const current = [...get().players];
    while (current.length < clamped) {
      current.push(createPlayer(current.length));
    }
    while (current.length > clamped) {
      current.pop();
    }
    set({ players: current });
  },

  updatePlayerName: (index, name) => {
    const players = [...get().players];
    if (index < 0 || index >= players.length) return;
    players[index] = {
      ...players[index],
      name: name.trim() === "" ? `Oyuncu ${index + 1}` : name.trim(),
    };
    set({ players });
  },

  updatePlayerAvatar: (index, avatarIndex) => {
    const players = [...get().players];
    if (index < 0 || index >= players.length) return;
    players[index] = { ...players[index], avatarIndex };
    set({ players });
  },

  // ─── Category actions ─────────────────────────────────────────────────────────

  toggleCategory: (category) => {
    const selected = [...get().selectedCategories];
    const exists = selected.some((c) => c.type === category.type);
    if (exists) {
      set({
        selectedCategories: selected.filter((c) => c.type !== category.type),
      });
    } else {
      set({ selectedCategories: [...selected, category] });
    }
  },

  selectAllCategories: () => set({ selectedCategories: [...ALL_CATEGORIES] }),
  clearCategories: () => set({ selectedCategories: [] }),
  isCategorySelected: (category) =>
    get().selectedCategories.some((c) => c.type === category.type),

  // ─── Phase navigation ─────────────────────────────────────────────────────────

  goToPhase: (phase) => set({ phase }),

  goHome: () => set({ ...initialState }),

  startSetup: () => {
    const state = get();
    if (state.players.length === 0) {
      get().setPlayerCount(4);
    }
    set({ phase: "playerSetup" });
  },

  goToCategorySelect: () => {
    const state = get();
    if (state.selectedCategories.length === 0) {
      get().selectAllCategories();
    }
    set({ phase: "categorySelect" });
  },

  // ─── Game flow ────────────────────────────────────────────────────────────────

  startGame: () => {
    const state = get();
    const categoryTypes =
      state.selectedCategories.length === 0
        ? ALL_CATEGORIES.map((c) => c.type)
        : state.selectedCategories.map((c) => c.type);

    const deck = getShuffledCards(categoryTypes);
    const rounds = Math.min(16, Math.max(8, state.players.length * 2));
    const freshPlayers = state.players.map((p) => ({ ...p, score: 0 }));
    const { card, deckIndex, target } = prepareNextCard(deck, 0);

    set({
      players: freshPlayers,
      phase: "phonePass",
      currentRound: 1,
      totalRounds: rounds,
      currentPsychicIndex: 0,
      roundHistory: [],
      isGuessLocked: false,
      deck,
      deckIndex,
      currentCard: card,
      targetPosition: target,
      guessPosition: 0.5,
      clue: "",
    });
  },

  psychicReady: () => set({ phase: "secretTarget" }),

  psychicSawTarget: () => set({ phase: "clueGiving" }),

  setClue: (clue) => set({ clue }),

  submitClue: () => {
    if (get().clue.trim() === "") return;
    set({ phase: "groupGuess" });
  },

  updateGuess: (position) => {
    if (get().isGuessLocked) return;
    set({ guessPosition: Math.max(0, Math.min(1, position)) });
  },

  lockGuess: () => set({ isGuessLocked: true }),

  submitGuess: () => {
    const state = get();
    const card = state.currentCard;
    const psychic = getCurrentPsychic(state);
    if (!card || !psychic) return;

    const points = calculatePoints(state.targetPosition, state.guessPosition);

    const result: RoundResult = {
      psychic,
      card,
      targetPosition: state.targetPosition,
      guessPosition: state.guessPosition,
      pointsEarned: points,
      clue: state.clue,
    };

    const updatedPlayers = state.players.map((p, idx) => {
      if (idx === state.currentPsychicIndex % state.players.length) {
        let bonus = points * 10;
        if (points === 4) bonus += 20;
        return { ...p, score: p.score + bonus };
      }
      return p;
    });

    set({
      players: updatedPlayers,
      roundHistory: [...state.roundHistory, result],
      phase: "roundResult",
    });
  },

  nextRound: () => {
    const state = get();
    if (isLastRound(state)) {
      set({ phase: "gameOver" });
      return;
    }

    const nextRoundNum = state.currentRound + 1;
    const nextPsychicIdx =
      (state.currentPsychicIndex + 1) % state.players.length;
    const { card, deck, deckIndex, target } = prepareNextCard(
      state.deck,
      state.deckIndex,
    );

    set({
      currentRound: nextRoundNum,
      currentPsychicIndex: nextPsychicIdx,
      phase: "phonePass",
      currentCard: card,
      deck,
      deckIndex,
      targetPosition: target,
      guessPosition: 0.5,
      clue: "",
      isGuessLocked: false,
    });
  },

  restartGame: () => {
    const state = get();
    const freshPlayers = state.players.map((p) => ({ ...p, score: 0 }));
    set({
      players: freshPlayers,
      phase: "categorySelect",
      currentRound: 1,
      currentPsychicIndex: 0,
      roundHistory: [],
      isGuessLocked: false,
    });
  },

  // ─── Derived helpers ──────────────────────────────────────────────────────────

  currentPsychic: () => getCurrentPsychic(get()),

  nextPsychic: () => {
    const state = get();
    if (state.players.length < 2) return null;
    return state.players[
      (state.currentPsychicIndex + 1) % state.players.length
    ];
  },

  leaderboard: () => getSortedPlayers(get()),

  winner: () => {
    const state = get();
    if (state.phase !== "gameOver") return null;
    return getLeader(state);
  },

  lastRoundResult: () => {
    const h = get().roundHistory;
    return h.length > 0 ? h[h.length - 1] : null;
  },

  currentCategoryName: () => {
    const card = get().currentCard;
    if (!card) return "";
    const cat = ALL_CATEGORIES.find((c) => c.type === card.category);
    return cat ? cat.name.toUpperCase() : "";
  },

  currentCategoryEmoji: () => {
    const card = get().currentCard;
    if (!card) return "";
    const cat = ALL_CATEGORIES.find((c) => c.type === card.category);
    return cat ? cat.emoji : "";
  },

  progressPercent: () => {
    const state = get();
    return state.currentRound / state.totalRounds;
  },
}));
