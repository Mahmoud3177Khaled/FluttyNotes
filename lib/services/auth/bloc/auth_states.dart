// import 'package:firstfluttergo/services/CRUD/cloud/cloud_note.dart';
import 'package:firstfluttergo/services/auth/auth_user.dart';
import 'package:flutter/material.dart';

@immutable
abstract class AuthState {
  final bool isLoading;
  final String loadingText;
  const AuthState({required this.isLoading, this.loadingText = "Please Wait"});

}



class AuthStateLoading extends AuthState {
  const AuthStateLoading({required bool loading}) : super(isLoading: loading);

}



class AuthStateOnloginPage extends AuthState {
  final Exception? exception;
  const AuthStateOnloginPage({required this.exception,required bool loading}) : super(isLoading: loading);

}

class AuthStateLoggedIn extends AuthState {
  final AuthUser user;
  const AuthStateLoggedIn({required this.user, required bool loading}) : super(isLoading: loading);

}

// class AuthStateLogInFailure extends AuthState {
//   final Exception exception;
//   const AuthStateLogInFailure(this.exception);

// }



class AuthStateLoggedOut extends AuthState {
  final Exception? exception;
  const AuthStateLoggedOut({required this.exception,required bool loading}) : super(isLoading: loading);

}

class AuthStateLogOutFailure extends AuthState {
  final Exception exception;
  const AuthStateLogOutFailure({required this.exception,required bool loading}) : super(isLoading: loading);

}



// class AuthStateSignUpFailure extends AuthState {
//   final Exception exception;
//   const AuthStateSignUpFailure(this.exception);

// }

class AuthStateOnSignUpPage extends AuthState {
  final Exception? exception;
  const AuthStateOnSignUpPage({required this.exception,required bool loading}) : super(isLoading: loading);

}



class AuthStateNeedsVerification extends AuthState {
  const AuthStateNeedsVerification({required bool loading}) : super(isLoading: loading);

}

class AuthStateAwaitngVerification extends AuthState {
  const AuthStateAwaitngVerification({required bool loading}) : super(isLoading: loading);

}

class AuthStateOnForgotPassword extends AuthState {
  // final bool loading;
  const AuthStateOnForgotPassword({required loading}) : super(isLoading: loading);
}

class AuthStateForgotPasswordEmailSent extends AuthState {
  // final bool loading;
  final bool hasSentEmail;
  final Exception? exception;
  const AuthStateForgotPasswordEmailSent({required this.exception, required loading, required this.hasSentEmail}) : super(isLoading: loading);
}

// class AuthStateOnForgotPassword extends AuthState {
//   final bool loading;
//   const AuthStateOnForgotPassword({required this.loading}) : super(isLoading: loading);
// }


