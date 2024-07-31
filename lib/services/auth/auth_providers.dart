import 'package:firebase_core/firebase_core.dart';
import 'package:firstfluttergo/services/auth/auth_user.dart';

abstract class AuthProvider {
  AuthUser? get currentUser;

  Future<FirebaseApp> initializeApp({required context});

  Future<AuthUser> login({
    required email,
    required password,
    required context,

  });

  Future<AuthUser> signup({
    required email,
    required password,
    required context,
  });

  Future<void> logout({required context,});

  Future<void> sendEmailVerification({required context,});

}