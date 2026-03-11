import React, { useRef, useCallback } from "react";
import { AppColors, AvatarColors, getAvatarColor } from "../types";
import type { Player, GameCategory } from "../types";

// ─── Primary Button ───────────────────────────────────────────────────────────
interface ButtonProps {
  children: React.ReactNode;
  onClick?: () => void;
  disabled?: boolean;
  variant?: "primary" | "secondary" | "danger";
  fullWidth?: boolean;
  icon?: React.ReactNode;
  className?: string;
  type?: "button" | "submit";
}

export const Button: React.FC<ButtonProps> = ({
  children,
  onClick,
  disabled = false,
  variant = "primary",
  fullWidth = true,
  icon,
  className = "",
  type = "button",
}) => {
  const base =
    "flex items-center justify-center gap-2 rounded-2xl font-bold text-base transition-all duration-200 px-6 py-4 select-none focus:outline-none active:scale-95";
  const variants = {
    primary: disabled
      ? "bg-orange-600/40 text-white/50 cursor-not-allowed"
      : "bg-orange-600 hover:bg-orange-500 text-white shadow-lg shadow-orange-600/20",
    secondary:
      "bg-transparent border border-neutral-600 hover:border-neutral-400 text-white",
    danger: "bg-red-600 hover:bg-red-500 text-white",
  };
  return (
    <button
      type={type}
      onClick={disabled ? undefined : onClick}
      className={`${base} ${variants[variant]} ${fullWidth ? "w-full" : ""} ${className}`}
    >
      {children}
      {icon && <span className="text-lg">{icon}</span>}
    </button>
  );
};

// ─── Player Avatar ────────────────────────────────────────────────────────────
interface AvatarProps {
  player: Player;
  size?: number;
  showName?: boolean;
  showScore?: boolean;
  highlighted?: boolean;
  onClick?: () => void;
}

export const Avatar: React.FC<AvatarProps> = ({
  player,
  size = 48,
  showName = false,
  showScore = false,
  highlighted = false,
  onClick,
}) => {
  const color = getAvatarColor(player);
  const initial = player.name ? player.name[0].toUpperCase() : "?";
  const borderStyle = highlighted
    ? {
      border: `3px solid ${AppColors.orange}`,
      boxShadow: `0 0 16px ${AppColors.orange}66`,
    }
    : {};

  return (
    <div
      className="flex flex-col items-center gap-1 cursor-pointer select-none"
      onClick={onClick}
    >
      <div
        style={{
          width: size,
          height: size,
          backgroundColor: color,
          borderRadius: "50%",
          display: "flex",
          alignItems: "center",
          justifyContent: "center",
          fontSize: size * 0.4,
          fontWeight: 700,
          color: "#fff",
          flexShrink: 0,
          ...borderStyle,
        }}
      >
        {initial}
      </div>
      {showName && (
        <span className="text-white text-xs font-medium truncate max-w-[60px]">
          {player.name}
        </span>
      )}
      {showScore && (
        <span className="text-neutral-400 text-[10px]">
          {player.score} puan
        </span>
      )}
    </div>
  );
};

// ─── Avatar Color Picker ──────────────────────────────────────────────────────
interface AvatarColorPickerProps {
  selectedIndex: number;
  onSelect: (index: number) => void;
}

export const AvatarColorPicker: React.FC<AvatarColorPickerProps> = ({
  selectedIndex,
  onSelect,
}) => {
  return (
    <div className="flex flex-wrap gap-3">
      {AvatarColors.map((color, i) => (
        <button
          key={i}
          onClick={() => onSelect(i)}
          style={{
            width: 44,
            height: 44,
            borderRadius: "50%",
            backgroundColor: color,
            border:
              selectedIndex === i ? `3px solid white` : "3px solid transparent",
            boxShadow: selectedIndex === i ? `0 0 12px ${color}88` : "none",
            transition: "all 0.15s",
            cursor: "pointer",
            flexShrink: 0,
          }}
        />
      ))}
    </div>
  );
};

