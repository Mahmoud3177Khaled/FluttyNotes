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
                  "We have sent you a verification link on your email... \nPlease click it and login after verification.",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold

                  ),
                  
                  ),
              ),
            ),


               Row(
                 children: [

                    Padding(
                      padding: const EdgeInsets.fromLTRB(40, 0, 0, 0),
                      child: SizedBox(
                        // width: , 
                        height: 40,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: maintheme,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7),
                            ),
                          ),
                        
                          onPressed: () async {

                            final user = FirebaseAuth.instance.currentUser;
                            await user?.sendEmailVerification();

                            devtools.log(user.toString());
                            devtools.log("sent");

                          },
                        
                          child: const Text(
                            "resend E-mail",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold
                            ),
                          )
                              
                      ),
                    ),
                  ),

                   Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: SizedBox(
                      // width: , 
                      height: 40,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: maintheme,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7),
                          ),
                        ),
                      
                        onPressed: () {
                          FirebaseAuth.instance.signOut();
                          Navigator.of(context).pushNamed(welcomeview);

                        },
                      
                        child: const Text(
                          "I clicked the link... Go on",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold
                          ),
                        )      
                      ),
                    ),
                  ),
                ],
              ),
  
            Builder(
              builder: (context) {

                WidgetsBinding.instance.addPostFrameCallback((_) async {

                  final user = FirebaseAuth.instance.currentUser;
                  await user?.sendEmailVerification();

                  devtools.log("sent");


                  }
                );

                return const Text("");

              }
                
            )
          ],
        ),
      ),
    );
  }
}