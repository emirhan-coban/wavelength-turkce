import React, { useState, useEffect } from 'react';
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import HomeScreen from './screens/HomeScreen';
import PlayerSetupScreen from './screens/PlayerSetupScreen';
import CategorySelectionScreen from './screens/CategorySelectionScreen';
import SecretTargetScreen from './screens/SecretTargetScreen';
import GuessScreen from './screens/GuessScreen';
import ResultScreen from './screens/ResultScreen';
import TurnChangeScreen from './screens/TurnChangeScreen';
import GameOverScreen from './screens/GameOverScreen';
import LoginScreen from './screens/LoginScreen';
import OnlineMenuScreen from './screens/OnlineMenuScreen';
import LobbyScreen from './screens/LobbyScreen';
import OnlineGameScreen from './screens/OnlineGameScreen';
import { GameProvider } from './context/GameContext';
import { AuthProvider } from './context/AuthContext';
import './App.css';

const isMobileDevice = () => {
  const userAgent = navigator.userAgent || navigator.vendor || window.opera;
  const mobileRegex = /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i;
  if (mobileRegex.test(userAgent)) return true;

  if ('ontouchstart' in window && navigator.maxTouchPoints > 0) {
    if (window.innerWidth <= 768) return true;
  }

  return window.innerWidth <= 768;
};

const DesktopWarning = () => (
  <div className="desktop-warning">
    <img
      src="/assets/images/splash_logo_600x600.png"
      alt="Zihindar Logo"
      className="desktop-warning-logo"
    />

    <svg
      className="desktop-warning-icon"
      viewBox="0 0 24 24"
      fill="none"
      stroke="currentColor"
      strokeWidth="2"
      strokeLinecap="round"
      strokeLinejoin="round"
    >
      <rect x="5" y="2" width="14" height="20" rx="2" ry="2"></rect>
      <line x1="12" y1="18" x2="12.01" y2="18"></line>
    </svg>

    <h1>
      <span>Zihindar</span> Mobil Deneyim
    </h1>

    <p>
      Bu uygulama mobil cihazlar için tasarlanmıştır.
      En iyi deneyim için telefonunuzdan açın.
    </p>

    <div className="desktop-warning-badge">
      <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
        <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path>
      </svg>
      Mobilde Açın
    </div>

    <p className="desktop-warning-qr-hint">
      Telefonunuzun tarayıcısında bu adresi ziyaret edin
    </p>
  </div>
);

function App() {
  const [isMobile, setIsMobile] = useState(true);

  useEffect(() => {
    const checkDevice = () => {
      setIsMobile(isMobileDevice());
    };

    checkDevice();
    window.addEventListener('resize', checkDevice);
    return () => window.removeEventListener('resize', checkDevice);
  }, []);

  if (!isMobile) {
    return <DesktopWarning />;
  }

  return (
    <AuthProvider>
      <GameProvider>
        <Router>
          <Routes>
            {/* Yerel Oyun */}
            <Route path="/" element={<HomeScreen />} />
            <Route path="/setup" element={<PlayerSetupScreen />} />
            <Route path="/categories" element={<CategorySelectionScreen />} />
            <Route path="/secret-target" element={<SecretTargetScreen />} />
            <Route path="/guess" element={<GuessScreen />} />
            <Route path="/result" element={<ResultScreen />} />
            <Route path="/turn-change" element={<TurnChangeScreen />} />
            <Route path="/game-over" element={<GameOverScreen />} />

            {/* Online Oyun */}
            <Route path="/login" element={<LoginScreen />} />
            <Route path="/online" element={<OnlineMenuScreen />} />
            <Route path="/room/:roomCode" element={<LobbyScreen />} />
            <Route path="/room/:roomCode/game" element={<OnlineGameScreen />} />
          </Routes>
        </Router>
      </GameProvider>
    </AuthProvider>
  );
}

export default App;