// ─── Leaderboard Row ──────────────────────────────────────────────────────────
interface LeaderboardRowProps {
  player: Player;
  rank: number;
  highlight?: boolean;
}

export const LeaderboardRow: React.FC<LeaderboardRowProps> = ({
  player,
  rank,
  highlight = false,
}) => {
  const color = getAvatarColor(player);
  const initial = player.name ? player.name[0].toUpperCase() : "?";
  return (
    <div
      className={`flex items-center gap-3 rounded-2xl px-4 py-3 mb-2 transition-all ${highlight
        ? "bg-orange-600/15 border border-orange-600/40"
        : "bg-neutral-700/60"
        }`}
    >
      {/* Rank */}
      <div
        className="w-8 h-8 rounded-full flex items-center justify-center flex-shrink-0"
        style={{ backgroundColor: rank === 1 ? AppColors.orange : "#555" }}
      >
        {rank === 1 ? (
          <span className="text-sm">🏆</span>
        ) : (
          <span className="text-neutral-300 text-xs font-bold">{rank}</span>
        )}
      </div>
      {/* Avatar */}
      <div
        className="w-9 h-9 rounded-full flex items-center justify-center font-bold text-white flex-shrink-0"
        style={{ backgroundColor: color, fontSize: 15 }}
      >
        {initial}
      </div>
      {/* Name */}
      <div className="flex-1 min-w-0">
        <p className="text-white font-semibold text-sm truncate">
          {player.name}
        </p>
        {rank === 1 && (
          <p className="text-orange-500 text-xs font-medium">Lider</p>
        )}
      </div>
      {/* Score */}
      <div
        className="px-3 py-1 rounded-full text-sm font-bold"
        style={{
          backgroundColor: rank === 1 ? AppColors.orange : "#444",
          color: "#fff",
        }}
      >
        {player.score}
      </div>
    </div>
  );
};

// ─── Wavelength Slider ────────────────────────────────────────────────────────
interface SliderProps {
  leftLabel: string;
  rightLabel: string;
  value: number; // 0 – 1
  targetValue?: number | null; // revealed target
  interactive?: boolean;
  onChange?: (value: number) => void;
  hideGuessHandle?: boolean;
}

