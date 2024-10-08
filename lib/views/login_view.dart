// ignore_for_file: use_build_context_synchronously

// import 'package:firebase_core/firebase_core.dart';
import 'package:firstfluttergo/constants/colors.dart';
// import 'package:firstfluttergo/constants/routes.dart';
import 'package:firstfluttergo/services/auth/auth_exceptions.dart';
// import 'package:firstfluttergo/services/auth/auth_services.dart';
import 'package:firstfluttergo/services/auth/bloc/auth_bloc.dart';
import 'package:firstfluttergo/services/auth/bloc/auth_events.dart';
import 'package:firstfluttergo/services/auth/bloc/auth_states.dart';
// import 'package:firstfluttergo/services/auth/bloc/auth_states.dart';
import 'package:firstfluttergo/tools/alert_boxes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import '../firebase_options.dart';
import 'dart:developer' as devtools show log;

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  bool _validField1 = true;
  bool _validField2 = true;

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
    // final travellingUserName = ModalRoute.of(context)?.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        title: const Text(""),
        // backgroundColor: const Color.fromARGB(255, 0, 60, 255),
        // foregroundColor: Colors.white,
      ),
      body: Expanded(
          child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(0, 10, 50, 5),
                child: SizedBox(
                  // width: 300,
                  child: Text("Welcome Back!",
                      style:
                          TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
                ),
              ),

              const Padding(
                padding: EdgeInsets.fromLTRB(10, 0, 0, 30),
                child: SizedBox(
                  // width: 300,
                  child: Text("Login to your account:           ",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w900,
                        // foreground: Color.fromARGB(55, 55, 55, 55),y
                      )),
                ),
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                        decoration:  InputDecoration(
                          // hintText: "Enter your E-mail",
                  
                          labelText: "E-mail",
                          labelStyle: TextStyle(
                            color: _validField1 ? const Color.fromARGB(255, 0, 0, 0) : const Color.fromARGB(255, 214, 59, 48)
                          ),
                          floatingLabelStyle: TextStyle(color: _validField1 ? maintheme : const Color.fromARGB(255, 214, 59, 48)),
                  
                          enabledBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: _validField1 ? const Color.fromARGB(255, 0, 0, 0) : const Color.fromARGB(255, 214, 59, 48))),
                  
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: _validField1 ? maintheme : const Color.fromARGB(255, 214, 59, 48))),
                        ),
                  
                        onChanged: (value) {
                          setState(() {
                            value.isEmpty ? _validField1 = false : _validField1 = true;
                            
                          });
                        },
                      ),
                    ),
                  ),

                  Visibility(
                    visible: !_validField1,
                    child: const Padding(
                      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: Text(
                        "Missing E-mail *",
                        style: TextStyle(
                          color: Color.fromARGB(255, 214, 59, 48),
                          fontSize: 10
                        ),
                      ),
                    ),
                  ),

                ],
              ),


              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: SizedBox(
                      width: 350,
                      child: TextField(
                        cursorColor: maintheme,
                        controller: _password,
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration: InputDecoration(
                          // hintText: "Enter your Password",
                  
                          labelText: "Password",
                          labelStyle: TextStyle(
                            color: _validField2 ? const Color.fromARGB(255, 0, 0, 0) : const Color.fromARGB(255, 214, 59, 48)
                          ),
                          floatingLabelStyle: TextStyle(color: _validField2 ? maintheme : const Color.fromARGB(255, 214, 59, 48)),
                  
                          enabledBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: _validField2 ? const Color.fromARGB(255, 0, 0, 0) : const Color.fromARGB(255, 214, 59, 48))),
                  
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: _validField2 ? maintheme : const Color.fromARGB(255, 214, 59, 48))),
                        ),
                  
                        onChanged: (value) {
                          setState(() {
                            value.isEmpty ? _validField2 = false : _validField2 = true;
                            
                          });
                        },
                      ),
                    ),
                  ),

                   Visibility(
                    visible: !_validField2,
                    child: const Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 30),
                      child: Text(
                        "Missing Password *",
                        style: TextStyle(
                          color: Color.fromARGB(255, 214, 59, 48),
                          fontSize: 10
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              TextButton(
                onPressed: () {
                  context.read<AuthBloc>().add(AuthEventForgotPassword(email: _email.text));
                }, 
                child: const Text("Forgot password")
                
              ),

              BlocListener<AuthBloc, AuthState>(
                listener: (context, state) async {
                  if(state is AuthStateOnloginPage) {
                    if(state.exception is InvalidCredentialAuthException) {
                      await showAlertBox(context,
                        title: "Wrong E-mail or Password",
                        content: const Text(
                          "Please check your credentials and try again...",
                          style: TextStyle(color: Colors.white),
                        ),
                        opt1: TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text(
                              "Ok",
                              style: TextStyle(color: maintheme),
                            )));
                      
                      devtools.log("Email or Password are incorrect");

                    } else if(state.exception is ChannelErrorAuthException) {

                      await showAlertBox(context,
                        title: "Email or password missing",
                        content: const Text(
                          "Please enter both your E-mail and password",
                          style: TextStyle(color: Colors.white),
                        ),
                        opt1: TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text(
                              "Ok",
                              style: TextStyle(color: maintheme),
                            )));

                      devtools.log("Missing password or Email");

                    } else if(state.exception is InvalidEmailAuthException) {
                      await showAlertBox(context,
                        title: "Wrong E-mail or Password",
                        content: const Text(
                          "Please check your credentials and try again...",
                          style: TextStyle(color: Colors.white),
                        ),
                        opt1: TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text(
                              "Ok",
                              style: TextStyle(color: maintheme),
                            )));
                      
                      devtools.log("Email or Password are incorrect");

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
                      onPressed: () {
                        final email = _email.text;
                        final password = _password.text;
                       

                          context.read<AuthBloc>().add(
                              AuthEventLogIn(email: email, password: password));

                          
                      },
                      child: const Text(
                        "Login",
                        style: TextStyle(
                            fontSize: 16), // Adjust the font size here
                      ),
                    ),
                  ),
                ),
              ),

              const Padding(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Text(
                  "Or Login With:",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
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
                          child: const Image(
                              image: AssetImage("assets/images/g.png")),
                        )),
                    Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 30, 0),
                        child: TextButton(
                          onPressed: () {
                            return;
                          },
                          child: const Image(
                              image: AssetImage("assets/images/f.png")),
                        )),
                    Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                        child: TextButton(
                          onPressed: () {
                            return;
                          },
                          child: const Image(
                              image: AssetImage("assets/images/apple.png")),
                        )),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: const Color.fromARGB(255, 0, 69, 181),
                    backgroundColor: const Color.fromARGB(255, 255, 250, 255),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                    ),
                  ),
                  onPressed: () {
                    context
                        .read<AuthBloc>()
                        .add(const AuthEventGoingToSignUpPage());
                  },
                  child: const Text("New around here? Register Now!"),
                ),
              ),

              // TextButton(
              //   onPressed: () {
              //   Navigator.of(context).pushNamed('/check');
              // },
              // child: Text("go back to check")
              // ),
            ],
          ),
        ),
      )),
    );
  }
}
