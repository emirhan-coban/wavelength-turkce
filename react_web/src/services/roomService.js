import { db } from '../firebase';
import {
    doc, getDoc, setDoc, updateDoc, deleteDoc,
    onSnapshot, runTransaction, serverTimestamp
} from 'firebase/firestore';
import { SpectrumData } from '../data/gameData';

// 6 haneli benzersiz oda kodu oluştur
const generateRoomCode = () => {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    return Array.from({ length: 6 }, () => chars[Math.floor(Math.random() * chars.length)]).join('');
};

// Oda oluştur
export const createRoom = async ({ hostUid, hostName }) => {
    let roomCode;
    let exists = true;

    do {
        roomCode = generateRoomCode();
        const docSnap = await getDoc(doc(db, 'rooms', roomCode));
        exists = docSnap.exists();
    } while (exists);

    await setDoc(doc(db, 'rooms', roomCode), {
        hostUid,
        status: 'waiting',
        phase: 'lobby',
        categoryId: null,
        totalRounds: 0,
        currentRound: 0,
        currentLeaderIndex: 0,
        targetPosition: 0,
        clue: null,
        currentPair: null,
        createdAt: serverTimestamp(),
        players: [{
            uid: hostUid,
            name: hostName,
            score: 0,
            order: 0,
            isConnected: true,
        }],
        guesses: {},
        usedPairIndices: [],
    });

    return roomCode;
};

// Odaya katıl
export const joinRoom = async ({ roomCode, uid, name }) => {
    const ref = doc(db, 'rooms', roomCode);

    return runTransaction(db, async (transaction) => {
        const docSnap = await transaction.get(ref);
        if (!docSnap.exists()) return false;

        const data = docSnap.data();
        if (data.status !== 'waiting') return false;

        const players = [...(data.players || [])];
        const existingIdx = players.findIndex(p => p.uid === uid);

        if (existingIdx >= 0) {
            players[existingIdx].isConnected = true;
            players[existingIdx].name = name;
        } else {
            if (players.length >= 8) return false;
            players.push({
                uid,
                name,
                score: 0,
                order: players.length,
                isConnected: true,
            });
        }

        transaction.update(ref, { players });
        return true;
    });
};

// Odadan ayrıl
export const leaveRoom = async ({ roomCode, uid }) => {
    const ref = doc(db, 'rooms', roomCode);

    await runTransaction(db, async (transaction) => {
        const docSnap = await transaction.get(ref);
        if (!docSnap.exists()) return;

        const data = docSnap.data();
        const players = [...(data.players || [])];
        const leavingIndex = players.findIndex(p => p.uid === uid);
        if (leavingIndex < 0) return;

        players.splice(leavingIndex, 1);

        if (players.length === 0) {
            transaction.delete(ref);
            return;
        }

        let hostUid = data.hostUid;
        if (hostUid === uid) {
            hostUid = players[0].uid;
        }

        const updateData = { players, hostUid };

        if (data.status === 'playing') {
            let leaderIndex = data.currentLeaderIndex;
            if (leavingIndex < leaderIndex) leaderIndex--;
            if (leaderIndex >= players.length) leaderIndex = 0;
            updateData.currentLeaderIndex = leaderIndex;

            if (data.phase === 'guessing') {
                const guesses = { ...(data.guesses || {}) };
                delete guesses[uid];
                const expectedGuessCount = players.length - 1;
                if (expectedGuessCount <= 0 || Object.keys(guesses).length >= expectedGuessCount) {
                    updateData.phase = 'results';
                    updateData.guesses = guesses;
                }
            }

            if (players.length < 2) {
                updateData.phase = 'game_over';
                updateData.status = 'finished';
            }
        }

        transaction.update(ref, updateData);
    });
};

// Oda stream'i
export const subscribeToRoom = (roomCode, callback) => {
    return onSnapshot(doc(db, 'rooms', roomCode), (docSnap) => {
        if (docSnap.exists()) {
            callback({ id: docSnap.id, ...docSnap.data() });
        } else {
            callback(null);
        }
    });
};

// Kategori seç ve oyunu başlat (sadece host)
export const startGame = async ({ roomCode, categoryId }) => {
    const ref = doc(db, 'rooms', roomCode);
    const docSnap = await getDoc(ref);
    const players = [...(docSnap.data().players || [])];
    const totalRounds = players.length * 2;

    const pairs = SpectrumData.getPairsForCategory(categoryId);
    const firstPairIdx = Math.floor(Math.random() * pairs.length);
    const firstPair = pairs[firstPairIdx];
    const targetPosition = Math.random() * 0.7 + 0.15;

    for (const p of players) {
        p.score = 0;
    }

    await updateDoc(ref, {
        status: 'playing',
        phase: 'showing_target',
        categoryId,
        totalRounds,
        currentRound: 1,
        currentLeaderIndex: 0,
        targetPosition,
        clue: null,
        currentPair: {
            leftConcept: firstPair.leftConcept,
            rightConcept: firstPair.rightConcept,
            categoryId: firstPair.categoryId,
        },
        players,
        guesses: {},
        usedPairIndices: [firstPairIdx],
    });
};

