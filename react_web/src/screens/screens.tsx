import React, { useState, useRef, useEffect } from "react";
import { motion } from "framer-motion";
import { useGameStore } from "../store/gameStore";
import {
  Button,
  AvatarColorPicker,
  LeaderboardRow,
  WavelengthSlider,
  CategoryCard,
  RoundProgressBar,
  CardPolesDisplay,
  InfoChip,
  PlayerCountSelector,
  CategoryBadge,
  SectionTitle,
  PulsingAvatar,
  ClueDisplay,
  AppBar,
  BottomSheet,
} from "../components/ui";
import {
  AppColors,
  ALL_CATEGORIES,
  getAvatarColor,
  getResultLabel,
  getResultSubtitle,
  getResultColor,
} from "../types";

const fadeUp = {
  initial: { opacity: 0, y: 24 },
  animate: { opacity: 1, y: 0 },
  exit: { opacity: 0, y: -24 },
  transition: { duration: 0.3, ease: [0.25, 0.46, 0.45, 0.94] as const },
};

// ═══════════════════════════════════════════════════════════════════════════════
// HOME SCREEN
// ═══════════════════════════════════════════════════════════════════════════════
export const HomeScreen: React.FC = () => {
  const { startSetup } = useGameStore();
  const [howToOpen, setHowToOpen] = useState(false);

  return (
    <motion.div {...fadeUp} className="flex flex-col h-full px-6 pb-8">
      {/* Top bar */}
      <div className="flex items-center justify-between pt-6 pb-4">
        <div className="flex items-center gap-3">
          <div
            className="w-10 h-10 rounded-xl flex items-center justify-center font-black text-white text-xl"
            style={{ backgroundColor: AppColors.orange }}
          >
            Z
          </div>
          <span className="text-white font-extrabold text-xl">Zihindar</span>
        </div>
        <button
          onClick={() => setHowToOpen(true)}
          className="w-10 h-10 rounded-full flex items-center justify-center"
          style={{ backgroundColor: AppColors.surfaceLight }}
        >
          <span className="text-neutral-400 text-base">ℹ</span>
        </button>
      </div>

      {/* Hero card */}
      <div
        className="relative w-full rounded-3xl overflow-hidden mb-5"
        style={{
          height: 200,
          background: `linear-gradient(135deg, ${AppColors.orange}44, ${AppColors.surfaceLight}, ${AppColors.surface})`,
        }}
      >
        {/* Decorative circles */}
        <div
          className="absolute -right-8 -top-8 rounded-full"
          style={{
            width: 150,
            height: 150,
            backgroundColor: `${AppColors.orange}14`,
          }}
        />
        <div
          className="absolute right-8 top-5 rounded-full"
          style={{
            width: 80,
            height: 80,
            backgroundColor: `${AppColors.orange}1e`,
          }}
        />
        {/* Emoji */}
        <div className="absolute right-6 top-1/2 -translate-y-1/2 flex flex-col items-center gap-1">
          <span className="text-4xl">🧠</span>
          <span className="text-2xl">⚡</span>
        </div>
        {/* Text */}
        <div className="absolute bottom-0 left-0 p-6">
          <h1 className="text-white font-extrabold text-2xl leading-tight mb-1">
            Kelime Avı
          </h1>
          <p className="text-white/70 text-sm mb-3 leading-snug">
            Arkadaşlarınla
            <br />
            eğlenceye hazır mısın?
          </p>
          <div className="flex gap-2">
            <InfoChip label="2-8 Oyuncu" icon="👥" color={AppColors.orange} />
            <InfoChip label="15 Dakika" icon="⏱" color={AppColors.greyLight} />
          </div>
        </div>
      </div>

      {/* Stats */}
      <div className="grid grid-cols-3 gap-3 mb-6">
        {[
          { emoji: "🎴", value: "100+", label: "Kart" },
          { emoji: "🏆", value: "6", label: "Kategori" },
          { emoji: "🌙", value: "Offline", label: "Parti Modu" },
        ].map((s) => (
          <div
            key={s.label}
            className="rounded-2xl p-3 flex flex-col items-center gap-1"
            style={{ backgroundColor: AppColors.surfaceLight }}
          >
            <span className="text-xl">{s.emoji}</span>
            <span className="text-white font-bold text-sm">{s.value}</span>
            <span className="text-neutral-500 text-[10px]">{s.label}</span>
          </div>
        ))}
      </div>

      <div className="flex-1" />

      {/* Buttons */}
      <div className="flex flex-col gap-3">
        <Button onClick={startSetup} icon="▶">
          Oyuna Başla
        </Button>
        <Button variant="secondary" onClick={() => setHowToOpen(true)} icon="?">
          Nasıl Oynanır?
        </Button>
      </div>

      {/* How to play sheet */}
      <BottomSheet
        isOpen={howToOpen}
        onClose={() => setHowToOpen(false)}
        title="Nasıl Oynanır?"
      >
        <HowToPlayContent />
      </BottomSheet>
    </motion.div>
  );
};

