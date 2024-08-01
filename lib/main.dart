import 'package:firstfluttergo/constants/routes.dart';
import 'package:firstfluttergo/services/auth/auth_services.dart';
import 'package:firstfluttergo/views/profile_view.dart';
import 'package:firstfluttergo/views/settings_view.dart';
import 'package:firstfluttergo/views/welcome_view.dart';
import 'package:firstfluttergo/views/verification_view.dart';
import 'package:flutter/material.dart';
import 'views/login_view.dart';
import 'views/registration_view.dart';
import 'views/homepage_view.dart';
import 'dart:developer' as devtools show log;
import 'constants/colors.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}


// var user = FirebaseAuth.instance.currentUser;

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
            cursorColor: maintheme,// Blue cursor
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
        settings: (context) => const SettingsView(),
      },
    );
  }
}

class CheckAccountState extends StatelessWidget {
  const CheckAccountState({super.key});

  @override
  Widget build(BuildContext context) {
    

    return Scaffold(
      appBar: AppBar(
        title: const Text("Checking user state"),
        backgroundColor: maintheme,
        foregroundColor: const Color.fromARGB(255, 255, 255, 255)

        ),

        body: FutureBuilder(
          future: AuthService.firebase().initializeApp(),

           builder: (context, snapshot) {
             switch (snapshot.connectionState) {

              case ConnectionState.done:

              final user = AuthService.firebase().currentUser;
              devtools.log(user.toString());

              WidgetsBinding.instance.addPostFrameCallback((_) {

                if(user == null)
                {
                  Navigator.of(context).pushNamedAndRemoveUntil(welcomeview,  (route) => false,);
                }
                else if(user.isEmailVerified == false)
                {
                  Navigator.of(context).pushNamedAndRemoveUntil(verify, (route) => false,);
                }
                else 
                {
                  Navigator.of(context).pushNamedAndRemoveUntil(homepage,  (route) => false,);
                }
              },              
              );

              return const Center(child: Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 200),
                child: CircularProgressIndicator(),
              ));

              default:
                return const Text("Failed to connect to Firebase services");
             }
           },
           ),
    );
  }
}


