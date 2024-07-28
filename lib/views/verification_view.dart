import 'package:flutter/material.dart';
import '../main.dart';

class VerificationView extends StatefulWidget {
  const VerificationView({super.key});

  @override
  State<VerificationView> createState() => _VerificationViewState();
}

class _VerificationViewState extends State<VerificationView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verify your email:"),
      ),

      body: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: SizedBox(
                width: 250,
                child: TextField(
                  cursorColor: maintheme,
                  enableSuggestions: false,
                  autocorrect: false,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                
                    hintText: "Enter your E-mail",
                
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

          ],
        ),
      ),
    );
  }
}