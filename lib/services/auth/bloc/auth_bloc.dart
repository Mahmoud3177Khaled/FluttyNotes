// import 'package:firstfluttergo/services/auth/auth_exceptions.dart';
// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:firstfluttergo/Globals/global_vars.dart';
import 'package:firstfluttergo/services/CRUD/cloud/firestore_cloud_notes_services.dart';
import 'package:firstfluttergo/services/auth/auth_exceptions.dart';
import 'package:firstfluttergo/services/auth/auth_providers.dart';
import 'package:firstfluttergo/services/auth/bloc/auth_events.dart';
import 'package:firstfluttergo/services/auth/bloc/auth_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer' as devtools show log;

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider provider) : super(const AuthStateLoading(loading: true)) {

    on<AuthEventInitialize>((event, emit) async {
        await provider.initializeApp();
        final user = provider.currentUser;
        (user == null) ? emit(const AuthStateLoggedOut( exception: null, loading: false)) : emit(AuthStateLoggedIn(user: user, loading: false));

    });
    on<AuthEventLogIn>((event, emit) async {
      emit(const AuthStateOnloginPage(exception: null, loading: true));

      try {
        await provider.login(email: event.email, password: event.password);
        final user = provider.currentUser;

        if(user != null && user.isEmailVerified == false) {
          emit(const AuthStateNeedsVerification(loading: false));
          return;

        } else if(user != null && user.isEmailVerified == true) {
          emit(AuthStateLoggedIn(user: user, loading: false));

        }

      } on Exception catch (e) {
        emit(AuthStateOnloginPage(loading: false, exception: e)); 
      }
      // emit();
    });
    on<AuthEventLogOut>((event, emit) async {
      
      emit(const AuthStateLoggedOut(loading: true, exception: null));

      try {
        await provider.logout();
        emit(const AuthStateLoggedOut(exception: null, loading: false));

      } on Exception catch (e) {
        emit(AuthStateLogOutFailure(exception: e, loading: false));

      }
    });

    on<AuthEventGoingToSignUpPage>((event, emit) {
      emit(const AuthStateOnSignUpPage(loading: false, exception: null));
    },);

    on<AuthEventGoingToLoginPage>((event, emit) {
      emit(const AuthStateOnloginPage(loading: false, exception: null));
    },);

    on<AuthEventSignUp>((event, emit) async {
      emit(const AuthStateOnSignUpPage(exception: null, loading: true));

      try {
        final newUser = await provider.signup(email: event.email, password: event.password);

        FirestoreCloudNotesServices _cloudNotesService = FirestoreCloudNotesServices();
        await _cloudNotesService.setUserName(userID: newUser.id, username: userNameInGlobal);

        emit(const AuthStateNeedsVerification(loading: false));

      } on Exception catch(e) {
        emit(AuthStateOnSignUpPage(loading: false, exception: e));
      }
    },);

    on<AuthEventVerify>((event, emit) async {
      emit(const AuthStateAwaitngVerification(loading: false));

      await provider.sendEmailVerification();
      devtools.log("sent");

      if(provider.currentUser!.isEmailVerified == true) {
        emit(const AuthStateLoggedOut(exception: null, loading: false));
      }
      await provider.logout();
    },);

    on<AuthEventCheckVerified>((event, emit) async {
      
      await provider.login(email: userEmail, password: userPassword);

      devtools.log(provider.currentUser!.isEmailVerified.toString());

      if(provider.currentUser!.isEmailVerified == true) {
        emit(const AuthStateLoggedOut(exception: null, loading: false));
        devtools.log("varified");

      } else if(provider.currentUser!.isEmailVerified == false) {
        emit(const AuthStateNeedsVerification(loading: false));
        devtools.log("not varified");

      }

      await provider.logout();
    },);

    on<AuthEventForgotPassword>((event, emit) async {
      emit(const AuthStateOnForgotPassword(loading: true));

      try {
        await provider.sendPasswordReset(email: event.email);
        devtools.log("reset sent");

        emit(const AuthStateForgotPasswordEmailSent(exception: null, loading: false, hasSentEmail: true));

      } on Exception catch (e) {
        emit(AuthStateForgotPasswordEmailSent(exception: e, loading: false, hasSentEmail: false));

      
      }
    });

  }
}