const HowToPlayContent: React.FC = () => {
  const steps = [
    {
      n: "1",
      title: "Psişik Seçilir",
      desc: "Her turda bir oyuncu psişik olur. Telefon o oyuncuya verilir.",
      emoji: "🧙",
    },
    {
      n: "2",
      title: "Gizli Hedef",
      desc: "Psişik, spektrum üzerindeki gizli hedef noktasını görür. Başka kimse göremez!",
      emoji: "🎯",
    },
    {
      n: "3",
      title: "İpucu Ver",
      desc: "Psişik, kartın iki kutbu arasındaki spektrumda hedefin konumunu anlatan bir kelime veya cümle söyler.",
      emoji: "💬",
    },
    {
      n: "4",
      title: "Grup Tahmin Eder",
      desc: "Gruptaki diğer oyuncular tartışarak ibrenin nereye yerleştirileceğine karar verir.",
      emoji: "👥",
    },
    {
      n: "5",
      title: "Puan Hesaplanır",
      desc: "İbre hedefe ne kadar yakınsa o kadar çok puan! Tam isabette +40 puan.",
      emoji: "⭐",
    },
  ];

  const points = [
    { label: "Tam İsabet", pts: "+40", color: AppColors.orange },
    { label: "Çok Yakın", pts: "+30", color: AppColors.success },
    { label: "Yakın", pts: "+20", color: "#4A90D9" },
    { label: "Fena Değil", pts: "+10", color: AppColors.greyLight },
    { label: "Kaçırdınız", pts: "+0", color: AppColors.error },
  ];

  return (
    <div className="pt-2">
      {steps.map((s) => (
        <div key={s.n} className="flex gap-3 mb-5">
          <div
            className="w-9 h-9 rounded-full flex items-center justify-center font-extrabold text-white flex-shrink-0 text-base"
            style={{ backgroundColor: AppColors.orange }}
          >
            {s.n}
          </div>
          <div>
            <p className="text-white font-bold text-sm mb-1">
              {s.title} {s.emoji}
            </p>
            <p className="text-neutral-400 text-xs leading-relaxed">{s.desc}</p>
          </div>
        </div>
      ))}
      <div
        className="rounded-2xl p-4 mt-2"
        style={{ backgroundColor: AppColors.surfaceLight }}
      >
        <p className="text-white font-bold text-sm mb-3">Puan Tablosu</p>
        {points.map((p) => (
          <div key={p.label} className="flex justify-between items-center mb-2">
            <div className="flex items-center gap-2">
              <div
                className="w-2.5 h-2.5 rounded-full"
                style={{ backgroundColor: p.color }}
              />
              <span className="text-neutral-400 text-xs">{p.label}</span>
            </div>
            <span className="font-bold text-sm" style={{ color: p.color }}>
              {p.pts}
            </span>
          </div>
        ))}
      </div>
    </div>
  );
};

// ═══════════════════════════════════════════════════════════════════════════════
// PLAYER SETUP SCREEN
// ═══════════════════════════════════════════════════════════════════════════════
export const PlayerSetupScreen: React.FC = () => {
  const {
    players,
    setPlayerCount,
    updatePlayerName,
    updatePlayerAvatar,
    goHome,
    goToCategorySelect,
  } = useGameStore();
  const [editingAvatar, setEditingAvatar] = useState<number | null>(null);

  return (
    <motion.div {...fadeUp} className="flex flex-col h-full">
      <AppBar title="Oyuncuları Ayarla" onBack={goHome} />

      <div className="flex-1 overflow-y-auto px-6 pb-4">
        {/* Player count */}
        <div className="py-6 text-center">
          <p
            className="text-[11px] font-bold tracking-widest mb-4"
            style={{ color: AppColors.orange }}
          >
            OYUNCU SAYISI
          </p>
          <PlayerCountSelector
            count={players.length}
            min={2}
            max={8}
            onChange={setPlayerCount}
          />
        </div>

        <div
          className="h-px mb-6"
          style={{ backgroundColor: AppColors.divider }}
        />

        {/* Player names */}
        <div className="flex items-center justify-between mb-4">
          <p className="text-white font-bold">Oyuncu İsimleri</p>
        </div>

        <div className="flex flex-col gap-3">
          {players.map((player, index) => (
            <PlayerNameRow
              key={player.id}
              index={index}
              player={player}
              onNameChange={(name) => updatePlayerName(index, name)}
              onAvatarClick={() => setEditingAvatar(index)}
            />
          ))}
        </div>

        {/* Info */}
        <div
          className="flex gap-2 items-start rounded-xl p-3 mt-5 border"
          style={{
            backgroundColor: AppColors.surfaceLight,
            borderColor: AppColors.greyDark,
          }}
        >
          <span className="text-neutral-500 text-sm mt-0.5">ℹ</span>
          <p className="text-neutral-400 text-xs leading-relaxed">
            {players.length} oyuncu seçildi. Herkes hazırsa oyuna
            başlayabilirsiniz.
          </p>
        </div>
      </div>

      {/* Bottom button */}
      <div className="px-6 pb-8 pt-2">
        <Button onClick={goToCategorySelect} icon="→">
          Oyuna Başla
        </Button>
      </div>

      {/* Avatar picker sheet */}
      <BottomSheet
        isOpen={editingAvatar !== null}
        onClose={() => setEditingAvatar(null)}
        title="Renk Seç"
      >
        {editingAvatar !== null && (
          <div className="pt-2">
            <AvatarColorPicker
              selectedIndex={players[editingAvatar]?.avatarIndex ?? 0}
              onSelect={(i) => {
                updatePlayerAvatar(editingAvatar, i);
                setEditingAvatar(null);
              }}
            />
          </div>
        )}
      </BottomSheet>
    </motion.div>
  );
};

