import 'package:firebase_core/firebase_core.dart';
import 'package:firstfluttergo/constants/colors.dart';
import 'package:firstfluttergo/constants/routes.dart';
import 'package:firstfluttergo/tools/alert_boxes.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../firebase_options.dart';
import 'dart:developer' as devtools show log;



class RegistrationView extends StatefulWidget {
  const RegistrationView({super.key});

  @override
  State<RegistrationView> createState() => _RegistrationViewState();
}

class _RegistrationViewState extends State<RegistrationView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(""),
        // backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        foregroundColor: const Color.fromARGB(255, 0, 0, 0),
      ),
      body: FutureBuilder(
          future: Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform,
          ),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                return Center(

                  child: Column(
                    mainAxisSize: MainAxisSize.min,

                    children: [


                      const Padding(
                        padding: EdgeInsets.fromLTRB(0, 10, 160, 5),
                        child: SizedBox(
                          // width: 300,
                          child: Text(
                            "Welcome!",
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold
                            )
                          ),
                          
                        ),
                      ),


                      const Padding(
                        padding: EdgeInsets.fromLTRB(10, 0, 0, 35),
                        child: SizedBox(
                          // width: 300,
                          child: Text(
                            "Create a new account:            ",
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w900
                            )
                          ),
                          
                        ),
                      ),


                      const Padding(
                        padding: EdgeInsets.fromLTRB(0, 5, 0, 10),
                        child: SizedBox(
                          width: 350,
                          child: TextField(
                            cursorColor: maintheme,
                            // controller: username,
                            enableSuggestions: false,
                            autocorrect: false,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(

                              hintText: "Enter your username",

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
                        padding: const EdgeInsets.all(10.0),
                        child: SizedBox(
                          width: 350,
                          child: TextField(
                            cursorColor: maintheme,
                            controller: _email,
                            enableSuggestions: false,
                            autocorrect: false,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(

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



                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 30),
                        child: SizedBox(
                          width: 350,
                          child: TextField(
                            cursorColor: maintheme,
                            controller: _password,
                            obscureText: true,
                            enableSuggestions: false,
                            autocorrect: false,
                            decoration: const InputDecoration(

                              hintText: "Set a Password",

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
                        padding: const EdgeInsets.fromLTRB(0, 25, 0, 15),
                        child: SizedBox(
                          width: 190,
                          height: 60,

                          child: TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: maintheme,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(7),
                              ),
                            ),

                            onPressed: () async {
                              final email = _email.text;
                              final password = _password.text;
                              try {
                                final userCredential = await FirebaseAuth.instance
                                    .createUserWithEmailAndPassword(
                                  email: email,
                                  password: password,
                                );
                                devtools.log(userCredential.toString());

                              if(mounted) {
                                Navigator.of(context).pushNamed(verify);
                              }

                              } on FirebaseAuthException catch (e) {
                                devtools.log(e.code);
                        
                                if (e.code == "email-already-in-use") {

                                  showAlertBox(
                                    context,
                                    title: "Email already in use",
                                    content: "You enetered an already registerd email... \n\nPlease try again with a different one...",
                                    opt1: TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(false);
                                      },
                                       child: const Text("Ok")
                                    )
                                    
                                    );

                                  devtools.log("Sorry, Email already in use");

                                } else if (e.code == "channel-error") {

                                  showAlertBox(
                                    context,
                                    title: "Email or password missing",
                                    content: "Please enter both your E-mail and password",
                                    opt1: TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(false);
                                      },
                                       child: const Text("Ok")
                                    )
                                    
                                    );

                                  devtools.log(e.code);
                                  devtools.log("Missing password or Email");

                                } else if (e.code == "weak-password") {

                                  showAlertBox(
                                    context,
                                    title: "This password is too short",
                                    content: "Please enter a longer one at least 8 characters...",
                                    opt1: TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(false);
                                      },
                                       child: const Text("Ok")
                                    )
                                    
                                    );

                                  devtools.log("Password too short");
                                } else if (e.code == "invalid-email") {

                                  showAlertBox(
                                    context,
                                    title: "Invalid E-mail",
                                    content: "Please check you entered your email correctly and without a space at the end",
                                    opt1: TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(false);
                                      },
                                       child: const Text("Ok")
                                    )
                                    
                                    );

                                  devtools.log(e.code);
                                  devtools.log("Email is invalid");

                                }
                              } catch (e) {

                                showAlertBox(
                                    context,
                                    title: "Procces can not be done right now",
                                    content: "${e.toString()}... Please try again later...",
                                    opt1: TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(false);
                                      },
                                       child: const Text("Ok")
                                    )
                                    
                                    );


                                devtools.log("Some error happened...");
                              }

                            },

                            child: const Text(
                              "Create account",
                              style: TextStyle(
                                  fontSize: 16), // Adjust the font size here
                            ),
                          ),
                        ),
                      ),




                      const Padding(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: Text(
                          "Or Login With:",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold
                          ),
                          ),
                      ),


                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 20),
                        child: Row(
                          children: [
                        
                            Padding(
                              padding: const EdgeInsets.fromLTRB(75, 0, 30, 0),
                              child: TextButton(
                                onPressed: () {
                                  return;
                                },
                                 child: const Image(image: AssetImage("assets/images/g.png")),
                                 )
                            ),
                        
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 30, 0),
                              child: TextButton(
                                onPressed: () {
                                  return;
                                },
                                 child: const Image(image: AssetImage("assets/images/f.png")),
                                 )
                            ),
                        
                        
                        
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                              child: TextButton(
                                onPressed: () {
                                  return;
                                },
                                 child: const Image(image: AssetImage("assets/images/apple.png")),
                                 )
                            ),
                        
                        
                          ],
                        ),
                      ),


                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: const Color.fromARGB(255, 0, 69, 181),
                            backgroundColor: const Color.fromARGB(255, 253, 248, 253),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7),
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pushNamed('/login');
                          },
                          child: const Text("Already have an account? Log in"),
                        ),
                      ),



                    ],
                  ),
                );
              default:
                return const Text("Loading...");
            }
          }),
    );
  }
}
