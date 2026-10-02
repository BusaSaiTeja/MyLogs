import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  AuthService({
    FirebaseAuth? auth,
    GoogleSignIn? googleSignIn,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn();

  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;

  User? get currentUser => _auth.currentUser;
  String? get currentUserId => _auth.currentUser?.uid;
  bool get isAnonymous => _auth.currentUser?.isAnonymous ?? false;
  bool get isAuthenticated => _auth.currentUser != null;
  String? get userEmail => _auth.currentUser?.email;
  String? get displayName => _auth.currentUser?.displayName;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Signs in anonymously as a guest.
  Future<UserCredential> signInAnonymously() async {
    return await _auth.signInAnonymously();
  }

  /// Ensures that there is an active authenticated user session.
  Future<User> ensureAuthenticated() async {
    final user = _auth.currentUser;
    if (user != null) return user;
    final credential = await _auth.signInAnonymously();
    return credential.user!;
  }

  /// Signs in with Email and Password.
  Future<UserCredential> signInWithEmail({
    required String email,
    required String password,
  }) async {
    return await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  /// Signs up with Email and Password, linking anonymous data if previously signed in as guest.
  Future<UserCredential> signUpWithEmail({
    required String email,
    required String password,
    String? displayName,
  }) async {
    final cleanEmail = email.trim();
    final user = _auth.currentUser;

    UserCredential credential;
    if (user != null && user.isAnonymous) {
      // Link guest account to email so existing logs remain attached to this user!
      final authCredential = EmailAuthProvider.credential(
        email: cleanEmail,
        password: password,
      );
      try {
        credential = await user.linkWithCredential(authCredential);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'credential-already-in-use' || e.code == 'email-already-in-use') {
          credential = await _auth.signInWithEmailAndPassword(
            email: cleanEmail,
            password: password,
          );
        } else {
          rethrow;
        }
      }
    } else {
      credential = await _auth.createUserWithEmailAndPassword(
        email: cleanEmail,
        password: password,
      );
    }

    if (displayName != null && displayName.trim().isNotEmpty) {
      await credential.user?.updateDisplayName(displayName.trim());
    }

    return credential;
  }

  /// Signs in with Google, linking guest data if active.
  Future<UserCredential?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      // The user canceled the sign-in flow
      return null;
    }

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final user = _auth.currentUser;
    if (user != null && user.isAnonymous) {
      try {
        return await user.linkWithCredential(credential);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'credential-already-in-use' || e.code == 'email-already-in-use') {
          return await _auth.signInWithCredential(credential);
        } else {
          rethrow;
        }
      }
    }

    return await _auth.signInWithCredential(credential);
  }

  /// Sends a password reset email.
  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email.trim());
  }

  /// Signs out completely.
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

final authStateProvider = StreamProvider<User?>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.authStateChanges;
});

final currentUserIdProvider = StreamProvider<String?>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.authStateChanges.map((user) => user?.uid);
});
