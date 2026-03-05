import React, { createContext, useState, useContext, useCallback } from 'react';
import { SpectrumData } from '../data/gameData';

const GameContext = createContext();

// eslint-disable-next-line react-refresh/only-export-components
export const useGame = () => useContext(GameContext);

export const GameProvider = ({ children }) => {
    const [players, setPlayers] = useState([]);
    const [categoryId, setCategoryId] = useState(null);
    const [currentRound, setCurrentRound] = useState(0);
    const [totalRounds, setTotalRounds] = useState(0);
    const [targetPosition, setTargetPosition] = useState(0.5);
    const [lastGuessPosition, setLastGuessPosition] = useState(null);
    const [lastScore, setLastScore] = useState(null);
    const [currentPair, setCurrentPair] = useState(null);
    const [, setAvailablePairs] = useState([]);

    // Initialization: set up players, category, shuffle pairs, and start round 1
    const initializeGame = useCallback((newPlayers, selectedCategoryId) => {
        const initializedPlayers = newPlayers.map(p => ({
            ...p,
            score: 0
        }));
        setPlayers(initializedPlayers);
        setCategoryId(selectedCategoryId);
        const rounds = initializedPlayers.length * 2;
        setTotalRounds(rounds);

        const pairs = SpectrumData.getPairsForCategory(selectedCategoryId);
        const shuffled = [...pairs].sort(() => Math.random() - 0.5);

        // Immediately start round 1 so SecretTargetScreen has data on mount
        const newTarget = Math.random() * 0.7 + 0.15;
        const firstPair = shuffled.pop();

        setAvailablePairs(shuffled);
        setCurrentRound(1);
        setTargetPosition(newTarget);
        setCurrentPair(firstPair);
        setLastGuessPosition(null);
        setLastScore(null);
    }, []);

    // Leader index: round 1 -> player 0, round 2 -> player 1, etc.
    const getLeaderIndex = useCallback(() => {
        if (players.length === 0) return 0;
        return (currentRound - 1) % players.length;
    }, [players.length, currentRound]);

    const startNewRound = useCallback(() => {
        setCurrentRound(prev => prev + 1);

        // Generate random target position (0.15 to 0.85) to avoid extreme edges
        setTargetPosition(Math.random() * 0.7 + 0.15);

        setAvailablePairs(prev => {
            let pairs = [...prev];
            if (pairs.length === 0) {
                pairs = [...SpectrumData.getPairsForCategory(categoryId)].sort(() => Math.random() - 0.5);
            }
            const pair = pairs.pop();
            setCurrentPair(pair);
            return pairs;
        });

        setLastGuessPosition(null);
        setLastScore(null);
    }, [categoryId]);

    const submitGuess = useCallback((guessPosition) => {
        setLastGuessPosition(guessPosition);
        const diff = Math.abs(guessPosition - targetPosition);

        let score = 0;
        if (diff <= 0.05) score = 50;
        else if (diff <= 0.12) score = 30;
        else if (diff <= 0.20) score = 20;
        else if (diff <= 0.35) score = 10;
        else score = 0;

        setLastScore(score);

        const leaderIndex = getLeaderIndex();
        setPlayers(prevPlayers => {
            return prevPlayers.map((p, i) =>
                i === leaderIndex ? { ...p, score: p.score + score } : p
            );
        });

        return score;
    }, [targetPosition, getLeaderIndex]);

    const getScoreMessage = useCallback((score) => {
        if (score == null) return '';
        if (score >= 50) return 'Harika Bir Tahmin!';
        if (score >= 30) return 'Çok İyi!';
        if (score >= 20) return 'İyi Tahmin!';
        if (score >= 10) return 'Fena Değil!';
        return 'Bir Dahaki Sefere!';
    }, []);

    const resetGame = useCallback(() => {
        setCurrentRound(0);
        setCurrentPair(null);
        setPlayers(prev => prev.map(p => ({ ...p, score: 0 })));
        setLastGuessPosition(null);
        setLastScore(null);
        if (categoryId) {
            const pairs = SpectrumData.getPairsForCategory(categoryId);
            const shuffled = [...pairs].sort(() => Math.random() - 0.5);
            setAvailablePairs(shuffled);
        }
    }, [categoryId]);

    const value = {
        players,
        categoryId,
        currentRound,
        totalRounds,
        targetPosition,
        lastGuessPosition,
        lastScore,
        currentPair,
        isGameOver: currentRound > 0 && currentRound >= totalRounds,
        currentLeader: players.length > 0 ? players[getLeaderIndex()] : null,
        initializeGame,
        startNewRound,
        submitGuess,
        getScoreMessage,
        resetGame,
        setPlayers
    };

    return (
        <GameContext.Provider value={value}>
            {children}
        </GameContext.Provider>
    );
};
