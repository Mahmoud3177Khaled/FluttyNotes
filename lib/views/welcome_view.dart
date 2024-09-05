// import 'package:firebase_core/firebase_core.dart';
import 'package:firstfluttergo/constants/colors.dart';
import 'package:firstfluttergo/constants/routes.dart';
import 'package:firstfluttergo/services/auth/bloc/auth_bloc.dart';
import 'package:firstfluttergo/services/auth/bloc/auth_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import '../firebase_options.dart';



class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {

    // final travellingUserName = ModalRoute.of(context)?.settings.arguments;

    return Scaffold(

        appBar: AppBar(
          title: const Text("Welcome!"),
          backgroundColor: const Color.fromARGB(255, 255, 251, 255),
          foregroundColor: const Color.fromARGB(255, 0, 0, 0),
        ),


        backgroundColor: const Color.fromARGB(255, 255, 251, 255),


        body: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if(state is AuthStateLoggedOut) {
              return Center(
                child: 
                
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,

                    children: [


                      const Padding(
                        padding: EdgeInsets.fromLTRB(0, 30, 0, 20),
                        child: Image(image: AssetImage("assets/images/d.png")),


                      ),


                      const Text(
                          "Hi!                 ",
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold
                          )
                      ),
                        


                      const SizedBox(
                        width: 250,
                        child: Text(
                          "Welcome to your all-in-one notes app. Manage and Upload all your notes from one place!",
                          style: TextStyle(
                            // fontFamily: 'Montserrat',
                            fontSize: 15,
                            fontWeight: FontWeight.w700
                          ),
                        ),
                        
                      ),
                      

                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 30, 0, 20),
                        child: SizedBox(
                          width: 170,
                          height: 60,
                          child: TextButton(
                            style: TextButton.styleFrom(
                                backgroundColor: maintheme,
                                foregroundColor: const Color.fromARGB(255, 255, 251, 255),
                                shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(7),
                            ),
                            ),
                            
                            onPressed: () {
                              Navigator.of(context).pushNamed(register);
                            },
                        
                            child: const Text(
                                  "Sign Up",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700
                                  ),
                            ),
                        
                            ),
                        ),
                      ),


                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 100),
                        child: SizedBox(
                          width: 170,
                          height: 60,
                          child: OutlinedButton(
                            style: TextButton.styleFrom(
                                foregroundColor: maintheme,
                                backgroundColor: const Color.fromARGB(255, 255, 251, 255),
                                shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(7),
                            ),

                            side: const BorderSide(
                                color: maintheme,
                                width: 3
                          ), 
                            ),
                            
                            onPressed: () {
                              Navigator.of(context).pushNamed(login);
                            },
                        
                            child: const Text(
                                  "Log In",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700
                                  ),
                            ),
                        
                          ),

                        ),

                      )

                    ],

                  ),

                ),

              );
            }
            else if(state is AuthStateLoggedIn) {
             Navigator.of(context).pushNamedAndRemoveUntil(homepage, (route) => false); 
            }

            return const Center(
                  child: Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 200),
                child: CircularProgressIndicator(),
              ));
          },
        )
                

        );
  }
  
}