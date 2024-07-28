// import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firstfluttergo/firebase_options.dart';
import 'package:firstfluttergo/views/verification_view.dart';
import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'firebase_options.dart';
import 'views/login_view.dart';
import 'views/registration_view.dart';
import 'views/signup_or_login.dart';
import 'views/homepage_view.dart';
// import 'package:google_fonts/google_fonts.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

const maintheme = Color.fromARGB(255, 255, 102, 0);    // (●'◡'●)(〃￣︶￣)人(￣︶￣〃)
var user = FirebaseAuth.instance.currentUser;

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
      home: const Firstcheck(),
      routes: {
        '/login': (context) => const LoginView(),
        '/register': (context) => const RegistrationView(),
        '/verify': (context) => const VerificationView(),
        '/signup_or_login': (context) => const Signup_or_login(),
        '/homepage': (context) => const Homepageview(),
        // '/check': (context) => const Firstcheck(),
      },
    );
  }
}

class Firstcheck extends StatelessWidget {
  const Firstcheck({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Checking user loged in"),
        backgroundColor: Colors.blue,
        foregroundColor: const Color.fromARGB(255, 255, 255, 255)

        ),

        body: FutureBuilder(
          future: Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform
          ),

           builder: (context, snapshot) {
             switch (snapshot.connectionState) {

              case ConnectionState.done:

              
              // user = null;

              // print(user);
              // print(user?.emailVerified);


              WidgetsBinding.instance.addPostFrameCallback((_) {

                // print("xxx");
                  if(user == null)
                  {
                    Navigator.of(context).pushNamed("/signup_or_login");
                  }
                  else if(user?.emailVerified == false)
                  {
                    Navigator.of(context).pushNamed("/verify");
                  }
                  else 
                  {
                    Navigator.of(context).pushNamed("/homepage");
                  }
                },              
              );
              

              

              return const Center(child: CircularProgressIndicator());


              // return const Text(
              //   "Done",
              //   style: TextStyle(
              //     fontSize: 20
              //   ),
                
              // );






            //  Navigator.of(context).pushNamed('/login');

            //  return TextButton(
            //     onPressed: () {
            //     Navigator.of(context).pushNamed('/login');
            //   }, 
            //   child: Text("go back to check")
            //   );



              default:
                return const Text("Loading...");
             }
           },
           ),
    );
  }
}


