import 'package:firstfluttergo/services/auth/auth_user.dart';

abstract class AuthProvider {
  AuthUser? get currentUser;

  Future<dynamic> initializeApp();

  Future<AuthUser> login({
    required email,
    required password,

  });

  Future<AuthUser> signup({
    required email,
    required password,
  });

  Future<void> logout();

  Future<void> sendEmailVerification();

}