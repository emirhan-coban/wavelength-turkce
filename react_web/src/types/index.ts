// ─── Colors ───────────────────────────────────────────────────────────────────
export const AppColors = {
  background: '#1A1A1A',
  surface: '#242424',
  surfaceLight: '#2E2E2E',
  orange: '#FF6B00',
  orangeLight: '#FF8C00',
  orangeDark: '#E55A00',
  white: '#FFFFFF',
  grey: '#888888',
  greyLight: '#AAAAAA',
  greyDark: '#444444',
  success: '#4CAF50',
  error: '#E53935',
  cardBg: '#2A2A2A',
  divider: '#333333',
} as const;

export const AvatarColors = [
  '#FF6B00',
  '#4A90D9',
  '#7B68EE',
  '#50C878',
  '#FF6B9D',
  '#FFD700',
  '#00CED1',
  '#FF7F50',
];

// ─── Player ───────────────────────────────────────────────────────────────────
export interface Player {
  id: string;
  name: string;
  score: number;
  avatarIndex: number;
}

export function getAvatarColor(player: Player): string {
  return AvatarColors[player.avatarIndex % AvatarColors.length];
}

export function createPlayer(index: number): Player {
  return {
    id: `p${index + 1}`,
    name: `Oyuncu ${index + 1}`,
    score: 0,
    avatarIndex: index % AvatarColors.length,
  };
}

// ─── Category ─────────────────────────────────────────────────────────────────
export type CategoryType =
  | 'eglence'
  | 'maceraci'
  | 'zihinOyunlari'
  | 'klasik'
  | 'rekabetci'
  | 'sosyal';

export interface GameCategory {
  type: CategoryType;
  name: string;
  emoji: string;
  description: string;
}

export const ALL_CATEGORIES: GameCategory[] = [
  {
    type: 'eglence',
    name: 'Eğlence',
    emoji: '🎉',
    description: 'Eğlenceli ve komik kartlar',
  },
  {
    type: 'maceraci',
    name: 'Maceracı',
    emoji: '⚔️',
    description: 'Cesur ve macera dolu kartlar',
  },
  {
    type: 'zihinOyunlari',
    name: 'Zihin Oyunları',
    emoji: '🧠',
    description: 'Zekâ ve strateji kartları',
  },
  {
    type: 'klasik',
    name: 'Klasik',
    emoji: '📚',
    description: 'Klasik wavelength kartları',
  },
  {
    type: 'rekabetci',
    name: 'Rekabetçi',
    emoji: '🏆',
    description: 'Rekabetçi ve yarışmacı kartlar',
  },
  {
    type: 'sosyal',
    name: 'Sosyal',
    emoji: '👥',
    description: 'Sosyal ve grup kartları',
  },
];

// ─── Game Card ────────────────────────────────────────────────────────────────
export interface GameCard {
  id: string;
  leftLabel: string;
  rightLabel: string;
  category: CategoryType;
}

// ─── Round Result ─────────────────────────────────────────────────────────────
export interface RoundResult {
  psychic: Player;
  card: GameCard;
  targetPosition: number; // 0.0 – 1.0
  guessPosition: number;  // 0.0 – 1.0
  pointsEarned: number;   // 0, 1, 2, 3, or 4
  clue: string;
}

export function calculatePoints(target: number, guess: number): number {
  const distance = Math.abs(target - guess);
  if (distance <= 0.08) return 4;
  if (distance <= 0.16) return 3;
  if (distance <= 0.25) return 2;
  if (distance <= 0.35) return 1;
  return 0;
}

export function getResultLabel(points: number): string {
  if (points >= 4) return 'Mükemmel!';
  if (points >= 3) return 'Harika Bir Tahmin!';
  if (points >= 2) return 'İyi Tahmin!';
  if (points >= 1) return 'Fena Değil!';
  return 'Kaçırdınız!';
}

export function getResultSubtitle(points: number): string {
  if (points >= 4) return 'İnanılmaz! Tam isabet! 🎯';
  if (points >= 3) return 'Çok iyi bir senkronizasyon! ⚡';
  if (points >= 2) return 'Fena değil, biraz daha çalışın!';
  if (points >= 1) return 'Eh işte, daha iyisi olabilirdi.';
  return 'Maalesef bu sefer olmadı. 😅';
}

export function getResultColor(points: number): string {
  if (points >= 4) return AppColors.orange;
  if (points >= 3) return AppColors.success;
  if (points >= 2) return '#4A90D9';
  if (points >= 1) return AppColors.greyLight;
  return AppColors.error;
}

// ─── Game Phase ───────────────────────────────────────────────────────────────
export type GamePhase =
  | 'home'
  | 'playerSetup'
  | 'categorySelect'
  | 'phonePass'
  | 'secretTarget'
  | 'clueGiving'
  | 'groupGuess'
  | 'roundResult'
  | 'gameOver';

// ─── Game State ───────────────────────────────────────────────────────────────
export interface GameState {
  players: Player[];
  selectedCategories: GameCategory[];
  phase: GamePhase;
  currentRound: number;
  totalRounds: number;
  currentPsychicIndex: number;
  currentCard: GameCard | null;
  targetPosition: number;
  guessPosition: number;
  clue: string;
  roundHistory: RoundResult[];
  isGuessLocked: boolean;
  deck: GameCard[];
  deckIndex: number;
}

export function getCurrentPsychic(state: GameState): Player | null {
  if (state.players.length === 0) return null;
  return state.players[state.currentPsychicIndex % state.players.length];
}

export function getNextPsychic(state: GameState): Player | null {
  if (state.players.length < 2) return null;
  return state.players[(state.currentPsychicIndex + 1) % state.players.length];
}

export function getSortedPlayers(state: GameState): Player[] {
  return [...state.players].sort((a, b) => b.score - a.score);
}

export function getLeader(state: GameState): Player | null {
  if (state.players.length === 0) return null;
  return [...state.players].sort((a, b) => b.score - a.score)[0];
}

export function isLastRound(state: GameState): boolean {
  return state.currentRound >= state.totalRounds;
}
