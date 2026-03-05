import React, { createContext, useState, useEffect, useContext } from 'react';
import { auth, db, googleProvider } from '../firebase';
import {
    onAuthStateChanged,
    signInAnonymously,
    signInWithPopup,
    signOut,
    updateProfile
} from 'firebase/auth';
import { doc, setDoc, serverTimestamp } from 'firebase/firestore';

const AuthContext = createContext();

// eslint-disable-next-line react-refresh/only-export-components
export const useAuth = () => useContext(AuthContext);

export const AuthProvider = ({ children }) => {
    const [currentUser, setCurrentUser] = useState(null);
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        const unsubscribe = onAuthStateChanged(auth, (user) => {
            setCurrentUser(user);
            setLoading(false);
        });
        return unsubscribe;
    }, []);

    // Anonim giriş - sadece isim gir ve oyna
    const loginAsGuest = async (displayName) => {
        const credential = await signInAnonymously(auth);
        const user = credential.user;
        if (user) {
            await updateProfile(user, { displayName });
            await setDoc(doc(db, 'users', user.uid), {
                displayName,
                createdAt: serverTimestamp(),
                isAnonymous: true,
                gamesPlayed: 0,
            }, { merge: true });
        }
        return user;
    };

    // Google ile giriş
    const loginWithGoogle = async () => {
        const result = await signInWithPopup(auth, googleProvider);
        const user = result.user;
        if (user) {
            await setDoc(doc(db, 'users', user.uid), {
                displayName: user.displayName || 'Oyuncu',
                email: user.email,
                photoUrl: user.photoURL,
                createdAt: serverTimestamp(),
                isAnonymous: false,
                gamesPlayed: 0,
            }, { merge: true });
        }
        return user;
    };

    const logout = () => signOut(auth);

    const displayName = currentUser?.displayName || 'Oyuncu';

    const value = {
        currentUser,
        displayName,
        loginAsGuest,
        loginWithGoogle,
        logout
    };

    return (
        <AuthContext.Provider value={value}>
            {!loading && children}
        </AuthContext.Provider>
    );
};