export const WavelengthSlider: React.FC<SliderProps> = ({
  leftLabel,
  rightLabel,
  value,
  targetValue = null,
  interactive = false,
  onChange,
  hideGuessHandle = false,
}) => {
  const containerRef = useRef<HTMLDivElement>(null);

  const getPositionFromEvent = useCallback(
    (clientX: number): number => {
      const el = containerRef.current;
      if (!el) return value;
      const rect = el.getBoundingClientRect();
      return Math.max(0, Math.min(1, (clientX - rect.left) / rect.width));
    },
    [value],
  );

  const handleMouseDown = (e: React.MouseEvent) => {
    if (!interactive || !onChange) return;
    onChange(getPositionFromEvent(e.clientX));
    const move = (me: MouseEvent) => onChange(getPositionFromEvent(me.clientX));
    const up = () => {
      document.removeEventListener("mousemove", move);
      document.removeEventListener("mouseup", up);
    };
    document.addEventListener("mousemove", move);
    document.addEventListener("mouseup", up);
  };

  const handleTouchStart = (e: React.TouchEvent) => {
    if (!interactive || !onChange) return;
    onChange(getPositionFromEvent(e.touches[0].clientX));
    const move = (te: TouchEvent) => {
      te.preventDefault();
      onChange(getPositionFromEvent(te.touches[0].clientX));
    };
    const end = () => {
      document.removeEventListener("touchmove", move);
      document.removeEventListener("touchend", end);
    };
    document.addEventListener("touchmove", move, { passive: false });
    document.addEventListener("touchend", end);
  };

  const guessPct = `${value * 100}%`;
  const targetPct = targetValue != null ? `${targetValue * 100}%` : null;

  // Track dimensions matching Flutter: 12px track height, total 80px container
  const TRACK_H = 12;
  const CONTAINER_H = 80;
  const trackTop = (CONTAINER_H - TRACK_H) / 2;
  const centerY = CONTAINER_H / 2;

  return (
    <div className="w-full select-none">
      {/* Main slider area — fixed height like Flutter's SizedBox(height: 80) */}
      <div
        ref={containerRef}
        className="relative w-full"
        style={{
          height: CONTAINER_H,
          cursor: interactive ? "pointer" : "default",
          userSelect: "none",
        }}
        onMouseDown={handleMouseDown}
        onTouchStart={handleTouchStart}
      >
        {/* ── Gradient track (centered vertically) ── */}
        <div
          className="absolute w-full rounded-full"
          style={{
            top: trackTop,
            height: TRACK_H,
            background: "linear-gradient(to right, #444, #555, #444)",
          }}
        />

        {/* ── Score zones (shown when target revealed) ── */}
        {targetPct != null && targetValue != null && (
          <>
            {[
              { halfW: 0.35, opacity: 0.15 },
              { halfW: 0.25, opacity: 0.25 },
              { halfW: 0.16, opacity: 0.4 },
              { halfW: 0.08, opacity: 0.75 },
            ].map(({ halfW, opacity }, i) => {
              const leftPct = Math.max(0, targetValue - halfW) * 100;
              const rightPct = Math.min(1, targetValue + halfW) * 100;
              return (
                <div
                  key={i}
                  className="absolute rounded-full"
                  style={{
                    top: trackTop,
                    height: TRACK_H,
                    left: `${leftPct}%`,
                    width: `${rightPct - leftPct}%`,
                    backgroundColor: AppColors.orange,
                    opacity,
                  }}
                />
              );
            })}

            {/* ── Target indicator ── */}
            <div
              className="absolute flex flex-col items-center"
              style={{
                left: targetPct,
                top: 0,
                height: CONTAINER_H,
                transform: "translateX(-50%)",
                pointerEvents: "none",
              }}
            >
              {/* "HEDEF" label */}
              <div
                className="text-[9px] font-bold tracking-widest whitespace-nowrap"
                style={{
                  color: AppColors.orange,
                  position: "absolute",
                  top: trackTop - 28,
                }}
              >
                HEDEF
              </div>
              {/* Triangle arrow pointing down to track */}
              <div
                style={{
                  position: "absolute",
                  top: trackTop - 12,
                  width: 0,
                  height: 0,
                  borderLeft: "7px solid transparent",
                  borderRight: "7px solid transparent",
                  borderTop: `10px solid ${AppColors.orange}`,
                }}
              />
              {/* Vertical line through track */}
              <div
                style={{
                  position: "absolute",
                  top: trackTop,
                  height: TRACK_H,
                  width: 2,
                  backgroundColor: AppColors.orange,
                  borderRadius: 1,
                  transform: "translateX(-0.5px)",
                }}
              />
            </div>
          </>
        )}

        {/* ── Guess handle ── */}
        {!hideGuessHandle && (
          <div
            className="absolute"
            style={{
              left: guessPct,
              top: centerY,
              transform: "translate(-50%, -50%)",
              pointerEvents: "none",
            }}
          >
            {/* Outer white circle */}
            <div
              className="rounded-full flex items-center justify-center"
              style={{
                width: 28,
                height: 28,
                backgroundColor: "white",
                boxShadow: "0 2px 10px rgba(0,0,0,0.5)",
              }}
            >
              <div
                className="rounded-full"
                style={{
                  width: 12,
                  height: 12,
                  backgroundColor: AppColors.surface,
                }}
              />
            </div>
          </div>
        )}

        {/* "TAHMİN" label below the track, centered on guess */}
        {!hideGuessHandle && (
          <div
            className="absolute text-[9px] font-bold tracking-widest whitespace-nowrap"
            style={{
              left: guessPct,
              top: trackTop + TRACK_H + 10,
              transform: "translateX(-50%)",
              color: AppColors.greyLight,
              pointerEvents: "none",
            }}
          >
            TAHMİN
          </div>
        )}
      </div>

      {/* ── Pole labels ── */}
      <div className="flex justify-between mt-2">
        <span className="text-neutral-300 text-sm font-semibold">
          {leftLabel}
        </span>
        <span className="text-neutral-300 text-sm font-semibold">
          {rightLabel}
        </span>
      </div>
    </div>
  );
};

