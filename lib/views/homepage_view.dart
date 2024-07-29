// import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firstfluttergo/main.dart';
import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import '../firebase_options.dart';
// import 'login_view.dart';
// import 'registration_view.dart';
// import 'package:google_fonts/google_fonts.dart';
// import '../main.dart';

class Homepageview extends StatelessWidget {
  const Homepageview({super.key});

  @override
  Widget build(BuildContext context) {

    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Homepage"),
      ),

      body: Center(
        child: Column(
          children: 
          [

            

            Text(
              user?.email ?? "user is null",
              style: const TextStyle(
                fontSize: 30,
                fontFamily: 'Montserrat',
                decorationColor: maintheme
              ),
              ),

              Text(
              user?.emailVerified.toString() ?? "user is null",
              style: const TextStyle(
                fontSize: 30,
                fontFamily: 'Montserrat',
                decorationColor: maintheme
              ),
              ),

              TextButton(onPressed: () {
                Navigator.of(context).pushNamed("/signup_or_login");
              },
               child: const Text("sign in with anohter account")

               )


          ],
        ),
      ),
    );
  }
}