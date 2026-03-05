import React from 'react';
import { useNavigate } from 'react-router-dom';
import { useGame } from '../context/GameContext';
import { Smartphone, ArrowRight } from 'lucide-react';
import './TurnChangeScreen.css';

const TurnChangeScreen = () => {
    const navigate = useNavigate();
    const { currentLeader } = useGame();

    if (!currentLeader) return null;

    return (
        <div className="turn-screen safe-area">
            <main className="turn-content">
                <div className="device-icon-container">
                    <Smartphone size={80} className="primary-orange" />
                    <div className="pass-arrow animation-swing">
                        <ArrowRight size={32} />
                    </div>
                </div>

                <h2 className="turn-title">Cihazı Teslim Et</h2>

                <div className="next-player-card">
                    <p>Sıradaki Oyuncu:</p>
                    <h3>{currentLeader.name}</h3>
                </div>

                <p className="turn-instruction">
                    Diğer oyuncular hedefin nerede olduğunu görmemeli.
                </p>
            </main>

            <footer className="turn-footer">
                <button className="btn btn-primary" onClick={() => navigate('/secret-target')}>
                    Hazırım
                    <ArrowRight size={20} />
                </button>
            </footer>
        </div>
    );
};

export default TurnChangeScreen;
