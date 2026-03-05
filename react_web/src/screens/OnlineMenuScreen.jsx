import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { useAuth } from '../context/AuthContext';
import { createRoom, joinRoom } from '../services/roomService';
import { ArrowLeft, LogOut } from 'lucide-react';
import './OnlineMenuScreen.css';

const OnlineMenuScreen = () => {
    const navigate = useNavigate();
    const { currentUser, displayName, logout } = useAuth();
    const [roomCode, setRoomCode] = useState('');
    const [error, setError] = useState('');
    const [loading, setLoading] = useState(false);
    const [showJoin, setShowJoin] = useState(false);

    if (!currentUser) {
        navigate('/login');
        return null;
    }

    const handleCreateRoom = async () => {
        setLoading(true);
        setError('');
        try {
            const code = await createRoom({
                hostUid: currentUser.uid,
                hostName: displayName,
            });
            navigate(`/room/${code}`);
        } catch {
            setError('Oda oluşturulamadı. Tekrar deneyin.');
        } finally {
            setLoading(false);
        }
    };

    const handleJoinRoom = async () => {
        if (roomCode.trim().length < 6) {
            setError('Lütfen 6 haneli oda kodunu girin');
            return;
        }
        setLoading(true);
        setError('');
        try {
            const success = await joinRoom({
                roomCode: roomCode.trim().toUpperCase(),
                uid: currentUser.uid,
                name: displayName,
            });
            if (success) {
                navigate(`/room/${roomCode.trim().toUpperCase()}`);
            } else {
                setError('Oda bulunamadı veya dolu.');
            }
        } catch {
            setError('Odaya katılınamadı.');
        } finally {
            setLoading(false);
        }
    };

    const handleLogout = async () => {
        await logout();
        navigate('/');
    };

    return (
        <div className="online-menu safe-area">
            <header className="app-bar">
                <button className="login-back-btn" onClick={() => navigate('/')}>
                    <ArrowLeft size={20} />
                </button>
                <h1 className="app-title">Online Oyun</h1>
                <div style={{ width: '36px' }}></div>
            </header>

            <main className="online-menu-center">
                <div className="online-menu-user-badge">
                    👤 {displayName}
                </div>

                <h2 className="online-menu-title">Oda Seç</h2>
                <p className="online-menu-subtitle">
                    Yeni bir oda oluşturun veya arkadaşınızın odasına katılın
                </p>

                {error && <p className="online-menu-error">{error}</p>}

                <div className="online-menu-cards">
                    <button
                        className="online-menu-card"
                        onClick={handleCreateRoom}
                        disabled={loading}
                    >
                        <div className="online-menu-card-icon icon-create">🏠</div>
                        <h3 className="online-menu-card-title">Oda Oluştur</h3>
                        <p className="online-menu-card-desc">
                            Yeni bir oda oluşturup arkadaşlarınızla kodu paylaşın
                        </p>
                    </button>

                    <button
                        className="online-menu-card"
                        onClick={() => setShowJoin(!showJoin)}
                    >
                        <div className="online-menu-card-icon icon-join">🔗</div>
                        <h3 className="online-menu-card-title">Odaya Katıl</h3>
                        <p className="online-menu-card-desc">
                            Arkadaşınızın paylaştığı oda kodunu girin
                        </p>
                    </button>

                    {showJoin && (
                        <div className="join-room-input-row">
                            <input
                                type="text"
                                className="join-room-input"
                                placeholder="ODA KODU"
                                value={roomCode}
                                onChange={(e) => setRoomCode(e.target.value.toUpperCase())}
                                maxLength={6}
                                onKeyDown={(e) => e.key === 'Enter' && handleJoinRoom()}
                            />
                            <button
                                className="join-room-btn"
                                onClick={handleJoinRoom}
                                disabled={loading}
                            >
                                Katıl
                            </button>
                        </div>
                    )}
                </div>

                <button className="online-menu-logout" onClick={handleLogout}>
                    <LogOut size={14} />
                    Çıkış Yap
                </button>
            </main>
        </div>
    );
};

export default OnlineMenuScreen;
