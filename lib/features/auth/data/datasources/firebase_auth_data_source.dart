import 'package:firebase_auth/firebase_auth.dart';

/// Thin wrapper around [FirebaseAuth]; the only class that touches the
/// Firebase Auth SDK. Failures surface as [FirebaseAuthException]s and are
/// mapped to application failures in the repository.
class FirebaseAuthDataSource {
  FirebaseAuthDataSource(this._firebaseAuth);

  final FirebaseAuth _firebaseAuth;

  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) => _firebaseAuth.signInWithEmailAndPassword(
    email: email,
    password: password,
  );

  Future<UserCredential> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final UserCredential credential = await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);
    await credential.user?.updateDisplayName(name);
    return credential;
  }

  Future<void> sendPasswordResetEmail({required String email}) =>
      _firebaseAuth.sendPasswordResetEmail(email: email);

  Stream<User?> authStateChanges() => _firebaseAuth.authStateChanges();
}
