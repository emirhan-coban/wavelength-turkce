import { AnimatePresence } from "framer-motion";
import { useGameStore } from "./store/gameStore";
import {
  HomeScreen,
  PlayerSetupScreen,
  CategorySelectScreen,
  PhonePassScreen,
  SecretTargetScreen,
  ClueGivingScreen,
  GroupGuessScreen,
  RoundResultScreen,
  GameOverScreen,
} from "./screens/screens";
import type { GamePhase } from "./types";

const AppColors = {
  orange: "#FF6B00",
  surface: "#242424",
  surfaceLight: "#2E2E2E",
};

function App() {
  const phase = useGameStore((s) => s.phase);

  const renderScreen = (p: GamePhase) => {
    switch (p) {
      case "home":
        return <HomeScreen key="home" />;
      case "playerSetup":
        return <PlayerSetupScreen key="playerSetup" />;
      case "categorySelect":
        return <CategorySelectScreen key="categorySelect" />;
      case "phonePass":
        return <PhonePassScreen key="phonePass" />;
      case "secretTarget":
        return <SecretTargetScreen key="secretTarget" />;
      case "clueGiving":
        return <ClueGivingScreen key="clueGiving" />;
      case "groupGuess":
        return <GroupGuessScreen key="groupGuess" />;
      case "roundResult":
        return <RoundResultScreen key="roundResult" />;
      case "gameOver":
        return <GameOverScreen key="gameOver" />;
      default:
        return <HomeScreen key="home" />;
    }
  };

  return (
    <div
      className="min-h-screen w-full flex items-center justify-center relative overflow-hidden"
      style={{
        background:
          "linear-gradient(145deg, #0c0c0c 0%, #111111 45%, #131008 100%)",
      }}
    >
      {/* ── Decorative background glows ── */}
      <div
        aria-hidden="true"
        className="pointer-events-none absolute"
        style={{
          inset: 0,
          background:
            "radial-gradient(ellipse 70% 60% at 50% 45%, rgba(255,107,0,0.055) 0%, transparent 70%)",
        }}
      />
      <div
        aria-hidden="true"
        className="pointer-events-none absolute"
        style={{
          width: 700,
          height: 700,
          top: "-18%",
          left: "-12%",
          borderRadius: "50%",
          background:
            "radial-gradient(circle, rgba(255,107,0,0.06) 0%, transparent 65%)",
        }}
      />
      <div
        aria-hidden="true"
        className="pointer-events-none absolute"
        style={{
          width: 550,
          height: 550,
          bottom: "-12%",
          right: "-8%",
          borderRadius: "50%",
          background:
            "radial-gradient(circle, rgba(255,107,0,0.04) 0%, transparent 65%)",
        }}
      />

      {/* ── Subtle grid overlay (desktop only) ── */}
      <div
        aria-hidden="true"
        className="pointer-events-none absolute inset-0 hidden md:block"
        style={{
          backgroundImage: `linear-gradient(rgba(255,255,255,0.012) 1px, transparent 1px),
                            linear-gradient(90deg, rgba(255,255,255,0.012) 1px, transparent 1px)`,
          backgroundSize: "60px 60px",
        }}
      />

      {/* ── Main layout row ── */}
      <div className="relative z-10 flex items-center justify-center w-full min-h-screen lg:gap-10 xl:gap-16 lg:px-8 xl:px-12">
        {/* ─────────────────────────────────────────────────────
            LEFT PANEL — visible on lg+ screens
        ───────────────────────────────────────────────────── */}
        <aside className="hidden lg:flex flex-col gap-7 flex-1 max-w-[220px] xl:max-w-[260px]">
          {/* Brand */}
          <div>
            <div className="flex items-center gap-3 mb-4">
              <div
                className="flex items-center justify-center font-black text-white text-2xl flex-shrink-0"
                style={{
                  width: 52,
                  height: 52,
                  borderRadius: 16,
                  backgroundColor: AppColors.orange,
                  boxShadow: `0 8px 24px ${AppColors.orange}55`,
                }}
              >
                Z
              </div>
              <div>
                <p className="text-white font-extrabold text-xl leading-tight">
                  Zihindar
                </p>
                <p className="text-neutral-500 text-xs font-medium">
                  Türkçe Wavelength Oyunu
                </p>
              </div>
            </div>
            <p className="text-neutral-400 text-sm leading-relaxed">
              Arkadaşlarınla oynayabileceğin eğlenceli parti oyunu. Sinyali
              yakala, ipucunu ver, grubu yönlendir!
            </p>
          </div>

          {/* Stats grid */}
          <div className="grid grid-cols-2 gap-2.5">
            {[
              { value: "100+", label: "Oyun Kartı" },
              { value: "6", label: "Kategori" },
              { value: "2–8", label: "Oyuncu" },
              { value: "~15 dk", label: "Süre" },
            ].map((s) => (
              <div
                key={s.label}
                className="rounded-2xl p-3.5 flex flex-col gap-1.5"
                style={{ backgroundColor: AppColors.surfaceLight }}
              >
                <span className="text-white font-bold text-sm mt-2">{s.value}</span>
                <span className="text-neutral-500 text-[11px]">{s.label}</span>
              </div>
            ))}
          </div>

          <div
            className="flex items-center gap-3 rounded-2xl px-4 py-3"
            style={{ backgroundColor: AppColors.surface }}
          >
            <div className="w-2.5 h-2.5 rounded-full" style={{ backgroundColor: AppColors.orange, boxShadow: `0 0 8px ${AppColors.orange}` }} />
            <div>
              <p className="text-white text-xs font-semibold">Offline Mod</p>
              <p className="text-neutral-500 text-[11px]">
                İnternet bağlantısı gerekmez
              </p>
            </div>
          </div>

          {/* Divider */}
          <div style={{ height: 1, backgroundColor: "#2a2a2a" }} />

          {/* Scoring legend */}
          <div>
            <p
              className="text-[10px] font-bold tracking-widest mb-3"
              style={{ color: AppColors.orange }}
            >
              PUAN SİSTEMİ
            </p>
            <div className="flex flex-col gap-2">
              {[
                { label: "Tam İsabet", pts: "+40", color: AppColors.orange },
                { label: "Çok Yakın", pts: "+30", color: "#4CAF50" },
                { label: "Yakın", pts: "+20", color: "#4A90D9" },
                { label: "Fena Değil", pts: "+10", color: "#AAAAAA" },
                { label: "Kaçırdınız", pts: "+0", color: "#666" },
              ].map((row) => (
                <div
                  key={row.label}
                  className="flex items-center justify-between"
                >
                  <div className="flex items-center gap-2">
                    <div
                      className="w-2 h-2 rounded-full flex-shrink-0"
                      style={{ backgroundColor: row.color }}
                    />
                    <span className="text-neutral-400 text-xs">
                      {row.label}
                    </span>
                  </div>
                  <span
                    className="text-xs font-bold"
                    style={{ color: row.color }}
                  >
                    {row.pts}
                  </span>
                </div>
              ))}
            </div>
          </div>
        </aside>

        {/* ─────────────────────────────────────────────────────
            CENTER — Phone container
        ───────────────────────────────────────────────────── */}
        <div
          className="relative w-full overflow-hidden flex-shrink-0 sm:rounded-[44px]"
          style={{
            maxWidth: 430,
            height: "100dvh",
            maxHeight: 932,
            backgroundColor: "#1A1A1A",
            boxShadow:
              "0 0 0 1px rgba(255,255,255,0.07), 0 32px 120px rgba(0,0,0,0.95), 0 0 60px rgba(255,107,0,0.04)",
          }}
        >
          {/* Notch-like top accent on desktop */}
          <div
            className="absolute top-0 left-1/2 -translate-x-1/2 hidden sm:block z-50 pointer-events-none"
            style={{
              width: 120,
              height: 4,
              borderRadius: "0 0 4px 4px",
              backgroundColor: "rgba(255,255,255,0.08)",
            }}
          />
          <AnimatePresence mode="wait">{renderScreen(phase)}</AnimatePresence>
        </div>

        {/* ─────────────────────────────────────────────────────
            RIGHT PANEL — visible on xl+ screens
        ───────────────────────────────────────────────────── */}
        {/* Right panel — always rendered on lg+ to balance left panel and keep phone centred.
            Content is only revealed on xl+ screens. */}
        <aside className="hidden lg:flex flex-col gap-6 flex-1 max-w-[220px] xl:max-w-[260px]">
          <div className="hidden xl:flex flex-col gap-6">
            <div>
              <p
                className="text-[10px] font-bold tracking-widest mb-4"
                style={{ color: AppColors.orange }}
              >
                NASIL OYNANIR?
              </p>
              <div className="flex flex-col gap-4">
                {[
                  {
                    n: "1",
                    title: "Psişik Seçilir",
                    desc: "Her turda bir oyuncu psişik olur. Telefon o kişiye verilir.",
                    emoji: "🧙",
                  },
                  {
                    n: "2",
                    title: "Gizli Hedef",
                    desc: "Psişik spektrum üzerindeki gizli hedefi görür. Başka kimse göremez!",
                    emoji: "🎯",
                  },
                  {
                    n: "3",
                    title: "İpucu Ver",
                    desc: "Psişik, iki kutup arasındaki hedefi anlatan bir kelime söyler.",
                    emoji: "💬",
                  },
                  {
                    n: "4",
                    title: "Grup Tahmin Eder",
                    desc: "Gruptaki diğer oyuncular tartışarak ibreyi konumlandırır.",
                    emoji: "👥",
                  },
                  {
                    n: "5",
                    title: "Puan Hesaplanır",
                    desc: "İbre hedefe ne kadar yakınsa o kadar çok puan kazanılır!",
                    emoji: "⭐",
                  },
                ].map((step) => (
                  <div key={step.n} className="flex gap-3">
                    <div
                      className="w-7 h-7 rounded-full flex items-center justify-center font-extrabold text-white text-xs flex-shrink-0 mt-0.5"
                      style={{ backgroundColor: AppColors.orange }}
                    >
                      {step.n}
                    </div>
                    <div>
                      <p className="text-white font-semibold text-sm mb-0.5">
                        {step.title}{" "}
                        <span className="text-base">{step.emoji}</span>
                      </p>
                      <p className="text-neutral-500 text-xs leading-relaxed">
                        {step.desc}
                      </p>
                    </div>
                  </div>
                ))}
              </div>
            </div>

            {/* Divider */}
            <div style={{ height: 1, backgroundColor: "#2a2a2a" }} />

            {/* Pro tip */}
            <div
              className="rounded-2xl p-4"
              style={{
                backgroundColor: `${AppColors.orange}12`,
                border: `1px solid ${AppColors.orange}30`,
              }}
            >
              <p
                className="font-bold text-xs mb-1.5"
                style={{ color: AppColors.orange }}
              >
                💡 İpucu
              </p>
              <p className="text-neutral-400 text-xs leading-relaxed">
                Psişik olarak mümkün olan en yaratıcı ipucunu bulmaya çalış!
                Spektrumun tam ortasından kaçın — ortalama tahminler düşük puan
                getirir.
              </p>
            </div>

            {/* Built with */}
            <p className="text-neutral-700 text-[11px]">
              ⚡ React + TypeScript ile yapıldı
            </p>
          </div>
        </aside>
      </div>
    </div>
  );
}

export default App;