const PlayerNameRow: React.FC<{
  index: number;
  player: { id: string; name: string; score: number; avatarIndex: number };
  onNameChange: (name: string) => void;
  onAvatarClick: () => void;
}> = ({ index, player, onNameChange, onAvatarClick }) => {
  const color = getAvatarColor(player);
  const [localName, setLocalName] = useState(player.name);

  return (
    <div
      className="flex items-center gap-3 px-4 py-3 rounded-2xl"
      style={{ backgroundColor: AppColors.surfaceLight }}
    >
      <span className="text-neutral-500 text-sm font-semibold w-5">
        {index + 1}.
      </span>
      <button onClick={onAvatarClick} className="relative flex-shrink-0">
        <div
          className="w-10 h-10 rounded-full flex items-center justify-center font-bold text-white text-base"
          style={{ backgroundColor: color }}
        >
          {player.name ? player.name[0].toUpperCase() : "?"}
        </div>
        <div
          className="absolute -bottom-0.5 -right-0.5 w-4 h-4 rounded-full flex items-center justify-center"
          style={{ backgroundColor: AppColors.greyDark }}
        >
          <span className="text-white text-[8px]">✏</span>
        </div>
      </button>
      <input
        className="flex-1 bg-transparent text-white text-sm font-medium outline-none placeholder-neutral-600"
        value={localName}
        onChange={(e) => {
          setLocalName(e.target.value);
          onNameChange(e.target.value);
        }}
        placeholder={`Oyuncu ${index + 1}`}
      />
    </div>
  );
};

// ═══════════════════════════════════════════════════════════════════════════════
// CATEGORY SELECT SCREEN
// ═══════════════════════════════════════════════════════════════════════════════
export const CategorySelectScreen: React.FC = () => {
  const {
    selectedCategories,
    toggleCategory,
    selectAllCategories,
    clearCategories,
    isCategorySelected,
    goToPhase,
    startGame,
  } = useGameStore();

  const allSelected = selectedCategories.length === ALL_CATEGORIES.length;

  return (
    <motion.div {...fadeUp} className="flex flex-col h-full">
      <AppBar title="Kategori Seç" onBack={() => goToPhase("playerSetup")} />

      <div className="flex-1 overflow-y-auto px-6 pb-4">
        {/* Header */}
        <div className="flex items-end justify-between py-4">
          <div>
            <p className="text-neutral-400 text-sm">Oynamak istediğiniz</p>
            <p className="text-white font-bold text-lg">kategorileri seçin</p>
            <p className="text-neutral-500 text-xs mt-1">
              {selectedCategories.length} / {ALL_CATEGORIES.length} seçildi
            </p>
          </div>
          <button
            onClick={allSelected ? clearCategories : selectAllCategories}
            className="px-3 py-2 rounded-full text-xs font-semibold border"
            style={{
              backgroundColor: allSelected
                ? `${AppColors.orange}22`
                : AppColors.surfaceLight,
              borderColor: allSelected ? AppColors.orange : AppColors.greyDark,
              color: allSelected ? AppColors.orange : AppColors.greyLight,
            }}
          >
            {allSelected ? "Tümünü Kaldır" : "Tümünü Seç"}
          </button>
        </div>

        {/* Category grid */}
        <div className="grid grid-cols-2 gap-3 mb-5">
          {ALL_CATEGORIES.map((cat) => (
            <CategoryCard
              key={cat.type}
              category={cat}
              isSelected={isCategorySelected(cat)}
              onToggle={() => toggleCategory(cat)}
            />
          ))}
        </div>

        {/* Preview / warning */}
        {selectedCategories.length === 0 ? (
          <div
            className="flex items-center gap-2 rounded-xl p-3 border"
            style={{
              backgroundColor: `${AppColors.error}18`,
              borderColor: `${AppColors.error}55`,
            }}
          >
            <span className="text-yellow-400">⚠</span>
            <p className="text-red-400 text-xs">
              En az bir kategori seçmelisiniz.
            </p>
          </div>
        ) : (
          <div
            className="rounded-2xl p-4 border"
            style={{
              backgroundColor: AppColors.surfaceLight,
              borderColor: AppColors.greyDark,
            }}
          >
            <div className="flex items-center gap-2 mb-3">
              <span className="text-green-400 text-sm">✓</span>
              <p className="text-neutral-400 text-xs font-semibold">
                Seçilen Kategoriler
              </p>
            </div>
            <div className="flex flex-wrap gap-2">
              {selectedCategories.map((cat) => (
                <span
                  key={cat.type}
                  className="inline-flex items-center gap-1 px-3 py-1 rounded-full text-xs font-semibold border"
                  style={{
                    backgroundColor: `${AppColors.orange}18`,
                    borderColor: `${AppColors.orange}55`,
                    color: AppColors.orange,
                  }}
                >
                  {cat.emoji} {cat.name}
                </span>
              ))}
            </div>
          </div>
        )}
      </div>

      {/* Bottom button */}
      <div className="px-6 pb-8 pt-2">
        <Button
          onClick={startGame}
          disabled={selectedCategories.length === 0}
          icon="→"
        >
          Devam Et
        </Button>
      </div>
    </motion.div>
  );
};