// ─── Category Card ────────────────────────────────────────────────────────────
interface CategoryCardProps {
  category: GameCategory;
  isSelected: boolean;
  onToggle: () => void;
}

export const CategoryCard: React.FC<CategoryCardProps> = ({
  category,
  isSelected,
  onToggle,
}) => {
  return (
    <button
      onClick={onToggle}
      className="relative rounded-2xl p-4 flex flex-col items-center gap-2 transition-all duration-200 active:scale-95 border"
      style={{
        backgroundColor: isSelected
          ? `${AppColors.orange}22`
          : AppColors.surfaceLight,
        borderColor: isSelected ? AppColors.orange : AppColors.greyDark,
        borderWidth: isSelected ? 2 : 1,
      }}
    >
      {isSelected && (
        <div
          className="absolute top-2 right-2 w-5 h-5 rounded-full flex items-center justify-center"
          style={{ backgroundColor: AppColors.orange }}
        >
          <span className="text-white text-xs">✓</span>
        </div>
      )}
      <span className="text-3xl">{category.emoji}</span>
      <span
        className="text-sm font-semibold text-center"
        style={{ color: isSelected ? AppColors.orange : AppColors.white }}
      >
        {category.name}
      </span>
    </button>
  );
};

// ─── Round Progress Bar ───────────────────────────────────────────────────────
interface ProgressBarProps {
  current: number;
  total: number;
}

export const RoundProgressBar: React.FC<ProgressBarProps> = ({
  current,
  total,
}) => {
  const percent = Math.round((current / total) * 100);
  return (
    <div className="w-full">
      <div className="flex justify-between mb-2">
        <span className="text-neutral-400 text-xs font-medium">
          Tur {current} / {total}
        </span>
        <span className="text-orange-500 text-xs font-semibold">
          {percent}%
        </span>
      </div>
      <div
        className="w-full rounded-full overflow-hidden"
        style={{ height: 6, backgroundColor: AppColors.greyDark }}
      >
        <div
          className="h-full rounded-full transition-all duration-500"
          style={{ width: `${percent}%`, backgroundColor: AppColors.orange }}
        />
      </div>
    </div>
  );
};

// ─── Card Poles Display ───────────────────────────────────────────────────────
interface CardPolesProps {
  leftLabel: string;
  rightLabel: string;
}

export const CardPolesDisplay: React.FC<CardPolesProps> = ({
  leftLabel,
  rightLabel,
}) => {
  return (
    <div
      className="flex items-stretch rounded-2xl border"
      style={{
        backgroundColor: AppColors.surfaceLight,
        borderColor: AppColors.greyDark,
      }}
    >
      <div className="flex-1 p-4">
        <p
          className="text-[9px] font-bold tracking-widest mb-1"
          style={{ color: AppColors.grey }}
        >
          BAŞLANGIÇ
        </p>
        <p className="text-white text-base font-bold">{leftLabel}</p>
      </div>
      <div
        className="w-px self-stretch my-3"
        style={{ backgroundColor: AppColors.greyDark }}
      />
      <div className="flex-1 p-4 text-right">
        <p
          className="text-[9px] font-bold tracking-widest mb-1"
          style={{ color: AppColors.grey }}
        >
          BİTİŞ
        </p>
        <p className="text-white text-base font-bold">{rightLabel}</p>
      </div>
    </div>
  );
};

// ─── Info Chip ────────────────────────────────────────────────────────────────
interface ChipProps {
  label: string;
  icon?: string;
  color?: string;
}

