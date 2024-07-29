import 'package:firebase_auth/firebase_auth.dart';
import 'package:firstfluttergo/main.dart';
import 'package:flutter/material.dart';

class Homepageview extends StatelessWidget {
  const Homepageview({super.key});

  @override
  Widget build(BuildContext context) {

    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Homepage"),
        backgroundColor: maintheme,
        foregroundColor: Colors.white,

      ),

      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Center(
          child: Column(
            children: 
            [
        
              
        
              Text(
                "Email: ${user?.email ?? "user is null"}",
                style: const TextStyle(
                  fontSize: 15,
                  fontFamily: 'Montserrat',
                  decorationColor: maintheme,
                  fontWeight: FontWeight.w900
                ),
                ),
        
                Text(
                "Verified: ${user?.emailVerified.toString() ?? "user is null"}",
                style: const TextStyle(
                  fontSize: 14,
                  fontFamily: 'Montserrat',
                  decorationColor: maintheme,
                  fontWeight: FontWeight.w900 
                ),
                ),
        
                TextButton(onPressed: () {
                  Navigator.of(context).pushNamed("/WelcomeView");
                },
                 child: const Text("sign in with anohter account")
        
                 )
        
        
            ],
          ),
        ),
      ),
    );
  }
}