// ═══════════════════════════════════════════════════════════════════════════════
// PHONE PASS SCREEN
// ═══════════════════════════════════════════════════════════════════════════════
export const PhonePassScreen: React.FC = () => {
  const { currentRound, totalRounds, players, psychicReady, goHome } =
    useGameStore();
  const psychic = useGameStore((s) => s.currentPsychic());

  if (!psychic) return null;

  return (
    <motion.div {...fadeUp} className="flex flex-col h-full">
      <AppBar
        title="Sıra Değişimi"
        onBack={goHome}
        trailing={
          <span
            className="px-3 py-1 rounded-full text-xs font-semibold"
            style={{
              backgroundColor: AppColors.surfaceLight,
              color: AppColors.greyLight,
            }}
          >
            {currentRound} / {totalRounds}
          </span>
        }
      />

      <div className="flex-1 flex flex-col px-7 pb-6">
        <div className="pt-4 pb-6">
          <RoundProgressBar current={currentRound} total={totalRounds} />
        </div>

        <div className="flex-1 flex flex-col items-center justify-center gap-8">
          <PulsingAvatar player={psychic} />

          <div className="text-center">
            <h2 className="text-white font-extrabold text-2xl leading-snug">
              Telefonu{" "}
              <span style={{ color: AppColors.orange }}>{psychic.name}</span>
              {"'e\nVer"}
            </h2>
          </div>

          <div
            className="flex items-center gap-2 px-4 py-2 rounded-xl"
            style={{ backgroundColor: AppColors.surfaceLight }}
          >
            <span className="text-neutral-500 text-sm">🔒</span>
            <p className="text-neutral-400 text-xs">
              Sadece {psychic.name} bakmalı!
            </p>
          </div>

          <p className="text-neutral-500 text-xs text-center">
            Diğer {players.length - 1} oyuncunun görmediğinden emin ol.
          </p>
        </div>

        {/* Players preview */}
        <div className="flex justify-center gap-4 py-4">
          {players.map((p) => {
            const isPsychic = p.id === psychic.id;
            const color = getAvatarColor(p);
            return (
              <div key={p.id} className="flex flex-col items-center gap-1">
                <div
                  className="rounded-full flex items-center justify-center font-bold text-white transition-all"
                  style={{
                    width: isPsychic ? 52 : 40,
                    height: isPsychic ? 52 : 40,
                    backgroundColor: color,
                    fontSize: isPsychic ? 20 : 15,
                    border: isPsychic
                      ? `3px solid ${AppColors.orange}`
                      : "none",
                    boxShadow: isPsychic
                      ? `0 0 16px ${AppColors.orange}66`
                      : "none",
                  }}
                >
                  {p.name ? p.name[0].toUpperCase() : "?"}
                </div>
                <span
                  className="text-[10px] font-semibold"
                  style={{
                    color: isPsychic ? AppColors.orange : AppColors.grey,
                  }}
                >
                  {isPsychic ? "🧠" : p.name.split(" ")[0]}
                </span>
              </div>
            );
          })}
        </div>

        <Button onClick={psychicReady} icon="👁">
          Hazırım
        </Button>
      </div>
    </motion.div>
  );
};

// ═══════════════════════════════════════════════════════════════════════════════
// SECRET TARGET SCREEN
// ═══════════════════════════════════════════════════════════════════════════════
export const SecretTargetScreen: React.FC = () => {
  const {
    targetPosition,
    currentCard,
    psychicSawTarget,
    goToPhase,
    currentCategoryName,
    currentCategoryEmoji,
  } = useGameStore();
  const psychic = useGameStore((s) => s.currentPsychic());
  const [revealed, setRevealed] = useState(false);

  if (!currentCard || !psychic) return null;

  return (
    <motion.div {...fadeUp} className="flex flex-col h-full">
      <AppBar
        title="Gizli Hedef"
        onBack={() => goToPhase("phonePass")}
        trailing={
          <CategoryBadge
            name={currentCategoryName()}
            emoji={currentCategoryEmoji()}
          />
        }
      />

      <div className="flex-1 flex flex-col px-6 pb-6">
        {/* Card poles */}
        <div className="pt-4 pb-6">
          <CardPolesDisplay
            leftLabel={currentCard.leftLabel}
            rightLabel={currentCard.rightLabel}
          />
        </div>

        <div className="flex-1 flex flex-col items-center justify-center gap-6">
          {!revealed ? (
            <button
              onClick={() => setRevealed(true)}
              className="flex flex-col items-center gap-4 active:scale-95 transition-all"
            >
              <div
                className="w-28 h-28 rounded-full flex items-center justify-center border-2"
                style={{
                  backgroundColor: `${AppColors.orange}22`,
                  borderColor: AppColors.orange,
                }}
              >
                <span className="text-5xl">🙈</span>
              </div>
              <p className="text-neutral-400 text-base text-center leading-snug">
                Hedefi Görmek İçin
                <br />
                Ekrana Dokun
              </p>
              <p
                className="font-semibold text-sm"
                style={{ color: AppColors.orange }}
              >
                Sadece {psychic.name} bakmalı!
              </p>
            </button>
          ) : (
            <motion.div
              initial={{ opacity: 0, scale: 0.9 }}
              animate={{ opacity: 1, scale: 1 }}
              className="w-full flex flex-col gap-5"
            >
              <div className="text-center">
                <h2 className="text-white font-bold text-xl">
                  Hedef Belirlendi
                </h2>
                <p className="text-neutral-400 text-sm mt-1">
                  Bu pozisyonu kimseye gösterme
                </p>
              </div>
              <WavelengthSlider
                leftLabel={currentCard.leftLabel}
                rightLabel={currentCard.rightLabel}
                value={targetPosition}
                targetValue={targetPosition}
                interactive={false}
              />
              <div
                className="flex items-start gap-3 rounded-2xl p-4 border"
                style={{
                  backgroundColor: `${AppColors.orange}18`,
                  borderColor: `${AppColors.orange}55`,
                }}
              >
                <span className="text-orange-500 text-base mt-0.5">💡</span>
                <p className="text-neutral-300 text-xs leading-relaxed">
                  Hedefe ne kadar yaklaştığını kontrol et ve bunu anlatan bir
                  ipucu düşün!
                </p>
              </div>
            </motion.div>
          )}
        </div>

        <Button onClick={psychicSawTarget} disabled={!revealed} icon="→">
          Hazırım
        </Button>
      </div>
    </motion.div>
  );
};

