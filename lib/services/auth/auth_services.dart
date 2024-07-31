// import 'package:firstfluttergo/services/auth/auth_exceptions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firstfluttergo/services/auth/auth_providers.dart';
import 'package:firstfluttergo/services/auth/auth_user.dart';
import 'package:firstfluttergo/services/auth/firebase_auth_provider.dart';

class AuthService implements AuthProvider {
  final AuthProvider provider;

  const AuthService(this.provider);
  factory AuthService.firebase() => AuthService(FirebaseAuthProvider());

  @override
  AuthUser? get currentUser => provider.currentUser;

  @override
  Future<AuthUser> login({required email, required password, required context}) {
    return provider.login(email: email, password: password, context: context);
    
  }

  @override
  Future<void> logout({required context}) {
    return provider.logout(context: context);
  }

  @override
  Future<void> sendEmailVerification({required context}) {
    return provider.sendEmailVerification(context: context);
  }

  @override
  Future<AuthUser> signup({required email, required password, required context}) {
    return provider.signup(email: email, password: password, context: context);
  }

  @override
  Future<FirebaseApp> initializeApp({required context}) {
    return provider.initializeApp(context: context);
  }

}