export const InfoChip: React.FC<ChipProps> = ({
  label,
  icon,
  color = AppColors.greyDark,
}) => {
  return (
    <span
      className="inline-flex items-center gap-1 rounded-full px-3 py-1 text-xs font-semibold"
      style={{
        backgroundColor: `${color}33`,
        border: `1px solid ${color}88`,
        color,
      }}
    >
      {icon && <span>{icon}</span>}
      {label}
    </span>
  );
};

// ─── Player Count Selector ────────────────────────────────────────────────────
interface PlayerCountSelectorProps {
  count: number;
  min?: number;
  max?: number;
  onChange: (count: number) => void;
}

export const PlayerCountSelector: React.FC<PlayerCountSelectorProps> = ({
  count,
  min = 2,
  max = 8,
  onChange,
}) => {
  return (
    <div className="flex items-center gap-6 justify-center">
      <button
        onClick={() => count > min && onChange(count - 1)}
        disabled={count <= min}
        className="w-12 h-12 rounded-full border flex items-center justify-center transition-all"
        style={{
          borderColor: count > min ? AppColors.greyDark : "#333",
          backgroundColor: AppColors.surfaceLight,
          color: count > min ? AppColors.white : AppColors.greyDark,
          opacity: count <= min ? 0.4 : 1,
        }}
      >
        <span className="text-xl font-bold">−</span>
      </button>
      <div className="text-center">
        <span
          className="block text-5xl font-extrabold"
          style={{ color: AppColors.orange }}
        >
          {count}
        </span>
        <span className="text-neutral-400 text-sm">Kişi</span>
      </div>
      <button
        onClick={() => count < max && onChange(count + 1)}
        disabled={count >= max}
        className="w-12 h-12 rounded-full border flex items-center justify-center transition-all"
        style={{
          borderColor: count < max ? AppColors.greyDark : "#333",
          backgroundColor: AppColors.surfaceLight,
          color: count < max ? AppColors.white : AppColors.greyDark,
          opacity: count >= max ? 0.4 : 1,
        }}
      >
        <span className="text-xl font-bold">+</span>
      </button>
    </div>
  );
};

// ─── Category Badge ───────────────────────────────────────────────────────────
interface CategoryBadgeProps {
  name: string;
  emoji: string;
}

export const CategoryBadge: React.FC<CategoryBadgeProps> = ({
  name,
  emoji,
}) => (
  <span
    className="inline-flex items-center gap-1 rounded-full px-3 py-1"
    style={{
      backgroundColor: `${AppColors.orange}22`,
      border: `1px solid ${AppColors.orange}66`,
    }}
  >
    <span className="text-xs">{emoji}</span>
    <span
      className="text-[10px] font-bold tracking-wider"
      style={{ color: AppColors.orange }}
    >
      KATEGORİ: {name}
    </span>
  </span>
);

// ─── Section Title ────────────────────────────────────────────────────────────
export const SectionTitle: React.FC<{ children: React.ReactNode }> = ({
  children,
}) => (
  <p
    className="text-[10px] font-bold tracking-widest uppercase mb-3"
    style={{ color: AppColors.grey }}
  >
    {children}
  </p>
);

// ─── Pulsing Avatar ───────────────────────────────────────────────────────────
export const PulsingAvatar: React.FC<{ player: Player }> = ({ player }) => {
  const color = getAvatarColor(player);
  const initial = player.name ? player.name[0].toUpperCase() : "?";
  return (
    <div className="flex items-center justify-center">
      <div className="relative flex items-center justify-center">
        {/* Outer glow */}
        <div
          className="absolute rounded-full animate-ping"
          style={{
            width: 140,
            height: 140,
            backgroundColor: color,
            opacity: 0.1,
          }}
        />
        {/* Mid ring */}
        <div
          className="absolute rounded-full"
          style={{
            width: 120,
            height: 120,
            border: `2px solid ${color}55`,
            backgroundColor: `${color}22`,
          }}
        />
        {/* Main avatar */}
        <div
          className="relative rounded-full flex items-center justify-center font-extrabold text-white"
          style={{
            width: 96,
            height: 96,
            backgroundColor: color,
            fontSize: 40,
            boxShadow: `0 0 30px ${color}66`,
          }}
        >
          {initial}
          {/* Phone badge */}
          <div
            className="absolute -bottom-1 -right-1 w-8 h-8 rounded-full flex items-center justify-center border-2"
            style={{
              backgroundColor: AppColors.orange,
              borderColor: AppColors.background,
            }}
          >
            <span className="text-xs">📱</span>
          </div>
        </div>
      </div>
    </div>
  );
};

