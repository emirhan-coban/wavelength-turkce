import React, { useEffect, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { useGame } from '../context/GameContext';
import { ArrowLeft, LineChart, Check, ArrowRight } from 'lucide-react';
import './ResultScreen.css';

const ResultScreen = () => {
    const navigate = useNavigate();
    const {
        lastGuessPosition,
        targetPosition,
        lastScore,
        currentLeader,
        currentRound,
        totalRounds,
        startNewRound,
    } = useGame();

    const [animatedScore, setAnimatedScore] = useState(0);

    useEffect(() => {
        const end = lastScore || 0;
        if (end === 0) return;

        let startTime = null;
        const duration = 800;

        const animate = (currentTime) => {
            if (!startTime) startTime = currentTime;
            const progress = Math.min((currentTime - startTime) / duration, 1);
            setAnimatedScore(Math.floor(progress * end));
            if (progress < 1) {
                requestAnimationFrame(animate);
            }
        };
        requestAnimationFrame(animate);
    }, [lastScore]);

    const isLastRound = currentRound >= totalRounds;

    const handleNext = () => {
        if (isLastRound) {
            navigate('/game-over');
        } else {
            startNewRound();
            navigate('/turn-change');
        }
    };

    const getFeedback = () => {
        if (lastScore >= 30) return { text: 'Mükemmel! 🎯', color: 'var(--success)' };
        if (lastScore >= 10) return { text: 'İyi Tahmin! 👍', color: 'var(--primary-orange)' };
        return { text: 'Uzak Kaldı 😅', color: 'var(--error)' };
    };

    const feedback = getFeedback();

    return (
        <div className="result-screen safe-area">
            <header className="app-bar border-none">
                <button className="icon-btn" onClick={() => navigate(-1)}>
                    <ArrowLeft size={18} color="#FFFFFF" />
                </button>
                <h1 className="app-title">Sonuç</h1>
                <div style={{ width: '40px' }}></div>
            </header>

            <main className="result-content">
                <div className="feedback-card">
                    <LineChart size={34} style={{ color: 'rgba(250, 123, 27, 0.6)', marginBottom: '8px' }} />
                    <h2 style={{ color: feedback.color }}>{feedback.text}</h2>
                    <p>Hedefe ne kadar yaklaştığını kontrol et.</p>
                </div>

                <div className="comparison-card">
                    <div className="spectrum-display">
                        <div className="spectrum-track-result">
                            <div
                                className="result-marker target"
                                style={{ left: `${targetPosition * 100}%` }}
                            >
                                <div className="marker-label">HEDEF</div>
                                <Check size={10} color="var(--background)" strokeWidth={4} />
                            </div>

                            <div
                                className="result-marker guess"
                                style={{ left: `${(lastGuessPosition || 0) * 100}%` }}
                            >
                                <div className="marker-label">TAHMİN</div>
                            </div>
                        </div>
                    </div>

                    <div className="comparison-legend">
                        <span className="legend-item guess">TAHMİN</span>
                        <span className="legend-item target">HEDEF</span>
                    </div>
                </div>

                <div className="score-badge-container">
                    <div className="score-badge">
                        +{animatedScore} Puan
                    </div>
                    <p className="total-score-text">Toplam Puan: {currentLeader?.score}</p>
                </div>
            </main>

            <footer className="result-footer">
                <button className="btn btn-primary" onClick={handleNext}>
                    {isLastRound ? 'Sonuçları Gör' : 'Sonraki Tur'}
                    <ArrowRight size={18} />
                </button>
            </footer>
        </div>
    );
};

export default ResultScreen;
