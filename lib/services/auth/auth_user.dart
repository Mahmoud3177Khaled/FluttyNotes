import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/material.dart';


@immutable
class AuthUser {

  final bool isEmailVerified;
  final String email;             // <----  we might need to make email null again if we use facebook or google auth 
  final String id;
  // final String username;
  final User? user;

  const AuthUser(
    this.user, 
    {
      required this.id,
      required this.email,
      required this.isEmailVerified,
      // required this.username,
    }
  );
  factory AuthUser.fromFirebase(User user) => AuthUser(id: user.uid, email: user.email!, isEmailVerified: user.emailVerified, user,);
  
}