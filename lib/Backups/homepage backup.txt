import 'package:firstfluttergo/constants/Enumerations.dart';
import 'package:firstfluttergo/constants/colors.dart';
import 'package:firstfluttergo/constants/curr_user_name.dart';
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


  Future<void> loadUserName() async {
    final user = await _notesService.getUser(email: userEmail);
    setState(() {
      userNameInGlobal = user.username;
      }
    );
    
  }
  

  @override
  void initState() {
    _notesService = NotesService();

    _notesService.open().then((_) => loadUserName());     // <------ very important solution to use the database in the appbar togther with setState()
    super.initState();
  }

  @override
  void dispose() {
    // _notesService.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(


      appBar: AppBar(
          title: Text("Welcome, $userNameInGlobal"),

                


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

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(newNote);
        },

        backgroundColor: maintheme,
        foregroundColor: Colors.white,
        child: const Text(
          "+", 
          style: TextStyle(
            fontSize: 30, 
            fontFamily: 'Montserrat', 
            fontWeight: FontWeight.w900
          ),
        ),

      ),

      body: Center(
        child: Column(
          // mainAxisSize: MainAxisSize.min,
          children: [
              FutureBuilder(
                future: _notesService.getOrCreateUser(email: userEmail, username: userNameInGlobal),
                builder: (context, snapshot) {

                switch (snapshot.connectionState) {
                  case ConnectionState.done:
                    return StreamBuilder(
                      stream: _notesService.allNotes, 
                      builder: (context, snapshot) {

                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            _notesService.cachNotesFor(currUserEmail: userEmail);

                            if(snapshot.data == null) {
                              return const Text("No notes");
                            }
            
                            return const Column(
                              children: [
                                CircularProgressIndicator(
                                  backgroundColor: Colors.white12,
                                  color: maintheme,
                                
                                  
                                ),
            
                                Text("\nWaiting"),
                              ],
                            );
            
                                
                          case ConnectionState.active:
                            // final list = snapshot.data; //    <---- this to list all the notes
                            // return Text("${list?[23].note_text}");
            
                            var allDataBaseNotes = snapshot.data;
                            List<Widget> allNotesAsButtons = [];
            
                            allDataBaseNotes?.forEach((var note) {
                              Widget oneNote = SizedBox(
                                    width: 400,
                                    height: 130,
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                                      child: TextButton(
                                        onPressed: () {
                                          devtools.log("Click");
            
                                          Navigator.of(context).pushNamed(updateNote, arguments: note);
                                        },
                                        
                                        style: TextButton.styleFrom(
                                          foregroundColor: Colors.black,
                                          backgroundColor: const Color.fromARGB(255, 255, 241, 198),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(7),
                                          ),
                                        ),
                                      
                                        child: Text(
                                          "${note.title_text} / ${note.note_text}",
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600
                                          ),  
                                        ),
                                      ),
                                    
                                    ),
                                  );
            
                              allNotesAsButtons.add(oneNote);
            
                            });
            
                            return Expanded(
                              child: ListView(
                                children: allNotesAsButtons,
                              ),
                            );
            
                            
                          default:
                            return const CircularProgressIndicator(
                              backgroundColor: Colors.white12,
                              color: maintheme,
                            );
                        }
                      },
                    );
                    
                    default:
                      return const CircularProgressIndicator();
                  }
                },
              )
                 
            


            // Padding(
            //   padding: const EdgeInsets.fromLTRB(0, 25, 0, 15),
            //   child: SizedBox(
            //     width: 150,
            //     height: 50,

            //     child: TextButton(
            //       style: TextButton.styleFrom(
            //         foregroundColor: Colors.white,
            //         backgroundColor: maintheme,
            //         shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(7),
            //         ),
            //       ),

            //       onPressed: () {
            //         Navigator.of(context).pushNamed(newNote);
            //       },

            //       child: const Text(
            //         "New Note",
            //         style: TextStyle(
            //             fontSize: 16), // Adjust the font size here
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      )
    );
  }
}