// ═══════════════════════════════════════════════════════════════════════════════
// CLUE GIVING SCREEN
// ═══════════════════════════════════════════════════════════════════════════════
export const ClueGivingScreen: React.FC = () => {
  const {
    clue,
    setClue,
    submitClue,
    currentCard,
    goToPhase,
    currentCategoryName,
    currentCategoryEmoji,
  } = useGameStore();
  const psychic = useGameStore((s) => s.currentPsychic());
  const inputRef = useRef<HTMLTextAreaElement>(null);

  useEffect(() => {
    setTimeout(() => inputRef.current?.focus(), 200);
  }, []);

  if (!currentCard || !psychic) return null;

  return (
    <motion.div {...fadeUp} className="flex flex-col h-full">
      <AppBar
        title="Sıra Değişimi"
        onBack={() => goToPhase("secretTarget")}
        trailing={
          <CategoryBadge
            name={currentCategoryName()}
            emoji={currentCategoryEmoji()}
          />
        }
      />

      <div className="flex-1 overflow-y-auto px-6 pb-4">
        <div className="pt-4 pb-5">
          <CardPolesDisplay
            leftLabel={currentCard.leftLabel}
            rightLabel={currentCard.rightLabel}
          />
        </div>

        {/* Spectrum bar (no target) */}
        <div className="pb-6">
          <WavelengthSlider
            leftLabel={currentCard.leftLabel}
            rightLabel={currentCard.rightLabel}
            value={0.5}
            interactive={false}
          />
        </div>

        {/* Psychic info */}
        <div className="flex items-center gap-3 mb-5">
          <div
            className="w-11 h-11 rounded-full flex items-center justify-center font-bold text-white text-lg flex-shrink-0"
            style={{ backgroundColor: getAvatarColor(psychic) }}
          >
            {psychic.name ? psychic.name[0].toUpperCase() : "?"}
          </div>
          <div>
            <p className="text-white font-bold text-sm">{psychic.name}</p>
            <p className="text-neutral-400 text-xs">ipucunu yazıyor...</p>
          </div>
        </div>

        {/* Clue input */}
        <div
          className="rounded-2xl px-4 py-3 border mb-4 transition-all"
          style={{
            backgroundColor: AppColors.surfaceLight,
            borderColor: clue.trim() ? AppColors.orange : AppColors.greyDark,
            borderWidth: clue.trim() ? 2 : 1,
          }}
        >
          <textarea
            ref={inputRef}
            className="w-full bg-transparent text-white text-lg font-semibold outline-none resize-none placeholder-neutral-600"
            rows={3}
            value={clue}
            onChange={(e) => setClue(e.target.value)}
            placeholder="İpucunu buraya yaz..."
          />
        </div>

        {/* Rules */}
        <div
          className="rounded-2xl p-4 border"
          style={{
            backgroundColor: AppColors.surface,
            borderColor: AppColors.greyDark,
          }}
        >
          <div className="flex items-center gap-2 mb-3">
            <span style={{ color: AppColors.orange }} className="text-sm">
              📋
            </span>
            <p
              className="font-bold text-xs"
              style={{ color: AppColors.orange }}
            >
              Kurallar
            </p>
          </div>
          {[
            "Sadece bir kelime veya kısa cümle söyle",
            "Sayı veya pozisyon ipucu verme",
            "Kartın tam kelimelerini kullanma",
          ].map((r) => (
            <div key={r} className="flex items-start gap-2 mb-2">
              <span
                style={{ color: AppColors.orange }}
                className="text-xs mt-0.5"
              >
                ✓
              </span>
              <p className="text-neutral-400 text-xs leading-relaxed">{r}</p>
            </div>
          ))}
        </div>
      </div>

      <div className="px-6 pb-8 pt-2">
        <Button onClick={submitClue} disabled={!clue.trim()} icon="→">
          İpucunu Gönder
        </Button>
      </div>
    </motion.div>
  );
};

