import React, { useState, useEffect } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import { useAuth } from '../context/AuthContext';
import { subscribeToRoom, leaveRoom, startGame } from '../services/roomService';
import { GameCategory } from '../data/gameData';
import { ArrowLeft, LogOut, Copy, Check } from 'lucide-react';
import './LobbyScreen.css';

const avatarColors = ['avatar-orange', 'avatar-cyan', 'avatar-purple', 'avatar-blue'];

const LobbyScreen = () => {
    const navigate = useNavigate();
    const { roomCode } = useParams();
    const { currentUser } = useAuth();
    const [roomData, setRoomData] = useState(null);
    const [copied, setCopied] = useState(false);
    const [showCategories, setShowCategories] = useState(false);
    const [loading, setLoading] = useState(false);

    useEffect(() => {
        if (!roomCode) return;

        const unsubscribe = subscribeToRoom(roomCode, (data) => {
            if (!data) {
                navigate('/online');
                return;
            }
            setRoomData(data);

            // Eğer oyun başladıysa game ekranına yönlendir
            if (data.status === 'playing') {
                navigate(`/room/${roomCode}/game`);
            }
        });

        return () => unsubscribe();
    }, [roomCode, navigate]);

    const handleCopyCode = async () => {
        try {
            await navigator.clipboard.writeText(roomCode);
            setCopied(true);
            setTimeout(() => setCopied(false), 2000);
        } catch {
            // fallback
        }
    };

    const handleLeave = async () => {
        await leaveRoom({ roomCode, uid: currentUser.uid });
        navigate('/online');
    };

    const handleStartGame = async (categoryId) => {
        setLoading(true);
        try {
            await startGame({ roomCode, categoryId });
        } catch {
            setLoading(false);
        }
    };

    if (!roomData) {
        return (
            <div className="lobby-screen safe-area">
                <main className="lobby-center">
                    <p className="lobby-waiting-text">Yükleniyor...</p>
                </main>
            </div>
        );
    }

    const isHost = roomData.hostUid === currentUser?.uid;
    const players = roomData.players || [];

    return (
        <div className="lobby-screen safe-area">
            <header className="app-bar">
                <button className="login-back-btn" onClick={handleLeave}>
                    <ArrowLeft size={20} />
                </button>
                <h1 className="app-title">Lobi</h1>
                <div style={{ width: '36px' }}></div>
            </header>

            <main className="lobby-center">
                <div className="lobby-code-container" onClick={handleCopyCode}>
                    <p className="lobby-code-label">Oda Kodu</p>
                    <h2 className="lobby-code">{roomCode}</h2>
                    <p className="lobby-code-hint">
                        {copied ? (
                            <><Check size={12} /> Kopyalandı!</>
                        ) : (
                            <><Copy size={12} /> Kopyalamak için dokun</>
                        )}
                    </p>
                </div>

                <h3 className="lobby-players-title">
                    Oyuncular ({players.length}/8)
                </h3>

                <div className="lobby-players-list">
                    {players.map((player, idx) => (
                        <div key={player.uid} className="lobby-player-card">
                            <div className={`lobby-player-avatar ${avatarColors[idx % avatarColors.length]}`}>
                                {player.name.charAt(0).toUpperCase()}
                            </div>
                            <span className="lobby-player-name">{player.name}</span>
                            {player.uid === roomData.hostUid && (
                                <span className="lobby-host-badge">HOST</span>
                            )}
                        </div>
                    ))}
                </div>

                {players.length < 2 && (
                    <p className="lobby-waiting-text">
                        En az 2 oyuncu gerekli<span className="dot-anim">...</span>
                    </p>
                )}

                {!showCategories && isHost && players.length >= 2 && (
                    <button
                        className="btn btn-primary"
                        style={{ width: '100%' }}
                        onClick={() => setShowCategories(true)}
                    >
                        🎯 Kategori Seç ve Başla
                    </button>
                )}

                {showCategories && isHost && (
                    <div className="lobby-players-list">
                        {GameCategory.all.map(cat => (
                            <button
                                key={cat.id}
                                className="online-menu-card"
                                onClick={() => handleStartGame(cat.id)}
                                disabled={loading}
                            >
                                <h3 className="online-menu-card-title">{cat.name}</h3>
                            </button>
                        ))}
                    </div>
                )}

                {!isHost && players.length >= 2 && (
                    <p className="lobby-waiting-text">
                        Host'un oyunu başlatması bekleniyor<span className="dot-anim">...</span>
                    </p>
                )}
            </main>

            <footer className="lobby-bottom">
                <button className="lobby-leave-btn" onClick={handleLeave}>
                    <LogOut size={14} />
                    Odadan Ayrıl
                </button>
            </footer>
        </div>
    );
};

export default LobbyScreen;
