import React from 'react';
import { useNavigate } from 'react-router-dom';
import { Users, HelpCircle, Wifi } from 'lucide-react';
import { useAuth } from '../context/AuthContext';
import './HomeScreen.css';

const HomeScreen = () => {
    const navigate = useNavigate();
    const { currentUser } = useAuth();

    return (
        <div className="home-screen safe-area">
            {/* App Bar */}
            <header className="app-bar">
                <img
                    src="/assets/images/splash_logo_600x600.png"
                    alt="Zihindar Logo Mini"
                    className="app-bar-logo"
                />
                <h1 className="app-title">Zihindar</h1>
                <div style={{ width: '36px' }}></div>
            </header>

            {/* Center Content */}
            <main className="center-content">
                <div className="logo-container glow-effect">
                    <img
                        src="/assets/images/splash_logo_600x600.png"
                        alt="Zihindar Logo"
                        className="main-logo"
                    />
                </div>

                <h2 className="tagline">Zihinleri tara, hedefi bul</h2>
                <p className="sub-tagline">"Türkçe Parti Oyunu"</p>

                <div className="badges-row">
                    <div className="badge badge-orange">
                        <Users size={12} className="badge-icon" />
                        <span>2-8 Oyuncu</span>
                    </div>
                    <div className="badge badge-cyan">
                        <svg
                            width="12"
                            height="12"
                            viewBox="0 0 24 24"
                            fill="none"
                            stroke="currentColor"
                            strokeWidth="2"
                            strokeLinecap="round"
                            strokeLinejoin="round"
                            className="badge-icon"
                        >
                            <circle cx="12" cy="12" r="10"></circle>
                            <polyline points="12 6 12 12 16 14"></polyline>
                        </svg>
                        <span>15 Dakika</span>
                    </div>
                </div>
            </main>

            {/* Bottom Buttons */}
            <footer className="bottom-buttons">
                <button
                    className="btn btn-primary"
                    onClick={() => navigate('/setup')}
                >
                    <Users size={20} className="btn-icon" />
                    Yerel Oyun
                </button>

                <button
                    className="btn btn-secondary"
                    onClick={() => {
                        if (currentUser) {
                            navigate('/online');
                        } else {
                            navigate('/login');
                        }
                    }}
                >
                    <Wifi size={20} className="btn-icon" />
                    Online Oyun
                </button>

                <button
                    className="btn-help"
                    onClick={() => alert('Wavelength, oyuncuların aynı dalga boyutunda olup olmadığını test eden bir parti oyunudur.\n\n1. Her turda bir oyuncu gizli hedefi görür\n2. Diğer oyuncular hedefi tahmin etmeye çalışır\n3. Hedefe ne kadar yakınsanız o kadar çok puan kazanırsınız\n4. En çok puanı toplayan kazanır!')}
                >
                    <HelpCircle size={16} className="help-icon" />
                    Nasıl Oynanır?
                </button>
            </footer>
        </div>
    );
};

export default HomeScreen;