// ═══════════════════════════════════════════════════════════════════════════════
// GROUP GUESS SCREEN
// ═══════════════════════════════════════════════════════════════════════════════
export const GroupGuessScreen: React.FC = () => {
  const {
    guessPosition,
    updateGuess,
    lockGuess,
    submitGuess,
    isGuessLocked,
    currentCard,
    clue,
    currentCategoryName,
    currentCategoryEmoji,
  } = useGameStore();
  const psychic = useGameStore((s) => s.currentPsychic());
  const leaderboard = useGameStore((s) => s.leaderboard());
  const [rulesOpen, setRulesOpen] = useState(false);

  if (!currentCard || !psychic) return null;

  return (
    <motion.div {...fadeUp} className="flex flex-col h-full">
      <AppBar
        title="Tahmin Ekranı"
        showBack={false}
        trailing={
          <div className="flex items-center gap-2">
            <CategoryBadge
              name={currentCategoryName()}
              emoji={currentCategoryEmoji()}
            />
            <button
              onClick={() => setRulesOpen(true)}
              className="w-9 h-9 rounded-full flex items-center justify-center"
              style={{ backgroundColor: AppColors.surfaceLight }}
            >
              <span className="text-neutral-400 text-sm">?</span>
            </button>
          </div>
        }
      />

      <div className="flex-1 flex flex-col px-6 pb-6 gap-5 overflow-y-auto">
        {/* Card poles */}
        <div className="pt-3">
          <CardPolesDisplay
            leftLabel={currentCard.leftLabel}
            rightLabel={currentCard.rightLabel}
          />
        </div>

        {/* Clue */}
        <ClueDisplay clue={clue} psychic={psychic} />

        {/* Slider */}
        <WavelengthSlider
          leftLabel={currentCard.leftLabel}
          rightLabel={currentCard.rightLabel}
          value={guessPosition}
          interactive={!isGuessLocked}
          onChange={isGuessLocked ? undefined : updateGuess}
        />

        {/* Lock status */}
        {!isGuessLocked ? (
          <p className="text-center text-neutral-500 text-xs">
            İbreyi sürükleyerek konumlandır
          </p>
        ) : (
          <div className="flex justify-center">
            <span
              className="inline-flex items-center gap-2 px-4 py-2 rounded-full text-xs font-semibold border"
              style={{
                backgroundColor: `${AppColors.success}18`,
                borderColor: `${AppColors.success}55`,
                color: AppColors.success,
              }}
            >
              🔒 Tahmin kilitlendi
            </span>
          </div>
        )}

        {/* Mini leaderboard */}
        <div
          className="flex items-center gap-2 px-4 py-3 rounded-2xl"
          style={{ backgroundColor: AppColors.surfaceLight }}
        >
          <span style={{ color: AppColors.orange }} className="text-sm">
            📊
          </span>
          <div className="flex gap-3 flex-1 overflow-x-auto">
            {leaderboard.slice(0, 5).map((p) => {
              const isPsychic = p.id === psychic.id;
              const color = getAvatarColor(p);
              return (
                <div
                  key={p.id}
                  className="flex items-center gap-1 flex-shrink-0"
                >
                  <div
                    className="w-6 h-6 rounded-full flex items-center justify-center font-bold text-white text-[10px]"
                    style={{
                      backgroundColor: color,
                      border: isPsychic
                        ? `2px solid ${AppColors.orange}`
                        : "none",
                    }}
                  >
                    {p.name ? p.name[0].toUpperCase() : "?"}
                  </div>
                  <span className="text-neutral-400 text-xs">{p.score}</span>
                </div>
              );
            })}
          </div>
        </div>

        <div className="flex-1" />

        {/* Buttons */}
        {!isGuessLocked ? (
          <Button onClick={lockGuess} icon="🔒">
            Tahmini Kilitle
          </Button>
        ) : (
          <Button onClick={submitGuess} icon="→">
            Tahmin Yap
          </Button>
        )}

        <p
          className="text-center text-[10px] tracking-widest font-semibold"
          style={{ color: `${AppColors.grey}88` }}
        >
          OFFLINE PARTY MODE
        </p>
      </div>

      {/* Rules sheet */}
      <BottomSheet
        isOpen={rulesOpen}
        onClose={() => setRulesOpen(false)}
        title="Tahmin Kuralları"
      >
        <div className="pt-2">
          {[
            {
              icon: "👥",
              text: "Psişik hariç herkes ibreyi konumlandırabilir",
            },
            { icon: "💬", text: "Grup tartışarak ortak bir karar almalı" },
            {
              icon: "🎯",
              text: "İbrenin hedef bölgeye yakınlığı puanı belirler",
            },
            {
              icon: "🗳",
              text: "Tahmini kilitlemeden önce herkes hemfikir olmalı",
            },
          ].map((r) => (
            <div key={r.text} className="flex items-start gap-3 mb-4">
              <span className="text-base">{r.icon}</span>
              <p className="text-neutral-300 text-sm leading-relaxed">
                {r.text}
              </p>
            </div>
          ))}
        </div>
      </BottomSheet>
    </motion.div>
  );
};

