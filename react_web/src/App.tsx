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
      className="min-h-screen flex items-center justify-center"
      style={{ backgroundColor: "#111111" }}
    >
      {/* Phone-shaped container */}
      <div
        className="relative w-full overflow-hidden"
        style={{
          maxWidth: 430,
          height: "100dvh",
          maxHeight: 932,
          backgroundColor: "#1A1A1A",
          boxShadow: "0 0 80px rgba(0,0,0,0.8)",
        }}
      >
        <AnimatePresence mode="wait">{renderScreen(phase)}</AnimatePresence>
      </div>
    </div>
  );
}

export default App;
