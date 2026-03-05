import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { useGame } from '../context/GameContext';
import { Eye, Target, ArrowRight } from 'lucide-react';
import './SecretTargetScreen.css';

const SecretTargetScreen = () => {
    const navigate = useNavigate();
    const { currentLeader, targetPosition, currentPair, currentRound } = useGame();

    const [isVisible, setIsVisible] = useState(false);
    const [isReady, setIsReady] = useState(false);

    const handlePressStart = () => {
        setIsVisible(true);
    };

    const handlePressEnd = () => {
        setIsVisible(false);
        setIsReady(true);
    };

    if (!currentPair || !currentLeader) return null;

    return (
        <div className="secret-screen safe-area">
            <header className="secret-header">
                <span className="round-badge">Tur {currentRound}</span>
            </header>

            <main className="secret-content">
                <div className="leader-info">
                    <div className="leader-avatar">
                        <Target size={24} className="primary-orange" />
                    </div>
                    <h2>{currentLeader.name}</h2>
                    <p>Sıra Sende</p>
                </div>

                <div className="secret-box">
                    <div className="pair-display">
                        <span className="concept left">{currentPair.leftConcept}</span>
                        <span className="concept-divider">vs</span>
                        <span className="concept right">{currentPair.rightConcept}</span>
                    </div>

                    <p className="instruction">
                        Cihazı kimseye göstermeden gizli hedefin konumuna bak.
                    </p>

                    <div className="target-reveal-area">
                        <div className={`target-visual ${isVisible ? 'animation-pop' : ''}`}>
                            <div className="spectrum-line">
                                {isVisible && (
                                    <div
                                        className="target-marker pulse-glow"
                                        style={{ left: `${targetPosition * 100}%` }}
                                    ></div>
                                )}
                            </div>
                        </div>
                    </div>

                    <button
                        className="reveal-btn"
                        onPointerDown={handlePressStart}
                        onPointerUp={handlePressEnd}
                        onPointerCancel={handlePressEnd}
                        onPointerLeave={() => {
                            if (isVisible) {
                                handlePressEnd();
                            }
                        }}
                    >
                        <Eye size={24} className="cyan-text" />
                        <span>{isVisible ? 'Bırakınca Devam Edebilirsin' : 'Basılı Tutarak Gör'}</span>
                    </button>
                </div>
            </main>

            <footer className="secret-footer">
                <button
                    className="btn btn-primary fade-in"
                    onClick={() => navigate('/guess')}
                    disabled={!isReady}
                >
                    <span>Tahmine Geç</span>
                    <ArrowRight size={20} />
                </button>
            </footer>
        </div>
    );
};

export default SecretTargetScreen;