// ═══════════════════════════════════════════════════════════════════════════════
// ROUND RESULT SCREEN
// ═══════════════════════════════════════════════════════════════════════════════
export const RoundResultScreen: React.FC = () => {
  const { currentRound, totalRounds, nextRound } = useGameStore();
  const result = useGameStore((s) => s.lastRoundResult());
  const leaderboard = useGameStore((s) => s.leaderboard());
  const nextPsychic = useGameStore((s) => s.nextPsychic());
  const isLast = currentRound >= totalRounds;

  if (!result) return null;

  const points = result.pointsEarned;
  const resultColor = getResultColor(points);
  const distance = Math.abs(result.targetPosition - result.guessPosition);

  return (
    <motion.div {...fadeUp} className="flex flex-col h-full">
      <AppBar
        title="Sonuç"
        showBack={false}
        trailing={
          <span
            className="px-3 py-1 rounded-full text-xs font-semibold"
            style={{
              backgroundColor: AppColors.surfaceLight,
              color: AppColors.greyLight,
            }}
          >
            Tur {currentRound} / {totalRounds}
          </span>
        }
      />

      <div className="flex-1 overflow-y-auto px-6 pb-4">
        {/* Progress */}
        <div className="pt-4 pb-6">
          <RoundProgressBar current={currentRound} total={totalRounds} />
        </div>

        {/* Result headline */}
        <div className="text-center mb-6">
          <h2
            className="font-extrabold text-3xl mb-2"
            style={{ color: resultColor }}
          >
            {getResultLabel(points)}
          </h2>
          <p className="text-neutral-400 text-sm">
            {getResultSubtitle(points)}
          </p>
        </div>

        {/* Score badge */}
        <div className="flex justify-center mb-7">
          <motion.div
            initial={{ scale: 0.3, opacity: 0 }}
            animate={{ scale: 1, opacity: 1 }}
            transition={{
              type: "spring",
              stiffness: 200,
              damping: 12,
              delay: 0.2,
            }}
            className="w-36 h-36 rounded-full flex flex-col items-center justify-center border-4"
            style={{
              borderColor: resultColor,
              backgroundColor: `${resultColor}18`,
              boxShadow: `0 0 30px ${resultColor}44`,
            }}
          >
            <span
              className="font-black text-2xl"
              style={{ color: resultColor }}
            >
              +{points * 10}
            </span>
            <span
              className="text-xs font-semibold"
              style={{ color: `${resultColor}cc` }}
            >
              Puan
            </span>
          </motion.div>
        </div>

        {/* Revealed slider */}
        <div
          className="rounded-2xl p-4 border mb-5"
          style={{
            backgroundColor: AppColors.surfaceLight,
            borderColor: AppColors.greyDark,
          }}
        >
          <p className="text-neutral-400 text-xs font-semibold mb-4">
            Hedef Ne Kadardı?
          </p>
          <WavelengthSlider
            leftLabel={result.card.leftLabel}
            rightLabel={result.card.rightLabel}
            value={result.guessPosition}
            targetValue={result.targetPosition}
            interactive={false}
          />
          <div className="flex justify-around mt-4">
            {[
              { color: AppColors.orange, label: "Hedef", icon: "▼" },
              { color: AppColors.white, label: "Tahmin", icon: "●" },
              {
                color: AppColors.greyLight,
                label: `Mesafe: ${Math.round(distance * 100)}%`,
                icon: "↔",
              },
            ].map((l) => (
              <div key={l.label} className="flex items-center gap-1">
                <span className="text-xs" style={{ color: l.color }}>
                  {l.icon}
                </span>
                <span
                  className="text-xs font-semibold"
                  style={{ color: l.color }}
                >
                  {l.label}
                </span>
              </div>
            ))}
          </div>
        </div>

        {/* Clue recap */}
        <div
          className="flex items-start gap-3 rounded-2xl p-4 border mb-5"
          style={{
            backgroundColor: AppColors.surface,
            borderColor: AppColors.greyDark,
          }}
        >
          <div
            className="w-9 h-9 rounded-full flex items-center justify-center font-bold text-white text-sm flex-shrink-0"
            style={{ backgroundColor: getAvatarColor(result.psychic) }}
          >
            {result.psychic.name ? result.psychic.name[0].toUpperCase() : "?"}
          </div>
          <div>
            <p className="text-neutral-500 text-xs mb-1">
              {result.psychic.name}'in İpucu
            </p>
            <p className="text-white font-bold text-base italic">
              "{result.clue}"
            </p>
          </div>
        </div>

        {/* Leaderboard */}
        <div className="mb-5">
          <SectionTitle>Sıralama</SectionTitle>
          {leaderboard.map((p, i) => (
            <LeaderboardRow
              key={p.id}
              player={p}
              rank={i + 1}
              highlight={p.id === result.psychic.id}
            />
          ))}
        </div>

        {/* Next psychic preview */}
        {!isLast && nextPsychic && (
          <div
            className="flex items-center gap-4 rounded-2xl p-4 border mb-6"
            style={{
              backgroundColor: `${AppColors.orange}10`,
              borderColor: `${AppColors.orange}44`,
            }}
          >
            <div
              className="w-11 h-11 rounded-full flex items-center justify-center font-bold text-white text-lg flex-shrink-0 border-2"
              style={{
                backgroundColor: getAvatarColor(nextPsychic),
                borderColor: AppColors.orange,
              }}
            >
              {nextPsychic.name ? nextPsychic.name[0].toUpperCase() : "?"}
            </div>
            <div className="flex-1">
              <p className="text-neutral-400 text-xs">Sıradaki Lider</p>
              <p className="text-white font-bold">{nextPsychic.name}</p>
            </div>
            <span style={{ color: AppColors.orange }} className="text-sm">
              →
            </span>
          </div>
        )}

        <Button onClick={nextRound} icon={isLast ? "🏆" : "→"}>
          {isLast ? "Sonuçları Gör" : "Sonraki Tur"}
        </Button>
        <div className="h-6" />
      </div>
    </motion.div>
  );
};

