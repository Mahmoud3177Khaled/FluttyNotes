import 'package:firstfluttergo/constants/routes.dart';
import 'package:firstfluttergo/helpers/loading_screen.dart';
import 'package:firstfluttergo/services/auth/auth_exceptions.dart';
// import 'package:firstfluttergo/services/auth/auth_services.dart';
import 'package:firstfluttergo/services/auth/bloc/auth_bloc.dart';
import 'package:firstfluttergo/services/auth/bloc/auth_events.dart';
import 'package:firstfluttergo/services/auth/bloc/auth_states.dart';
import 'package:firstfluttergo/services/auth/firebase_auth_provider.dart';
import 'package:firstfluttergo/tools/alert_boxes.dart';
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
      home: const CheckAccountState(),
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

class CheckAccountState extends StatefulWidget {
  const CheckAccountState({super.key});

  @override
  State<CheckAccountState> createState() => _CheckAccountStateState();
}

class _CheckAccountStateState extends State<CheckAccountState> {
  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialize());

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if(state.isLoading) {
          LoadingScreen().show(context: context, text: state.loadingText);
        } else {
          LoadingScreen().hide();
        }
        

        if(state is AuthStateForgotPasswordEmailSent) {

          if(state.exception == null) {
            showAlertBox(
              context,
              title: "Email sent",
              content: const Text(
                "We sent you a password reset email on your email, please set your new password there",
                style: TextStyle(
                  color: Colors.white
                ),
              ),
              opt1: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                }, 
                child: const Text("Ok")
                
              )
            );
          } else if(state.exception is InvalidEmailAuthException) {
            showAlertBox(
              context,
              title: "Invalid E-mail",
              content: const Text(
                "Please make sure your email is correct",
                style: TextStyle(
                  color: Colors.white
                ),
              ),
              opt1: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                }, 
                child: const Text("Ok")
                
              )
            );
          } else if (state.exception is UserNotLoggedInAuthException) {
            showAlertBox(
              context,
              title: "Invalid E-mail",
              content: const Text(
                "No user with such Email",
                style: TextStyle(
                  color: Colors.white
                ),
              ),
              opt1: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                }, 
                child: const Text("Ok")
                
              )
            );
          } else if (state.exception is ChannelErrorAuthException) {
            showAlertBox(
              context,
              title: "Email missing",
              content: const Text(
                "Please fill in your email to get the reset email",
                style: TextStyle(
                  color: Colors.white
                ),
              ),
              opt1: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                }, 
                child: const Text("Ok")
                
              )
            );
          }
        }
      },
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

        } else if (state is AuthStateOnloginPage || state is AuthStateOnForgotPassword || state is AuthStateForgotPasswordEmailSent) {
          // Navigator.of(context).pushNamedAndRemoveUntil(welcomeview, (route) => false);
          return const LoginView();

        } else if (state is AuthStateNeedsVerification || state is AuthStateAwaitngVerification) {
          // Navigator.of(context).pushNamedAndRemoveUntil(verify, (route) => false);
          return const VerificationView();

        }

        return Scaffold(
          appBar: AppBar(
            title: const Center(child: Text("redirecting")),
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
