import React, { useState, useEffect, useRef, useCallback } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import { useAuth } from '../context/AuthContext';
import {
    subscribeToRoom, leaveRoom, advanceToCluePhase,
    submitClue, submitGuess, nextRound, restartGame
} from '../services/roomService';
import { ArrowLeft } from 'lucide-react';
import './OnlineGameScreen.css';

const OnlineGameScreen = () => {
    const navigate = useNavigate();
    const { roomCode } = useParams();
    const { currentUser } = useAuth();
    const [roomData, setRoomData] = useState(null);
    const [clue, setClue] = useState('');
    const [guessPos, setGuessPos] = useState(0.5);
    const [hasGuessed, setHasGuessed] = useState(false);
    const spectrumRef = useRef(null);

    useEffect(() => {
        if (!roomCode) return;
        const unsubscribe = subscribeToRoom(roomCode, (data) => {
            if (!data) {
                navigate('/online');
                return;
            }
            setRoomData(data);

            // Tur değiştiğinde guess state'i sıfırla
            if (data.phase === 'showing_target' || data.phase === 'waiting_clue') {
                setHasGuessed(false);
                setGuessPos(0.5);
                setClue('');
            }

            // Lobby'e dönüş
            if (data.phase === 'lobby') {
                navigate(`/room/${roomCode}`);
            }
        });
        return () => unsubscribe();
    }, [roomCode, navigate]);

    const handleSpectrumTouch = useCallback((e) => {
        if (!spectrumRef.current) return;
        const rect = spectrumRef.current.getBoundingClientRect();
        const clientX = e.touches ? e.touches[0].clientX : e.clientX;
        let pos = (clientX - rect.left) / rect.width;
        pos = Math.max(0.02, Math.min(0.98, pos));
        setGuessPos(pos);
    }, []);

    const handleLeave = async () => {
        await leaveRoom({ roomCode, uid: currentUser.uid });
        navigate('/online');
    };

    if (!roomData || !currentUser) {
        return (
            <div className="online-game safe-area">
                <main className="online-game-center">
                    <p className="waiting-text">Yükleniyor...</p>
                </main>
            </div>
        );
    }

    const players = roomData.players || [];
    const leaderIndex = roomData.currentLeaderIndex || 0;
    const leader = players[leaderIndex];
    const isLeader = leader?.uid === currentUser.uid;
    const isHost = roomData.hostUid === currentUser.uid;
    const pair = roomData.currentPair;
    const phase = roomData.phase;

    const getScoreMessage = (score) => {
        if (score >= 50) return 'Harika Bir Tahmin! 🎯';
        if (score >= 30) return 'Çok İyi! 🔥';
        if (score >= 20) return 'İyi Tahmin! 👍';
        if (score >= 10) return 'Fena Değil! 🤔';
        return 'Bir Dahaki Sefere! 😅';
    };

    // ─── PHASE: showing_target (sadece lider hedefi görür) ───
    if (phase === 'showing_target') {
        return (
            <div className="online-game safe-area">
                <header className="app-bar">
                    <button className="login-back-btn" onClick={handleLeave}>
                        <ArrowLeft size={20} />
                    </button>
                    <h1 className="app-title">Tur {roomData.currentRound}/{roomData.totalRounds}</h1>
                    <div style={{ width: '36px' }}></div>
                </header>
                <main className="online-game-center">
                    {isLeader ? (
                        <>
                            <div className="phase-header">
                                <p className="phase-round">Gizli Hedef</p>
                                <h2 className="phase-title">Sadece Sen Görebilirsin!</h2>
                                <p className="phase-subtitle">Hedefi gör ve ipucu ver</p>
                            </div>

                            {pair && (
                                <div className="spectrum-container">
                                    <div className="spectrum-labels">
                                        <span className="spectrum-label spectrum-label-left">{pair.leftConcept}</span>
                                        <span className="spectrum-label spectrum-label-right">{pair.rightConcept}</span>
                                    </div>
                                    <div className="spectrum-bar">
                                        <div
                                            className="spectrum-target-marker"
                                            style={{ left: `${roomData.targetPosition * 100}%` }}
                                        />
                                    </div>
                                </div>
                            )}

                            <button
                                className="btn btn-primary"
                                style={{ width: '100%' }}
                                onClick={() => advanceToCluePhase({ roomCode })}
                            >
                                ✅ Hedefi Gördüm, İpucu Yazayım
                            </button>
                        </>
                    ) : (
                        <div className="waiting-container">
                            <div className="waiting-emoji">🎯</div>
                            <p className="waiting-text">
                                <strong>{leader?.name}</strong> gizli hedefi görüyor...
                            </p>
                        </div>
                    )}
                </main>
            </div>
        );
    }

    // ─── PHASE: waiting_clue (lider ipucu yazar) ───
    if (phase === 'waiting_clue') {
        return (
            <div className="online-game safe-area">
                <header className="app-bar">
                    <button className="login-back-btn" onClick={handleLeave}>
                        <ArrowLeft size={20} />
                    </button>
                    <h1 className="app-title">Tur {roomData.currentRound}/{roomData.totalRounds}</h1>
                    <div style={{ width: '36px' }}></div>
                </header>
                <main className="online-game-center">
                    {isLeader ? (
                        <>
                            <div className="phase-header">
                                <p className="phase-round">İpucu Zamanı</p>
                                <h2 className="phase-title">Bir İpucu Yaz</h2>
                                <p className="phase-subtitle">Tek kelime ile hedefi tarif et</p>
                            </div>

                            {pair && (
                                <div className="spectrum-container">
                                    <div className="spectrum-labels">
                                        <span className="spectrum-label spectrum-label-left">{pair.leftConcept}</span>
                                        <span className="spectrum-label spectrum-label-right">{pair.rightConcept}</span>
                                    </div>
                                    <div className="spectrum-bar">
                                        <div
                                            className="spectrum-target-marker"
                                            style={{ left: `${roomData.targetPosition * 100}%` }}
                                        />
                                    </div>
                                </div>
                            )}

                            <div className="clue-section">
                                <input
                                    type="text"
                                    className="clue-input"
                                    placeholder="İpucu yaz..."
                                    value={clue}
                                    onChange={(e) => setClue(e.target.value)}
                                    maxLength={30}
                                />
                                <button
                                    className="btn btn-primary"
                                    style={{ width: '100%' }}
                                    onClick={() => clue.trim() && submitClue({ roomCode, clue: clue.trim() })}
                                    disabled={!clue.trim()}
                                >
                                    📨 İpucunu Gönder
                                </button>
                            </div>
                        </>
                    ) : (
                        <div className="waiting-container">
                            <div className="waiting-emoji">💭</div>
                            <p className="waiting-text">
                                <strong>{leader?.name}</strong> ipucu yazıyor...
                            </p>
                        </div>
                    )}
                </main>
            </div>
        );
    }

    // ─── PHASE: guessing (diğer oyuncular tahmin eder) ───
    if (phase === 'guessing') {
        const guesses = roomData.guesses || {};
        const alreadyGuessed = hasGuessed || !!guesses[currentUser.uid];

        return (
            <div className="online-game safe-area">
                <header className="app-bar">
                    <button className="login-back-btn" onClick={handleLeave}>
                        <ArrowLeft size={20} />
                    </button>
                    <h1 className="app-title">Tur {roomData.currentRound}/{roomData.totalRounds}</h1>
                    <div style={{ width: '36px' }}></div>
                </header>
                <main className="online-game-center">
                    <div className="clue-display">
                        <p className="clue-display-label">İpucu</p>
                        <p className="clue-display-text">"{roomData.clue}"</p>
                    </div>

                    {pair && (
                        <div className="spectrum-container">
                            <div className="spectrum-labels">
                                <span className="spectrum-label spectrum-label-left">{pair.leftConcept}</span>
                                <span className="spectrum-label spectrum-label-right">{pair.rightConcept}</span>
                            </div>
                            {!isLeader && !alreadyGuessed ? (
                                <div
                                    className="spectrum-bar"
                                    ref={spectrumRef}
                                    onTouchMove={handleSpectrumTouch}
                                    onTouchStart={handleSpectrumTouch}
                                    onMouseDown={handleSpectrumTouch}
                                    onMouseMove={(e) => e.buttons === 1 && handleSpectrumTouch(e)}
                                >
                                    <div
                                        className="spectrum-guess-marker"
                                        style={{ left: `${guessPos * 100}%` }}
                                    />
                                </div>
                            ) : (
                                <div className="spectrum-bar" />
                            )}
                        </div>
                    )}

                    {isLeader ? (
                        <div className="waiting-container">
                            <div className="waiting-emoji">⏳</div>
                            <p className="waiting-text">
                                Oyuncular tahmin ediyor... ({Object.keys(guesses).length}/{players.length - 1})
                            </p>
                        </div>
                    ) : alreadyGuessed ? (
                        <div className="waiting-container">
                            <div className="waiting-emoji">✅</div>
                            <p className="waiting-text">
                                Tahminin gönderildi! Diğer oyuncular bekleniyor...
                            </p>
                        </div>
                    ) : (
                        <button
                            className="btn btn-primary"
                            style={{ width: '100%' }}
                            onClick={async () => {
                                setHasGuessed(true);
                                await submitGuess({
                                    roomCode,
                                    uid: currentUser.uid,
                                    guessPosition: guessPos
                                });
                            }}
                        >
                            🎯 Tahmini Gönder
                        </button>
                    )}
                </main>
            </div>
        );
    }

    // ─── PHASE: results ───
    if (phase === 'results') {
        const guesses = roomData.guesses || {};
        const sortedPlayers = [...players].sort((a, b) => b.score - a.score);

        return (
            <div className="online-game safe-area">
                <header className="app-bar">
                    <button className="login-back-btn" onClick={handleLeave}>
                        <ArrowLeft size={20} />
                    </button>
                    <h1 className="app-title">Sonuçlar</h1>
                    <div style={{ width: '36px' }}></div>
                </header>
                <main className="online-game-center">
                    {pair && (
                        <div className="spectrum-container">
                            <div className="spectrum-labels">
                                <span className="spectrum-label spectrum-label-left">{pair.leftConcept}</span>
                                <span className="spectrum-label spectrum-label-right">{pair.rightConcept}</span>
                            </div>
                            <div className="spectrum-bar">
                                <div
                                    className="spectrum-target-marker"
                                    style={{ left: `${roomData.targetPosition * 100}%` }}
                                />
                            </div>
                        </div>
                    )}

                    <div className="results-scoreboard">
                        {Object.entries(guesses).map(([uid, guess]) => {
                            const player = players.find(p => p.uid === uid);
                            return (
                                <div key={uid} className="result-player-row">
                                    <span className="result-player-name">
                                        {player?.name || 'Oyuncu'}
                                    </span>
                                    <span className="result-guess-score">
                                        {getScoreMessage(guess.score)}
                                    </span>
                                    <span className="result-player-score">+{guess.score}</span>
                                </div>
                            );
                        })}
                    </div>

                    <h3 className="lobby-players-title">Skor Tablosu</h3>
                    <div className="results-scoreboard">
                        {sortedPlayers.map((player, idx) => (
                            <div key={player.uid} className="result-player-row">
                                <span style={{ fontSize: '18px', marginRight: '4px' }}>
                                    {idx === 0 ? '🥇' : idx === 1 ? '🥈' : idx === 2 ? '🥉' : `${idx + 1}.`}
                                </span>
                                <span className="result-player-name">{player.name}</span>
                                <span className="result-player-score">{player.score} puan</span>
                            </div>
                        ))}
                    </div>

                    {isHost && (
                        <div className="game-bottom">
                            <button
                                className="btn btn-primary"
                                style={{ width: '100%' }}
                                onClick={() => nextRound({ roomCode })}
                            >
                                {roomData.currentRound >= roomData.totalRounds ? '🏆 Oyunu Bitir' : '➡️ Sonraki Tur'}
                            </button>
                        </div>
                    )}

                    {!isHost && (
                        <p className="lobby-waiting-text" style={{ marginTop: '8px' }}>
                            Host'un sonraki tura geçmesi bekleniyor...
                        </p>
                    )}
                </main>
            </div>
        );
    }

    // ─── PHASE: game_over ───
    if (phase === 'game_over') {
        const sortedPlayers = [...players].sort((a, b) => b.score - a.score);
        const winner = sortedPlayers[0];

        return (
            <div className="online-game safe-area">
                <header className="app-bar">
                    <button className="login-back-btn" onClick={() => navigate('/online')}>
                        <ArrowLeft size={20} />
                    </button>
                    <h1 className="app-title">Oyun Bitti!</h1>
                    <div style={{ width: '36px' }}></div>
                </header>
                <main className="online-game-center">
                    <div className="game-over-container">
                        <div className="game-over-trophy">🏆</div>
                        <p className="game-over-label">Kazanan</p>
                        <h2 className="game-over-winner">{winner?.name}</h2>
                        <p className="game-over-label">{winner?.score} puan</p>
                    </div>

                    <div className="results-scoreboard">
                        {sortedPlayers.map((player, idx) => (
                            <div key={player.uid} className="result-player-row">
                                <span style={{ fontSize: '18px', marginRight: '4px' }}>
                                    {idx === 0 ? '🥇' : idx === 1 ? '🥈' : idx === 2 ? '🥉' : `${idx + 1}.`}
                                </span>
                                <span className="result-player-name">{player.name}</span>
                                <span className="result-player-score">{player.score} puan</span>
                            </div>
                        ))}
                    </div>

                    <div className="game-bottom">
                        {isHost && (
                            <button
                                className="btn btn-primary"
                                style={{ width: '100%' }}
                                onClick={() => restartGame({ roomCode })}
                            >
                                🔄 Tekrar Oyna
                            </button>
                        )}
                        <button
                            className="btn btn-secondary"
                            style={{ width: '100%' }}
                            onClick={handleLeave}
                        >
                            🚪 Odadan Ayrıl
                        </button>
                    </div>
                </main>
            </div>
        );
    }

    // Fallback
    return (
        <div className="online-game safe-area">
            <main className="online-game-center">
                <p className="waiting-text">Yükleniyor...</p>
            </main>
        </div>
    );
};

export default OnlineGameScreen;
