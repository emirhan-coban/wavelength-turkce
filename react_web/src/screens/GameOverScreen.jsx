import React from 'react';
import { useNavigate } from 'react-router-dom';
import { useGame } from '../context/GameContext';
import { Trophy, RefreshCw, Home, Medal } from 'lucide-react';
import './GameOverScreen.css';

const GameOverScreen = () => {
    const navigate = useNavigate();
    const { players, resetGame } = useGame();

    const sortedPlayers = [...players].sort((a, b) => b.score - a.score);
    const winner = sortedPlayers[0];

    const handlePlayAgain = () => {
        resetGame();
        navigate('/categories', { state: { players } });
    };

    const handleHome = () => {
        navigate('/');
    };

    return (
        <div className="game-over-screen safe-area">
            <main className="game-over-content">
                <div className="winner-circle glow-effect">
                    <Trophy size={48} className="winner-icon" />
                    <div className="crown">👑</div>
                </div>

                <h1 className="game-over-title">Oyun Bitti!</h1>

                <div className="winner-announcement">
                    <p>Şampiyon:</p>
                    <h2>{winner?.name}</h2>
                    <div className="winner-score">{winner?.score} Puan</div>
                </div>

                <div className="leaderboard">
                    <div className="leaderboard-header">
                        <Medal size={18} />
                        <span>Sıralama</span>
                    </div>

                    <div className="leaderboard-list">
                        {sortedPlayers.map((player, index) => (
                            <div key={player.id || index} className={`leaderboard-item ${index === 0 ? 'first' : ''}`}>
                                <div className="rank">#{index + 1}</div>
                                <div className="player-name">{player.name}</div>
                                <div className="player-score">{player.score} Puan</div>
                            </div>
                        ))}
                    </div>
                </div>
            </main>

            <footer className="game-over-footer">
                <button className="btn btn-primary" onClick={handlePlayAgain}>
                    <RefreshCw size={20} />
                    Yeniden Oyna
                </button>
                <button className="btn btn-secondary" onClick={handleHome}>
                    <Home size={20} className="cyan-text" />
                    <span className="cyan-text">Ana Sayfa</span>
                </button>
            </footer>
        </div>
    );
};

export default GameOverScreen;
