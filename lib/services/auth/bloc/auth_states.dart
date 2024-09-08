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



class AuthStateOnloginPage extends AuthState {
  final Exception? exception;
  const AuthStateOnloginPage(this.exception);

}

class AuthStateLoggedIn extends AuthState {
  final AuthUser user;
  const AuthStateLoggedIn(this.user);

}

// class AuthStateLogInFailure extends AuthState {
//   final Exception exception;
//   const AuthStateLogInFailure(this.exception);

// }



class AuthStateLoggedOut extends AuthState {
  final Exception? exception;
  const AuthStateLoggedOut(this.exception);

}

class AuthStateLogOutFailure extends AuthState {
  final Exception exception;
  const AuthStateLogOutFailure(this.exception);

}



// class AuthStateSignUpFailure extends AuthState {
//   final Exception exception;
//   const AuthStateSignUpFailure(this.exception);

// }

class AuthStateOnSignUpPage extends AuthState {
  final Exception? exception;
  const AuthStateOnSignUpPage(this.exception);

}



class AuthStateNeedsVerification extends AuthState {
  const AuthStateNeedsVerification();

}

class AuthStateAwaitngVerification extends AuthState {
  const AuthStateAwaitngVerification();

}


