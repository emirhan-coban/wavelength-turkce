import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { useGame } from '../context/GameContext';
import { X, Info, CheckCircle } from 'lucide-react';
import './GuessScreen.css';

const GuessScreen = () => {
    const navigate = useNavigate();
    const { currentPair, categoryId, submitGuess, currentLeader } = useGame();
    const [guessValue, setGuessValue] = useState(0.5);

    if (!currentPair) return null;

    const handleSubmit = () => {
        submitGuess(guessValue);
        navigate('/result');
    };

    const handleExit = () => {
        if (window.confirm('Oyundan çıkmak istediğine emin misin?')) {
            navigate('/');
        }
    };

    // Category display name mapping
    const categoryNames = {
        'eglence': 'Eğlence',
        'maceraci': 'Maceracı',
        'zihin': 'Zihin Oyunları',
        'klasik': 'Klasik',
        'rekabetci': 'Rekabetçi',
        'sosyal': 'Sosyal'
    };

    return (
        <div className="guess-screen safe-area">
            <header className="app-bar">
                <button className="icon-btn" onClick={handleExit}>
                    <X size={22} color="#FFFFFF" />
                </button>
                <h1 className="app-title">Tahmin Ekranı</h1>
                <button className="icon-btn">
                    <Info size={22} color="#FFFFFF" />
                </button>
            </header>

            <main className="guess-content">
                <div className="category-badge">
                    KATEGORİ: {categoryNames[categoryId] || categoryId}
                </div>

                <div className="guess-card">
                    <div className="card-header">
                        <h3>{currentPair.leftConcept} vs {currentPair.rightConcept}</h3>
                        <p>İbreyi uygun noktaya kaydırın</p>
                    </div>

                    <div className="main-concepts">
                        <span className="concept-label left">{currentPair.leftConcept}</span>
                        <span className="concept-label right">{currentPair.rightConcept}</span>
                    </div>

                    <div className="spectrum-container">
                        <div className="spectrum-track">
                            <div
                                className="spectrum-progress"
                                style={{ width: `${guessValue * 100}%` }}
                            ></div>
                            <input
                                type="range"
                                min="0"
                                max="1"
                                step="0.01"
                                value={guessValue}
                                onChange={(e) => setGuessValue(parseFloat(e.target.value))}
                                className="spectrum-input"
                            />
                            <div
                                className="spectrum-thumb"
                                style={{ left: `${guessValue * 100}%` }}
                            >
                                <div className="thumb-line"></div>
                            </div>
                        </div>
                    </div>
                </div>

                <p className="waiting-text">
                    {currentLeader?.name} ipucu versin, grup birlikte karar versin
                </p>
            </main>

            <footer className="guess-footer">
                <button className="btn btn-primary" onClick={handleSubmit}>
                    <CheckCircle size={20} />
                    Tahmin Yap
                </button>
                <p className="footer-tag">YEREL PARTİ MODU</p>
            </footer>
        </div>
    );
};

export default GuessScreen;