// ═══════════════════════════════════════════════════════════════════════════════
// GAME OVER SCREEN
// ═══════════════════════════════════════════════════════════════════════════════
export const GameOverScreen: React.FC = () => {
  const { totalRounds, roundHistory, goHome, restartGame } = useGameStore();
  const winner = useGameStore((s) => s.winner());
  const leaderboard = useGameStore((s) => s.leaderboard());

  if (!winner) return null;

  const perfectHits = roundHistory.filter((r) => r.pointsEarned === 4).length;
  const totalPoints = roundHistory.reduce(
    (sum, r) => sum + r.pointsEarned * 10,
    0,
  );
  const avgPoints =
    roundHistory.length > 0 ? Math.round(totalPoints / roundHistory.length) : 0;
  const winnerColor = getAvatarColor(winner);

  return (
    <motion.div {...fadeUp} className="flex flex-col h-full">
      {/* Custom header */}
      <div className="flex items-center justify-between px-5 py-4">
        <button
          onClick={goHome}
          className="w-10 h-10 rounded-full flex items-center justify-center"
          style={{ backgroundColor: AppColors.surfaceLight }}
        >
          <span className="text-white text-base">✕</span>
        </button>
        <p
          className="font-extrabold text-sm tracking-widest"
          style={{ color: AppColors.white }}
        >
          OYUN BİTTİ
        </p>
        <div className="w-10" />
      </div>

      <div className="flex-1 overflow-y-auto px-6 pb-4">
        {/* Winner section */}
        <div className="flex flex-col items-center gap-4 py-6">
          <div className="relative">
            <div
              className="w-24 h-24 rounded-full flex items-center justify-center font-extrabold text-white"
              style={{
                backgroundColor: winnerColor,
                fontSize: 42,
                boxShadow: `0 0 40px ${winnerColor}66`,
              }}
            >
              {winner.name ? winner.name[0].toUpperCase() : "?"}
            </div>
            <div
              className="absolute -top-2 -right-2 w-9 h-9 rounded-full flex items-center justify-center border-2"
              style={{
                backgroundColor: AppColors.orange,
                borderColor: AppColors.background,
              }}
            >
              <span className="text-base">🏆</span>
            </div>
          </div>

          <p
            className="text-xs font-extrabold tracking-widest"
            style={{ color: AppColors.orange }}
          >
            ŞAMPIYON
          </p>

          <h1 className="text-white font-extrabold text-2xl text-center">
            Kazanan: {winner.name}!
          </h1>

          <span
            className="px-5 py-2 rounded-full font-extrabold text-xl"
            style={{
              backgroundColor: `${AppColors.orange}22`,
              border: `1px solid ${AppColors.orange}66`,
              color: AppColors.orange,
            }}
          >
            {winner.score} Puan
          </span>

          <p className="text-neutral-400 text-sm text-center">
            Harika bir performans sergiledi!
          </p>
        </div>

        {/* Final scores */}
        <div className="mb-6">
          <SectionTitle>FİNAL SKORLARI</SectionTitle>
          {leaderboard.map((p, i) => (
            <LeaderboardRow
              key={p.id}
              player={p}
              rank={i + 1}
              highlight={i === 0}
            />
          ))}
        </div>

        {/* Stats */}
        <div
          className="rounded-2xl p-5 border mb-8"
          style={{
            backgroundColor: AppColors.surfaceLight,
            borderColor: AppColors.greyDark,
          }}
        >
          <SectionTitle>OYUN İSTATİSTİKLERİ</SectionTitle>
          <div className="grid grid-cols-3 gap-4">
            {[
              { emoji: "🎯", value: String(perfectHits), label: "Tam İsabet" },
              { emoji: "🏁", value: String(totalRounds), label: "Toplam Tur" },
              { emoji: "⭐", value: String(avgPoints), label: "Ort. Puan" },
            ].map((s) => (
              <div key={s.label} className="flex flex-col items-center gap-1">
                <span className="text-2xl">{s.emoji}</span>
                <span className="text-white font-extrabold text-xl">
                  {s.value}
                </span>
                <span className="text-neutral-500 text-[10px] text-center">
                  {s.label}
                </span>
              </div>
            ))}
          </div>
        </div>

        {/* Buttons */}
        <div className="flex flex-col gap-3 pb-6">
          <Button onClick={restartGame} icon="🔄">
            Tekrar Oyna
          </Button>
          <Button variant="secondary" onClick={goHome} icon="🏠">
            Ana Menü
          </Button>
        </div>
      </div>
    </motion.div>
  );
};
