import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { Users, Plus, X, ArrowRight, AlertCircle } from 'lucide-react';
import './PlayerSetupScreen.css';

const PlayerSetupScreen = () => {
    const navigate = useNavigate();

    const [players, setPlayers] = useState([
        { id: 1, name: 'Oyuncu 1' },
        { id: 2, name: 'Oyuncu 2' }
    ]);
    const [error, setError] = useState('');

    const addPlayer = () => {
        if (players.length >= 8) {
            setError('En fazla 8 oyuncu eklenebilir.');
            return;
        }
        const newId = players.length > 0 ? Math.max(...players.map(p => p.id)) + 1 : 1;
        setPlayers([...players, { id: newId, name: `Oyuncu ${players.length + 1}` }]);
        setError('');
    };

    const removePlayer = (id) => {
        if (players.length <= 2) {
            setError('En az 2 oyuncu olmalıdır.');
            return;
        }
        setPlayers(players.filter(p => p.id !== id));
        setError('');
    };

    const updatePlayerName = (id, newName) => {
        setPlayers(players.map(p => p.id === id ? { ...p, name: newName } : p));
    };

    const handleNext = () => {
        // Validate empty names
        const emptyNames = players.filter(p => p.name.trim() === '');
        if (emptyNames.length > 0) {
            setError('Lütfen tüm oyuncu isimlerini doldurun.');
            return;
        }

        // Save to context using initializeGame (categoryId will be set in the next screen)
        // Here we pass the initial player state, CategorySelection will overwrite context fully
        // Or we can just pass players via state
        navigate('/categories', { state: { players } });
    };

    return (
        <div className="setup-screen safe-area">
            {/* App Bar */}
            <header className="setup-app-bar">
                <button className="back-btn" onClick={() => navigate(-1)}>
                    <X size={24} color="#FFFFFF" />
                </button>
                <h1 className="app-title">Oyuncular</h1>
                <div style={{ width: '40px' }}></div>
            </header>

            {/* Main Content */}
            <main className="setup-content">
                <div className="setup-header">
                    <div className="icon-circle">
                        <Users size={28} className="primary-orange" />
                    </div>
                    <h2>Kimler Oynuyor?</h2>
                    <p>Oyuncu isimlerini belirleyin (2-8 Kişi)</p>
                </div>

                {error && (
                    <div className="error-box">
                        <AlertCircle size={16} color="#E53935" />
                        <span>{error}</span>
                    </div>
                )}

                <div className="players-list">
                    {players.map((player, index) => (
                        <div key={player.id} className="player-card fade-in">
                            <div className="player-avatar">
                                <Users size={16} />
                            </div>
                            <input
                                type="text"
                                value={player.name}
                                onChange={(e) => updatePlayerName(player.id, e.target.value)}
                                placeholder={`${index + 1}. Oyuncu`}
                                maxLength={15}
                                className="player-input"
                            />
                            {players.length > 2 && (
                                <button
                                    className="remove-btn"
                                    onClick={() => removePlayer(player.id)}
                                >
                                    <X size={18} />
                                </button>
                            )}
                        </div>
                    ))}
                </div>

                {players.length < 8 && (
                    <button className="add-player-btn" onClick={addPlayer}>
                        <Plus size={20} />
                        <span>Oyuncu Ekle</span>
                    </button>
                )}
            </main>

            {/* Footer */}
            <footer className="setup-footer">
                <button
                    className="btn btn-primary"
                    onClick={handleNext}
                    disabled={players.length < 2}
                >
                    <span>Devam Et</span>
                    <ArrowRight size={20} />
                </button>
            </footer>
        </div>
    );
};

export default PlayerSetupScreen;
