import 'package:firstfluttergo/constants/routes.dart';
// import 'package:firstfluttergo/services/auth/auth_services.dart';
import 'package:firstfluttergo/services/auth/bloc/auth_bloc.dart';
import 'package:firstfluttergo/services/auth/bloc/auth_events.dart';
import 'package:firstfluttergo/services/auth/bloc/auth_states.dart';
import 'package:firstfluttergo/services/auth/firebase_auth_provider.dart';
import 'package:firstfluttergo/views/profile_view.dart';
import 'package:firstfluttergo/views/search_view.dart';
import 'package:firstfluttergo/views/update_note_view.dart';
import 'package:firstfluttergo/views/welcome_view.dart';
import 'package:firstfluttergo/views/verification_view.dart';
import 'package:firstfluttergo/views/new_note_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'views/login_view.dart';
import 'views/registration_view.dart';
import 'views/homepage_view.dart';
// import 'dart:developer' as devtools show log;
import 'constants/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(BlocProvider(
    create: (context) => AuthBloc(FirebaseAuthProvider()),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          // primarySwatch: Color.fromARGB(255, 0, 60, 255),
          // inputDecorationTheme: const InputDecorationTheme(
          //   focusedBorder: OutlineInputBorder(
          //     borderSide: BorderSide(
          //         color: maintheme), // Blue border when focused
          //   ),
          //   enabledBorder: OutlineInputBorder(
          //     borderSide: BorderSide(
          //         color:
          //             Color.fromARGB(255, 0, 0, 0)), // Blue border when enabled
          //   ),
          //   hintStyle: TextStyle(
          //       color: Color.fromARGB(255, 0, 33, 140)), // Blue hint text
          //   labelStyle: TextStyle(
          //       color: Color.fromARGB(255, 0, 60, 255)), // Blue label text
          //),
          textSelectionTheme: const TextSelectionThemeData(
            cursorColor: maintheme, // Blue cursor
            selectionColor:
                Color.fromARGB(99, 0, 104, 189), // Blue selection color
            selectionHandleColor: maintheme,
          ),
          textTheme: const TextTheme()),
      home: CheckAccountState(),
      routes: {
        login: (context) => const LoginView(),
        register: (context) => const RegistrationView(),
        verify: (context) => const VerificationView(),
        welcomeview: (context) => const WelcomeView(),
        homepage: (context) => const Homepageview(),
        check: (context) => const CheckAccountState(),
        profile: (context) => const ProfileView(),
        // settings: (context) => const SettingsView(),
        newNote: (context) => const NewNoteView(),
        updateNote: (context) => const UpdateNoteView(),
        search: (context) => const SearchView(),
      },
    );
  }
}

class CheckAccountState extends StatelessWidget {
  const CheckAccountState({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialize());

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthStateLoggedIn /*|| state is AuthStateLoggedInAndBackToHomePage*/) {
          // Navigator.of(context).pushNamedAndRemoveUntil(homepage, (route) => false);
          return const Homepageview();

        } else if (state is AuthStateLoggedOut) {
          // Navigator.of(context).pushNamedAndRemoveUntil(welcomeview, (route) => false);
          return const WelcomeView();

        } else if (state is AuthStateOnSignUpPage) {
          // Navigator.of(context).pushNamedAndRemoveUntil(welcomeview, (route) => false);
          return const RegistrationView();

        } else if (state is AuthStateOnloginPage) {
          // Navigator.of(context).pushNamedAndRemoveUntil(welcomeview, (route) => false);
          return const LoginView();

        } else if (state is AuthStateNeedsVerification || state is AuthStateAwaitngVerification) {
          // Navigator.of(context).pushNamedAndRemoveUntil(verify, (route) => false);
          return const VerificationView();

        }

        return Scaffold(
          appBar: AppBar(
            title: const Text("redirecting"),
          ),
          body: const Center(
              child: Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 200),
            child: CircularProgressIndicator(),
          )),
        );
      },
    );
  }
}
