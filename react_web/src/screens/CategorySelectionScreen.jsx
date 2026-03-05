import React, { useEffect } from 'react';
import { useNavigate, useLocation } from 'react-router-dom';
import { useGame } from '../context/GameContext';
import { GameCategory } from '../data/gameData';
import { PartyPopper, Compass, Brain, Sparkles, Trophy, Users, ArrowLeft } from 'lucide-react';
import './CategorySelectionScreen.css';

const iconMap = {
    'celebration': PartyPopper,
    'explore': Compass,
    'psychology': Brain,
    'auto_awesome': Sparkles,
    'emoji_events': Trophy,
    'groups': Users
};

const CategorySelectionScreen = () => {
    const navigate = useNavigate();
    const location = useLocation();
    const { initializeGame } = useGame();

    const players = location.state?.players;

    // Redirect to setup if no players data
    useEffect(() => {
        if (!players) {
            navigate('/setup', { replace: true });
        }
    }, [players, navigate]);

    if (!players) return null;

    const handleCategorySelect = (categoryId) => {
        initializeGame(players, categoryId);
        navigate('/secret-target');
    };

    return (
        <div className="cat-screen safe-area">
            <header className="app-bar">
                <button className="back-btn" onClick={() => navigate(-1)}>
                    <ArrowLeft size={24} color="#FFFFFF" />
                </button>
                <h1 className="app-title">Kategori Seç</h1>
                <div style={{ width: '40px' }}></div>
            </header>

            <main className="cat-content">
                <p className="cat-subtitle">Oynamak istediğiniz temayı seçin</p>

                <div className="cat-grid">
                    {GameCategory.all.map((category) => {
                        const IconComp = iconMap[category.icon];

                        return (
                            <div
                                key={category.id}
                                className="cat-card"
                                onClick={() => handleCategorySelect(category.id)}
                            >
                                <div className="cat-icon-wrapper">
                                    <IconComp size={36} className="cat-icon" />
                                </div>
                                <span className="cat-name">{category.name}</span>

                                <div className="cat-card-overlay"></div>
                            </div>
                        );
                    })}
                </div>
            </main>
        </div>
    );
};

export default CategorySelectionScreen;