// Lider hedefi gördü -> ipucu yazma aşaması
export const advanceToCluePhase = async ({ roomCode }) => {
    await updateDoc(doc(db, 'rooms', roomCode), { phase: 'waiting_clue' });
};

// Lider ipucu gönder
export const submitClue = async ({ roomCode, clue }) => {
    await updateDoc(doc(db, 'rooms', roomCode), {
        clue,
        phase: 'guessing',
        guesses: {},
    });
};

// Oyuncu tahmin gönder
export const submitGuess = async ({ roomCode, uid, guessPosition }) => {
    const ref = doc(db, 'rooms', roomCode);

    await runTransaction(db, async (transaction) => {
        const docSnap = await transaction.get(ref);
        if (!docSnap.exists()) return;

        const data = docSnap.data();
        const target = data.targetPosition;
        const guesses = { ...(data.guesses || {}) };
        const players = [...(data.players || [])];
        const leaderIndex = data.currentLeaderIndex;

        if (guesses[uid]) return; // zaten tahmin yapmış

        const diff = Math.abs(guessPosition - target);
        let score;
        if (diff <= 0.05) score = 50;
        else if (diff <= 0.12) score = 30;
        else if (diff <= 0.20) score = 20;
        else if (diff <= 0.35) score = 10;
        else score = 0;

        guesses[uid] = { position: guessPosition, score };

        const playerIdx = players.findIndex(p => p.uid === uid);
        if (playerIdx >= 0) {
            players[playerIdx] = { ...players[playerIdx], score: players[playerIdx].score + score };
        }

        const expectedGuessCount = players.length - 1;
        const allGuessed = Object.keys(guesses).length >= expectedGuessCount;

        const updateData = { guesses, players };

        if (allGuessed) {
            let totalScore = 0;
            Object.values(guesses).forEach(v => totalScore += v.score);
            const leaderScore = Math.round(totalScore / Object.keys(guesses).length);

            if (leaderIndex < players.length) {
                players[leaderIndex] = {
                    ...players[leaderIndex],
                    score: players[leaderIndex].score + leaderScore
                };
            }
            updateData.players = players;
            updateData.phase = 'results';
        }

        transaction.update(ref, updateData);
    });
};

// Sonraki tura geç (sadece host)
export const nextRound = async ({ roomCode }) => {
    const ref = doc(db, 'rooms', roomCode);

    await runTransaction(db, async (transaction) => {
        const docSnap = await transaction.get(ref);
        if (!docSnap.exists()) return;

        const data = docSnap.data();
        const currentRound = data.currentRound;
        const totalRounds = data.totalRounds;
        const players = [...(data.players || [])];
        const categoryId = data.categoryId;
        const usedIndices = [...(data.usedPairIndices || [])];

        if (currentRound >= totalRounds) {
            transaction.update(ref, { phase: 'game_over', status: 'finished' });
            return;
        }

        const allPairs = SpectrumData.getPairsForCategory(categoryId);
        if (usedIndices.length >= allPairs.length) usedIndices.length = 0;

        let newPairIdx;
        do {
            newPairIdx = Math.floor(Math.random() * allPairs.length);
        } while (usedIndices.includes(newPairIdx));

        const newPair = allPairs[newPairIdx];
        usedIndices.push(newPairIdx);

        const newLeaderIndex = currentRound % players.length;
        const newTarget = Math.random() * 0.7 + 0.15;

        transaction.update(ref, {
            currentRound: currentRound + 1,
            currentLeaderIndex: newLeaderIndex,
            targetPosition: newTarget,
            clue: null,
            phase: 'showing_target',
            currentPair: {
                leftConcept: newPair.leftConcept,
                rightConcept: newPair.rightConcept,
                categoryId: newPair.categoryId,
            },
            guesses: {},
            usedPairIndices: usedIndices,
        });
    });
};

// Oyunu yeniden başlat
export const restartGame = async ({ roomCode }) => {
    const ref = doc(db, 'rooms', roomCode);
    const docSnap = await getDoc(ref);
    if (!docSnap.exists()) return;

    const players = [...(docSnap.data().players || [])];
    for (const p of players) p.score = 0;

    await updateDoc(ref, {
        status: 'waiting',
        phase: 'lobby',
        currentRound: 0,
        currentLeaderIndex: 0,
        targetPosition: 0,
        clue: null,
        currentPair: null,
        guesses: {},
        usedPairIndices: [],
        players,
        categoryId: null,
    });
};

// Odayı sil
export const deleteRoom = async (roomCode) => {
    await deleteDoc(doc(db, 'rooms', roomCode));
};
