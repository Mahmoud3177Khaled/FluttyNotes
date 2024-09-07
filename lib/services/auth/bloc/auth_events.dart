// import 'package:firstfluttergo/services/CRUD/cloud/cloud_note.dart';
import 'package:flutter/material.dart';

@immutable
class AuthEvent {
  const AuthEvent();
}

class AuthEventInitialize extends AuthEvent {
  const AuthEventInitialize();
}

class AuthEventLogIn extends AuthEvent {
  final String email;
  final String password;

  const AuthEventLogIn({required this.email, required this.password});
}

class AuthEventSignUp extends AuthEvent {
  final String email;
  final String password;

  const AuthEventSignUp({required this.email, required this.password});
}

class AuthEventLogOut extends AuthEvent {
  const AuthEventLogOut();
}

class AuthEventGoingToLoginPage extends AuthEvent {
  const AuthEventGoingToLoginPage();
}

class AuthEventGoingToSignUpPage extends AuthEvent {
  const AuthEventGoingToSignUpPage();
}

class AuthEventVerify extends AuthEvent {
  const AuthEventVerify();
}

class AuthEventCheckVerified extends AuthEvent {
  const AuthEventCheckVerified();
}



