// import 'package:firebase_auth/firebase_auth.dart';
import 'package:firstfluttergo/constants/Enumerations.dart';
import 'package:firstfluttergo/constants/colors.dart';
import 'package:firstfluttergo/constants/routes.dart';
import 'package:firstfluttergo/services/auth/auth_services.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;


Future<bool> showLogoutAlert(BuildContext context)
{
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Alert!"),
        content: const Text("Are you sure you want to logout?"),
        actions: [

          TextButton(onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: const Text("Cancel")),

          TextButton(onPressed: () async {
            await AuthService.firebase().logout();
            Navigator.of(context).pushNamedAndRemoveUntil(welcomeview, (route) => false);
          },
          child: const Text("Confirm")),

        ],
      );
    },
  ).then((value) => value ?? false);
}


class Homepageview extends StatelessWidget {
  const Homepageview({super.key});

  @override
  Widget build(BuildContext context) {

    final user = AuthService.firebase().currentUser?.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Homepage"),
        backgroundColor: maintheme,
        foregroundColor: Colors.white,

        actions: [

          PopupMenuButton<AppBarMenuActions>(

            onSelected: (value) async {

              devtools.log("This is $value");

              switch (value) {
                case AppBarMenuActions.profile:
                  Navigator.of(context).pushNamed(profile);
                  break;
                case AppBarMenuActions.settings:
                  Navigator.of(context).pushNamed(settings);
                  break;
                case AppBarMenuActions.logout:
                  await showLogoutAlert(context);
                  break;

                default:
              }
            }, 
            
            itemBuilder: (context) {
              return [

                  const PopupMenuItem<AppBarMenuActions>(
                  value: AppBarMenuActions.profile,
                  child: Text("Profile")
                ),

                  const PopupMenuItem<AppBarMenuActions>(
                  value: AppBarMenuActions.settings,
                  child: Text("settings"),
                ),

                  const PopupMenuItem<AppBarMenuActions>(
                  value: AppBarMenuActions.logout,
                  child: Text("Logout"),
                ),


              ];
              
            },
          ),

        ],

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


                
        
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: SizedBox(
                  // width: , 
                  height: 50,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: maintheme,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                    ),
                  
                    onPressed: () {
                      Navigator.of(context).pushNamed(welcomeview);
                    },
                  
                    child: const Text(
                      "sign in with anohter account",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                      ),
                      )
                          
                  ),
                ),
              )
        
        
            ],
          ),
        ),
      ),
    );
  }
}