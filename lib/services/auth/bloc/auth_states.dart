// import 'package:firstfluttergo/services/CRUD/cloud/cloud_note.dart';
import 'package:firstfluttergo/services/auth/auth_user.dart';
import 'package:flutter/material.dart';

@immutable
abstract class AuthState {
  const AuthState();
}

class AuthStateLoading extends AuthState {
  const AuthStateLoading();
}

class AuthStateLoggedIn extends AuthState {
  final AuthUser user;
  const AuthStateLoggedIn(this.user);
}

class AuthStateLoggedOut extends AuthState {
  const AuthStateLoggedOut();
}


class AuthStateNeedsVerification extends AuthState {
  const AuthStateNeedsVerification();
}

class AuthStateLogInFailure extends AuthState {
  final Exception exception;
  const AuthStateLogInFailure(this.exception);
}

class AuthStateLogOutFailure extends AuthState {
  final Exception exception;
  const AuthStateLogOutFailure(this.exception);
}

class AuthStateSignUpFailure extends AuthState {
  final Exception exception;
  const AuthStateSignUpFailure(this.exception);
}

class AuthStateOnloginPage extends AuthState {
  const AuthStateOnloginPage();
}

class AuthStateOnSignUpPage extends AuthState {
  const AuthStateOnSignUpPage();
}

class AuthStateAwaitngVerification extends AuthState {
  const AuthStateAwaitngVerification();
}


