import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/material.dart';


@immutable
class AuthUser {

  final bool isEmailVerified;
  final User user;

  const AuthUser(this.isEmailVerified, this.user);
  factory AuthUser.fromFirebase(User user) => AuthUser(user.emailVerified, user);
  
}