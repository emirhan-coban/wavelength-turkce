import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final GoogleSignIn _googleSignIn = GoogleSignIn();
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static User? get currentUser => _auth.currentUser;
  static bool get isLoggedIn => _auth.currentUser != null;
  static Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Anonim giriş - sadece isim gir ve oyna
  static Future<User?> signInAnonymously(String displayName) async {
    try {
      final credential = await _auth.signInAnonymously();
      final user = credential.user;
      if (user != null) {
        await user.updateDisplayName(displayName);
        await _db.collection('users').doc(user.uid).set({
          'displayName': displayName,
          'createdAt': FieldValue.serverTimestamp(),
          'isAnonymous': true,
          'gamesPlayed': 0,
        }, SetOptions(merge: true));
      }
      return user;
    } catch (e) {
      rethrow;
    }
  }

  /// Google ile giriş
  static Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;

      if (user != null) {
        await _db.collection('users').doc(user.uid).set({
          'displayName': user.displayName ?? 'Oyuncu',
          'email': user.email,
          'photoUrl': user.photoURL,
          'createdAt': FieldValue.serverTimestamp(),
          'isAnonymous': false,
          'gamesPlayed': 0,
        }, SetOptions(merge: true));
      }
      return user;
    } catch (e) {
      rethrow;
    }
  }

  /// Çıkış yap
  static Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  /// Kullanıcı adını al
  static String get displayName => currentUser?.displayName ?? 'Oyuncu';
}
