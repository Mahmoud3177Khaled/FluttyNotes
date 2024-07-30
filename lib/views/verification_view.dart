import 'package:firebase_auth/firebase_auth.dart';
import 'package:firstfluttergo/constants/colors.dart';
import 'package:firstfluttergo/constants/routes.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;


class VerificationView extends StatefulWidget {
  const VerificationView({super.key});

  @override
  State<VerificationView> createState() => _VerificationViewState();
}

class _VerificationViewState extends State<VerificationView> {
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
                  "Please enter the code emailed to you to verify your email account :)",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold

                  ),
                  
                  ),
              ),
            ),


            const Padding(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: SizedBox(
                width: 300,
                child: TextField(
                  cursorColor: maintheme,
                  enableSuggestions: false,
                  autocorrect: false,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                
                    hintText: "eg. 123-456",
                
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 0, 0, 0)
                      )
                    ),
                
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: maintheme
                      )
                    ),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(10, 40, 10, 130),
              child: SizedBox(
                width: 150,
                height: 55,
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

                    devtools.log(user?.email.toString() ?? "no email");

                    await user?.sendEmailVerification();
                    if(mounted)
                    {
                      Navigator.of(context).pushNamed(welcomeview);

                    }
                  },
                
                  child: const Text(
                    "Verify",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                    ),
                    )
                  ),
              ),
            )

          ],
        ),
      ),
    );
  }
}