// import 'package:firstfluttergo/services/auth/auth_exceptions.dart';
import 'package:firstfluttergo/services/auth/auth_providers.dart';
import 'package:firstfluttergo/services/auth/bloc/auth_events.dart';
import 'package:firstfluttergo/services/auth/bloc/auth_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider provider) : super(const AuthStateLoading()) {

    on<AuthEventInitialize>((event, emit) async {
        await provider.initializeApp();
        final user = provider.currentUser;
        (user == null) ? emit(const AuthStateLoggedOut()) : emit(AuthStateLoggedIn(user));

    });
    on<AuthEventLogIn>((event, emit) async {
      emit(const AuthStateLoading());

      try {
        await provider.login(email: event.email, password: event.password);
        final user = provider.currentUser;
        if(user != null) {
          emit(AuthStateLoggedIn(user));
        }

      } on Exception catch (e) {
        emit(AuthStateLogInFailure(e)); 
      }
      // emit();
    });
    on<AuthEventLogOut>((event, emit) async {
      emit(const AuthStateLoading());
      try {
        await provider.logout();
        emit(const AuthStateLoggedOut());

      } on Exception catch (e) {
        emit(AuthStateLogOutFailure(e));

      }
    });

  }
}