// import 'package:firstfluttergo/services/auth/auth_exceptions.dart';
// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:firstfluttergo/Globals/global_vars.dart';
import 'package:firstfluttergo/services/CRUD/cloud/firestore_cloud_notes_services.dart';
import 'package:firstfluttergo/services/auth/auth_providers.dart';
import 'package:firstfluttergo/services/auth/bloc/auth_events.dart';
import 'package:firstfluttergo/services/auth/bloc/auth_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer' as devtools show log;

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider provider) : super(const AuthStateLoading()) {

    on<AuthEventInitialize>((event, emit) async {
        await provider.initializeApp();
        final user = provider.currentUser;
        (user == null) ? emit(const AuthStateLoggedOut(null)) : emit(AuthStateLoggedIn(user));

    });
    on<AuthEventLogIn>((event, emit) async {
      // emit(const AuthStateLoading());

      try {
        await provider.login(email: event.email, password: event.password);
        final user = provider.currentUser;

        if(user != null && user.isEmailVerified == false) {
          emit(const AuthStateNeedsVerification());
          return;

        } else if(user != null && user.isEmailVerified == true) {
          emit(AuthStateLoggedIn(user));

        }

      } on Exception catch (e) {
        emit(AuthStateOnloginPage(e)); 
      }
      // emit();
    });
    on<AuthEventLogOut>((event, emit) async {
      // emit(const AuthStateLoading());
      try {
        await provider.logout();
        emit(const AuthStateLoggedOut(null));

      } on Exception catch (e) {
        emit(AuthStateLogOutFailure(e));

      }
    });

    on<AuthEventGoingToSignUpPage>((event, emit) {
      emit(const AuthStateOnSignUpPage(null));
    },);

    on<AuthEventGoingToLoginPage>((event, emit) {
      emit(const AuthStateOnloginPage(null));
    },);

    on<AuthEventSignUp>((event, emit) async {
      // emit(const AuthStateLoading());

      try {
        final newUser = await provider.signup(email: event.email, password: event.password);

        FirestoreCloudNotesServices _cloudNotesService = FirestoreCloudNotesServices();
        await _cloudNotesService.setUserName(userID: newUser.id, username: userNameInGlobal);

        emit(const AuthStateNeedsVerification());

      } on Exception catch(e) {
        emit(AuthStateOnSignUpPage(e));
      }
    },);

    on<AuthEventVerify>((event, emit) async {
      emit(const AuthStateAwaitngVerification());

      provider.sendEmailVerification();
      devtools.log("sent");

      if(provider.currentUser!.isEmailVerified == true) {
        emit(const AuthStateLoggedOut(null));
      }
      await provider.logout();
    },);

    on<AuthEventCheckVerified>((event, emit) async {
      
      await provider.login(email: userEmail, password: userPassword);

      devtools.log(provider.currentUser!.isEmailVerified.toString());

      if(provider.currentUser!.isEmailVerified == true) {
        emit(const AuthStateLoggedOut(null));
        devtools.log("varified");

      } else if(provider.currentUser!.isEmailVerified == false) {
        emit(const AuthStateNeedsVerification());
        devtools.log("not varified");

      }

      await provider.logout();
    },);

  }
}