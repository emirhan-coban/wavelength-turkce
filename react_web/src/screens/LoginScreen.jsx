import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { useAuth } from '../context/AuthContext';
import { ArrowLeft } from 'lucide-react';
import './LoginScreen.css';

const LoginScreen = () => {
    const navigate = useNavigate();
    const { loginAsGuest, loginWithGoogle } = useAuth();
    const [name, setName] = useState('');
    const [error, setError] = useState('');
    const [loading, setLoading] = useState(false);

    const handleGuestLogin = async () => {
        if (!name.trim()) {
            setError('Lütfen bir isim girin');
            return;
        }
        setLoading(true);
        setError('');
        try {
            await loginAsGuest(name.trim());
            navigate('/online');
        } catch {
            setError('Giriş başarısız oldu. Tekrar deneyin.');
        } finally {
            setLoading(false);
        }
    };

    const handleGoogleLogin = async () => {
        setLoading(true);
        setError('');
        try {
            await loginWithGoogle();
            navigate('/online');
        } catch {
            setError('Google ile giriş başarısız oldu.');
        } finally {
            setLoading(false);
        }
    };

    return (
        <div className="login-screen safe-area">
            <header className="app-bar">
                <button className="login-back-btn" onClick={() => navigate('/')}>
                    <ArrowLeft size={20} />
                </button>
                <h1 className="app-title">Online Giriş</h1>
                <div style={{ width: '36px' }}></div>
            </header>

            <main className="login-center">
                <div className="login-logo-container glow-effect">
                    <img
                        src="/assets/images/splash_logo_600x600.png"
                        alt="Zihindar Logo"
                        className="login-logo"
                    />
                </div>

                <h2 className="login-title">Online Oyuna Katıl</h2>
                <p className="login-subtitle">
                    İsminizi girerek hızlıca başlayın veya Google hesabınızla giriş yapın
                </p>

                {error && <p className="login-error">{error}</p>}

                <div className="login-form">
                    <input
                        type="text"
                        className="login-input"
                        placeholder="İsminizi girin..."
                        value={name}
                        onChange={(e) => setName(e.target.value)}
                        maxLength={20}
                        onKeyDown={(e) => e.key === 'Enter' && handleGuestLogin()}
                    />

                    <button
                        className="btn btn-primary"
                        onClick={handleGuestLogin}
                        disabled={loading}
                    >
                        {loading ? 'Giriş yapılıyor...' : '🎮 Hızlı Giriş'}
                    </button>

                    <div className="login-divider">
                        <span className="login-divider-line" />
                        <span className="login-divider-text">veya</span>
                        <span className="login-divider-line" />
                    </div>

                    <button
                        className="btn-google"
                        onClick={handleGoogleLogin}
                        disabled={loading}
                    >
                        <svg viewBox="0 0 24 24">
                            <path fill="#4285F4" d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92a5.06 5.06 0 0 1-2.2 3.32v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.1z" />
                            <path fill="#34A853" d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z" />
                            <path fill="#FBBC05" d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l2.85-2.22.81-.62z" />
                            <path fill="#EA4335" d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z" />
                        </svg>
                        Google ile Giriş
                    </button>
                </div>
            </main>
        </div>
    );
};

export default LoginScreen;