// ─── Clue Display Box ─────────────────────────────────────────────────────────
interface ClueDisplayProps {
  clue: string;
  psychic: Player;
}

export const ClueDisplay: React.FC<ClueDisplayProps> = ({ clue, psychic }) => {
  const color = getAvatarColor(psychic);
  const initial = psychic.name ? psychic.name[0].toUpperCase() : "?";
  return (
    <div
      className="w-full rounded-2xl p-5 border"
      style={{
        backgroundColor: `${AppColors.orange}18`,
        borderColor: `${AppColors.orange}55`,
      }}
    >
      <div className="flex items-center gap-2 mb-3">
        <div
          className="w-7 h-7 rounded-full flex items-center justify-center font-bold text-white text-xs flex-shrink-0"
          style={{ backgroundColor: color }}
        >
          {initial}
        </div>
        <span className="text-neutral-400 text-xs">
          {psychic.name} diyor ki:
        </span>
      </div>
      <p className="text-white text-xl font-bold italic leading-snug">
        "{clue}"
      </p>
    </div>
  );
};

// ─── App Bar ──────────────────────────────────────────────────────────────────
interface AppBarProps {
  title?: string;
  showBack?: boolean;
  onBack?: () => void;
  trailing?: React.ReactNode;
  showLogo?: boolean;
}

export const AppBar: React.FC<AppBarProps> = ({
  title,
  showBack = true,
  onBack,
  trailing,
  showLogo = false,
}) => {
  return (
    <div
      className="flex items-center px-4 py-3 gap-3"
      style={{ backgroundColor: AppColors.background }}
    >
      {showBack ? (
        <button
          onClick={onBack}
          className="w-9 h-9 rounded-full flex items-center justify-center transition-all active:scale-90"
          style={{ backgroundColor: AppColors.surfaceLight }}
        >
          <span className="text-white text-sm">←</span>
        </button>
      ) : (
        <div className="w-9" />
      )}

      <div className="flex-1 flex items-center gap-2">
        {showLogo && (
          <div
            className="w-8 h-8 rounded-xl flex items-center justify-center font-black text-white text-lg"
            style={{ backgroundColor: AppColors.orange }}
          >
            Z
          </div>
        )}
        <span className="text-white font-bold text-base">
          {showLogo ? "Zihindar" : title}
        </span>
      </div>

      {trailing ? <div>{trailing}</div> : <div className="w-9" />}
    </div>
  );
};

// ─── Modal Bottom Sheet ───────────────────────────────────────────────────────
interface BottomSheetProps {
  isOpen: boolean;
  onClose: () => void;
  children: React.ReactNode;
  title?: string;
}

export const BottomSheet: React.FC<BottomSheetProps> = ({
  isOpen,
  onClose,
  children,
  title,
}) => {
  if (!isOpen) return null;
  return (
    <div
      className="fixed inset-0 z-50 flex items-end"
      style={{ backgroundColor: "rgba(0,0,0,0.6)" }}
      onClick={onClose}
    >
      <div
        className="w-full rounded-t-3xl max-h-[85vh] overflow-y-auto"
        style={{ backgroundColor: AppColors.surface }}
        onClick={(e) => e.stopPropagation()}
      >
        <div className="flex justify-center pt-3 pb-1">
          <div
            className="w-10 h-1 rounded-full"
            style={{ backgroundColor: AppColors.greyDark }}
          />
        </div>
        {title && (
          <div className="px-6 pt-4 pb-2">
            <h2 className="text-white font-bold text-lg">{title}</h2>
          </div>
        )}
        <div className="px-6 pb-8">{children}</div>
      </div>
    </div>
  );
};
