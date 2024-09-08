// ignore_for_file: use_build_context_synchronously

// import 'package:firebase_core/firebase_core.dart';
import 'package:firstfluttergo/constants/colors.dart';
import 'package:firstfluttergo/Globals/global_vars.dart';
// import 'package:firstfluttergo/constants/routes.dart';
// import 'package:firstfluttergo/services/CRUD/cloud/firestore_cloud_notes_services.dart';
// import 'package:firstfluttergo/services/CRUD/notes_service.dart';
import 'package:firstfluttergo/services/auth/auth_exceptions.dart';
// import 'package:firstfluttergo/services/auth/auth_services.dart';
import 'package:firstfluttergo/services/auth/bloc/auth_bloc.dart';
import 'package:firstfluttergo/services/auth/bloc/auth_events.dart';
import 'package:firstfluttergo/services/auth/bloc/auth_states.dart';
import 'package:firstfluttergo/tools/alert_boxes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import '../firebase_options.dart';
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

  // late final FirestoreCloudNotesServices _cloudNotesService;
  // late final String userID;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    _username = TextEditingController();

    // _cloudNotesService = FirestoreCloudNotesServices();

    // userID = AuthService.firebase().

    // _notesService.open();
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
      body: Expanded(
        child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Padding(
                            padding: EdgeInsets.fromLTRB(0, 10, 160, 5),
                            child: SizedBox(
                              // width: 300,
                              child: Text("Welcome!",
                                  style: TextStyle(
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.fromLTRB(10, 0, 0, 35),
                            child: SizedBox(
                              // width: 300,
                              child: Text("Create a new account:            ",
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w900)),
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
                                  floatingLabelStyle:
                                      TextStyle(color: maintheme),

                                  enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color.fromARGB(255, 0, 0, 0))),

                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: maintheme)),
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
                                  floatingLabelStyle:
                                      TextStyle(color: maintheme),

                                  enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color.fromARGB(255, 0, 0, 0))),

                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: maintheme)),
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
                                  floatingLabelStyle:
                                      TextStyle(color: maintheme),

                                  enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color.fromARGB(255, 0, 0, 0))),

                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: maintheme)),
                                ),
                              ),
                            ),
                          ),
                          BlocListener<AuthBloc, AuthState>(
                            listener: (context, state) async {
                              if(state is AuthStateOnSignUpPage) {
                                if(state.exception is InvalidCredentialAuthException) {
                                  await showAlertBox(context,
                                          title: "Wrong E-mail or Password",
                                          content: const Text(
                                            "Please check your credentials and try again...",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          opt1: TextButton(
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pop();
                                              },
                                              child: const Text(
                                                "Ok",
                                                style:
                                                    TextStyle(color: maintheme),
                                              )));devtools.log("Email or Password are incorrect");
                                
                                } else if(state.exception is ChannelErrorAuthException) {
                                  await showAlertBox(context,
                                          title: "Email or password missing",
                                          content: const Text(
                                            "Please enter both your E-mail and password",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          opt1: TextButton(
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pop();
                                              },
                                              child: const Text(
                                                "Ok",
                                                style:
                                                    TextStyle(color: maintheme),
                                              )));devtools.log("Missing password or Email");
                                
                                } else if(state.exception is InvalidEmailAuthException) {
                                  await showAlertBox(context,
                                          title: "Invalid E-mail",
                                          content: const Text(
                                            "Please check you entered your email correctly and without a space at the end",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          opt1: TextButton(
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pop();
                                              },
                                              child: const Text(
                                                "Ok",
                                                style:
                                                    TextStyle(color: maintheme),
                                              )));devtools.log("Email is invalid");
                                
                                } else if(state.exception is UsedEmailAuthException) {
                                  await showAlertBox(context,
                                          title: "Email already in use",
                                          content: const Text(
                                            "You enetered an already registerd email... \n\nPlease try again with a different one...",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          opt1: TextButton(
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pop();
                                              },
                                              child: const Text(
                                                "Ok",
                                                style:
                                                    TextStyle(color: maintheme),
                                              )));
                                
                                } else if(state.exception is WeakPasswordAuthException) {
                                  await showAlertBox(context,
                                          title: "Weak Password",
                                          content: const Text(
                                            "This password is too weak and must be at least 8 characters in length...",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          opt1: TextButton(
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pop();
                                              },
                                              child: const Text(
                                                "Ok",
                                                style:
                                                    TextStyle(color: maintheme),
                                              )));
                                
                                } else if(state.exception is NoUserNameProvided) {
                                  await showAlertBox(context,
                                          title: "No username",
                                          content: const Text(
                                            "Username is a mandatory field, Please fill it before procceding...",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          opt1: TextButton(
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pop();
                                              },
                                              child: const Text(
                                                "Ok",
                                                style:
                                                    TextStyle(color: maintheme),
                                              )));
                                
                                }
                              }
                            },
                            child: Padding(
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
                                  onPressed: ()  {
                                    final email = _email.text;
                                    final password = _password.text;

                                    devtools.log(_username.text);

                                    userNameInGlobal = _username.text;
                                    userEmail = email;
                                    userPassword = password;

                                    devtools.log(userNameInGlobal);

                                      context.read<AuthBloc>().add(
                                        AuthEventSignUp(
                                          email: email,
                                          password: password
                                        )
                                      );

                                    
                                  },
                                  child: const Text(
                                    "Create account",
                                    style: TextStyle(
                                        fontSize:
                                            16), // Adjust the font size here
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                            child: Text(
                              "Or Login With:",
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 20),
                            child: Row(
                              children: [
                                Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(75, 0, 30, 0),
                                    child: TextButton(
                                      onPressed: () {
                                        return;
                                      },
                                      child: const Image(
                                          image: AssetImage(
                                              "assets/images/g.png")),
                                    )),
                                Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 30, 0),
                                    child: TextButton(
                                      onPressed: () {
                                        return;
                                      },
                                      child: const Image(
                                          image: AssetImage(
                                              "assets/images/f.png")),
                                    )),
                                Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 20, 0),
                                    child: TextButton(
                                      onPressed: () {
                                        return;
                                      },
                                      child: const Image(
                                          image: AssetImage(
                                              "assets/images/apple.png")),
                                    )),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextButton(
                              style: TextButton.styleFrom(
                                foregroundColor:
                                    const Color.fromARGB(255, 0, 69, 181),
                                backgroundColor:
                                    const Color.fromARGB(255, 253, 248, 253),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(7),
                                ),
                              ),
                              onPressed: () {
                                context
                                    .read<AuthBloc>()
                                    .add(const AuthEventGoingToLoginPage());
                              },
                              child:
                                  const Text("Already have an account? Log in"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                
      ),
    );
  }
}
