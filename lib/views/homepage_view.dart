// import 'package:firebase_auth/firebase_auth.dart';
import 'package:firstfluttergo/constants/Enumerations.dart';
import 'package:firstfluttergo/constants/colors.dart';
import 'package:firstfluttergo/constants/routes.dart';
import 'package:firstfluttergo/services/CRUD/notes_service.dart';
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


class Homepageview extends StatefulWidget {

  
  const Homepageview({super.key});

  @override
  State<Homepageview> createState() => _HomepageviewState();
}

class _HomepageviewState extends State<Homepageview> {

  final user = AuthService.firebase().currentUser?.user;
  
  late final NotesService _notesService;
  String get userEmail => AuthService.firebase().currentUser!.email!;


  @override
  void initState() {
    _notesService = NotesService();
    _notesService.open();
    super.initState();
  }

  @override
  void dispose() {
    _notesService.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {


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

      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FutureBuilder(
              future: _notesService.getOrCreateUser(email: userEmail),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.done:
            
                    return StreamBuilder(
                      stream: _notesService.allNotes, 
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                              return Text("${_notesService.allNotes}");
                          default:
                            return const CircularProgressIndicator();
                        }
                      },
                    );
                    
                  default:
                    return const CircularProgressIndicator();
                }
              },
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(0, 25, 0, 15),
              child: SizedBox(
                width: 150,
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
                    Navigator.of(context).pushNamed(newNote);
                  },

                  child: const Text(
                    "New Note",
                    style: TextStyle(
                        fontSize: 16), // Adjust the font size here
                  ),
                ),
              ),
            ),
          ],
        ),
      )
    );
  }
}