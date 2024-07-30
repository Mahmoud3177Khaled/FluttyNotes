import 'package:firebase_auth/firebase_auth.dart';
import 'package:firstfluttergo/constants/colors.dart';
import 'package:firstfluttergo/constants/routes.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;


class VerificationView extends StatelessWidget {
  const VerificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),

      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            const Padding(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: SizedBox(
                width: 300,
                child: Text(
                  "Seems You're not yet verified...",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold
                  ),
                  
                  ),
              ),
            ),

            const Padding(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 30),
              child: SizedBox(
                width: 300,
                child: Text(
                  "We have sent you a verification link on your email... \nPlease click it and login after verification, you will be redirected in 10 seconds",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold

                  ),
                  
                  ),
              ),
            ),

                 
            Builder(
              builder: (context) {

                final user = FirebaseAuth.instance.currentUser;

                Future.delayed(const Duration(seconds: 10), () async {
                  devtools.log('This message is delayed by 10 seconds');
                  Navigator.of(context).pushNamedAndRemoveUntil(welcomeview, (route) => false,);

                  devtools.log(user?.email.toString() ?? "no email");
                  await user?.sendEmailVerification();
                  
                  FirebaseAuth.instance.signOut();
                });


                return const Text("");

              }
                
            )
            

          ],
        ),
      ),
    );
  }
}