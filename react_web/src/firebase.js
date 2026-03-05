import { initializeApp } from "firebase/app";
import { getAuth, GoogleAuthProvider } from "firebase/auth";
import { getFirestore } from "firebase/firestore";

const firebaseConfig = {
    apiKey: "AIzaSyBhqCArkoYHdGxWmzebnW_ZyAFvIzrSqEI",
    authDomain: "zihindar.firebaseapp.com",
    databaseURL: "https://zihindar-default-rtdb.firebaseio.com",
    projectId: "zihindar",
    storageBucket: "zihindar.firebasestorage.app",
    messagingSenderId: "345376266726",
    appId: "1:345376266726:web:608dd589acd083697d9e27",
    measurementId: "G-5K3JDWR3JZ"
};

const app = initializeApp(firebaseConfig);

export const auth = getAuth(app);
export const db = getFirestore(app);
export const googleProvider = new GoogleAuthProvider();
