enum AuthStatus {
  initializing,
  connected,
  disconnected,
}

abstract class Authenticator {
  Stream<AuthStatus> get authStateChanges;
  Future<String?> authenticatedUserToken();
  Future<void> signInWithEmailAndPassword({required String email, required String password});
  Future<void> signUpWithEmailAndPassword({required String email, required String password});
}