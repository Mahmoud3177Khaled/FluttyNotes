import 'package:firebase_core/firebase_core.dart';
import 'package:firstfluttergo/constants/colors.dart';
import 'package:firstfluttergo/constants/curr_user_name.dart';
import 'package:firstfluttergo/constants/routes.dart';
import 'package:firstfluttergo/services/CRUD/notes_service.dart';
import 'package:firstfluttergo/services/auth/auth_exceptions.dart';
import 'package:firstfluttergo/services/auth/auth_services.dart';
import 'package:firstfluttergo/tools/alert_boxes.dart';
import 'package:flutter/material.dart';
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
  late final TextEditingController _username;

  late final NotesService _notesService;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    _username = TextEditingController();

    _notesService = NotesService();

    _notesService.open();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _username.dispose();

    // _notesService.close();
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


                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
                        child: SizedBox(
                          width: 350,
                          child: TextField(
                            cursorColor: maintheme,
                            controller: _username,
                            enableSuggestions: false,
                            autocorrect: false,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(

                              // hintText: "Enter your username",
                              labelText: "Username",
                              // labelStyle: TextStyle(),
                              floatingLabelStyle: TextStyle(
                                color: maintheme
                              ),

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

                              // hintText: "Enter your E-mail",
                              labelText: "E-mail",
                              // labelStyle: TextStyle(),
                              floatingLabelStyle: TextStyle(
                                color: maintheme
                              ),

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

                              // hintText: "Set a Password",
                              labelText: "Password",
                              // labelStyle: TextStyle(),
                              floatingLabelStyle: TextStyle(
                                color: maintheme
                              ),

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
                              
                                // final userCredential = await FirebaseAuth.instance
                                //     .createUserWithEmailAndPassword(
                                //   email: email,
                                //   password: password,
                                // );
                                try {

                                  if(_username.text == "") {
                                    throw NoUserNameProvided();
                                  }

                                  await AuthService.firebase().signup(email: email, password: password,);
                                  await AuthService.firebase().login(email: email, password: password, );
                                  
                                  devtools.log(_username.text);

                                  userNameInGlobal = _username.text;
                                  await _notesService.createUser(email: email, username: userNameInGlobal);

                                  devtools.log(userNameInGlobal);

                                  if(mounted) {
                                    Navigator.of(context).pushNamedAndRemoveUntil(verify, (route) => false);
                                  }
                                  

                                } on InvalidCredentialAuthException catch (_) {
                                  showAlertBox(
                                    context,
                                    title: "Wrong E-mail or Password",
                                    content: "Please check your credentials and try again...",
                                    opt1: TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(false);
                                      },
                                        child: const Text("Ok")
                                    )
                                    
                                    );
                                  devtools.log("Email or Password are incorrect");
                                                           
                                } on ChannelErrorAuthException catch (_) {
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

                                  devtools.log("Missing password or Email");
                                } on InvalidEmailAuthException catch (_) {
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

                                  devtools.log("Email is invalid");
                                } on UsedEmailAuthException catch (_) {
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
                                } on WeakPasswordAuthException catch(_) {
                                  showAlertBox(
                                    context,
                                    title: "Weak Password",
                                    content: "This password is too weak and must be at least 8 characters in length...",
                                    opt1: TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(false);
                                      },
                                        child: const Text("Ok")
                                    )
    
                                  );
                                } on NoUserNameProvided catch(_) {
                                  showAlertBox(
                                    context,
                                    title: "No username",
                                    content: "Username is a mandatory field, Please fill it before procceding...",
                                    opt1: TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(false);
                                      },
                                        child: const Text("Ok")
                                    )
    
                                  );

                                } catch (_) {
                                  throw GenericAuthException();
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
