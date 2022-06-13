import 'dart:async';

import 'package:le_bon_mot/auth/authenticator.dart';
import 'package:le_bon_mot/auth/exceptions.dart';
import 'package:le_bon_mot/model/user.dart';

var jonDoe = InMemUser(
    id: "abc",
    email: "jon@doe.org",
    password: "123456",
    token: "xyz",
);

class InMemUser {
  String id;
  String email;
  String password;
  String token;

  InMemUser({
    required this.id,
    required this.email,
    required this.password,
    required this.token,
  });
}

class InMemAuthenticator implements Authenticator {
  List<InMemUser> users = [jonDoe];
  InMemUser? authenticatedUser;

  final StreamController<AuthStatus> authStateController = StreamController<AuthStatus>.broadcast();

  InMemAuthenticator({this.authenticatedUser});

  @override
  Stream<AuthStatus> get authStateChanges {
    authStateController.add(AuthStatus.initializing);
    Future.delayed(const Duration(seconds: 1), () {
      if (authenticatedUser != null) {
        return authStateController.add(AuthStatus.connected);

      }
      return authStateController.add(AuthStatus.disconnected);
    });
    return authStateController.stream;
  }

  @override
  Future<String?> authenticatedUserToken() async {
    return authenticatedUser?.token;
  }

  @override
  Future<void> signInWithEmailAndPassword({required String email, required String password}) async {
    final user = users.firstWhere((user) => user.email == email && user.password == password,
      orElse: () => throw userNotFoundWithEmailAndPassword,
    );
    authenticatedUser = user;
    authStateController.add(AuthStatus.connected);
  }

  @override
  Future<void> signUpWithEmailAndPassword({required String email, required String password}) async {
    throw "UNIMPLEMENTED";
  }
}