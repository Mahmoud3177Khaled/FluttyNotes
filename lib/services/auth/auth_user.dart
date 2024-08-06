import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/material.dart';


@immutable
class AuthUser {

  final bool isEmailVerified;
  final String? email;
  final User? user;

  const AuthUser(
    this.user, 
    {
      required this.email,
      required this.isEmailVerified,
    }
  );
  factory AuthUser.fromFirebase(User user) => AuthUser(email: user.email,isEmailVerified: user.emailVerified, user);
  
}