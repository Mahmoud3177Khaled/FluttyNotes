import 'package:firstfluttergo/constants/Enumerations.dart';
import 'package:firstfluttergo/constants/colors.dart';
import 'package:firstfluttergo/Globals/global_vars.dart';
// import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firstfluttergo/constants/routes.dart';
import 'package:firstfluttergo/services/CRUD/notes_service.dart';
import 'package:firstfluttergo/services/auth/auth_services.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';


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

  
  bool? mode = false;


  Future<void> loadGlobalVariables() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // String? savedUsername = prefs.getString('userNameInGlobal');
    
      final user = await _notesService.getUser(email: userEmail);
      setState(() {
        userNameInGlobal = user.username;
        prefs.setString('userNameInGlobal', userNameInGlobal);
        // prefs.setBool('isDarkMode', isDarkMode);

        mode = prefs.getBool('isDarkMode');

        if(mode ?? false) {
          
          backgroundColor = "0xFF000000";
          foregroundColor = "0xFFe5e5e5";
          darknotecolor = "0xFF1b1b1b";
          darknotefontcolor = "0xFFe5e5e5";
          devtools.log("Nighmode on");
            
        } else {
          backgroundColor = "0xFFe5e5e5";
          foregroundColor = "0xFF000000";
          darknotecolor = null;
          darknotefontcolor = null;
          devtools.log("Nighmode off");
        }
    
      });
  }
  

  @override
  void initState() {
    _notesService = NotesService();

    _notesService.open().then((_) => loadGlobalVariables());     // <------ very important solution to use the database in the appbar togther with setState()
    // applyMode();
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
        title: Row(
          children: [

            const Text(""),

            SizedBox(
              width: 50,
              height: 50,
              child: Container(
              
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 187, 187, 187),
                  borderRadius: BorderRadius.circular(50),

                  border: Border.all(
                    color: Colors.blue,
                    width: 3
                  )
                ),
                    
              ),
            ),

            Text(
              "  Hi, $userNameInGlobal",
              style: const TextStyle(
                fontSize: 20
              ),  
            ),
          ],
        ),

        backgroundColor: Color(int.parse(backgroundColor)),
        foregroundColor: Color(int.parse(foregroundColor)),

        actions: [

          IconButton(
            onPressed: ( ) {}, 
            icon: const Icon(Icons.search_rounded)
            
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
            child: PopupMenuButton<AppBarMenuActions>(
              color: const Color.fromARGB(255, 106, 106, 106),
              icon:  SizedBox(
                width: 40,
                height: 50,
                child: InkWell(
                  
                  child: Container(
                  
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(21, 0, 0, 0),
                      borderRadius: BorderRadius.circular(50),
                    ),
                              
                    child: const Icon(
                      Icons.menu,
                    ),
                        
                  ),
                ),
              ),
              
            
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
                    child: Text(
                      "Profile",

                      style: TextStyle(
                        color: Color(0xFFFFFFFF),
                      ),
                      
                    )
                  ),
            
                  const PopupMenuItem<AppBarMenuActions>(
                    value: AppBarMenuActions.settings,
                    child: Text(
                      "settings",

                      style: TextStyle(
                        color: Color(0xFFFFFFFF),
                      ),
                      
                    ),
                  ),
            
                  const PopupMenuItem<AppBarMenuActions>(
                    value: AppBarMenuActions.logout,
                    child: Text(
                      "Logout",

                      style: TextStyle(
                        color: Color(0xFFFFFFFF),
                      ),
                      
                    ),
                  ),
            
            
                ];
                
              },
            ),
          ),

        ],

      ),

      backgroundColor: Color(int.parse(backgroundColor)),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(newNote);
        },

        backgroundColor: const Color.fromARGB(255, 105, 168, 255),
        foregroundColor: Color(int.parse(backgroundColor)),
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
              
                              return Column(
                                children: [
                                  CircularProgressIndicator(
                                    backgroundColor: Color(int.parse(backgroundColor)),
                                    color: Color(int.parse(foregroundColor)),
                                  
                                    
                                  ),
              
                                  const Text("\nWaiting"),
                                ],
                              );
              
                                  
                            case ConnectionState.active:
              
                              var allDataBaseNotes = snapshot.data;
                              List<Widget> allNotesAsWidgets = [];

                              // allNotesAsWidgets.add(
                              //   const Text(
                              //     "All Notes",
                              //     style: TextStyle(
                              //       fontSize: 50,
                              //     ),  
                              //   ),
                              // );
              
                              allDataBaseNotes?.forEach((var note) {
                                Widget oneNote = InkWell(
        
                                  onTap: () {
                                    Navigator.of(context).pushNamed(updateNote, arguments: note);
                                  },
        
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Container(
                                      padding: const EdgeInsets.all(9),
                                    
                                      decoration:  BoxDecoration(
                                        color: Color(int.parse(darknotecolor ?? note.color)),  // <---- be also from note
                                        borderRadius: BorderRadius.circular(25),
                                    
                                        // boxShadow: [
                                        //   BoxShadow(
                                        //     color: Colors.grey.withOpacity(0.5),
                                        //     spreadRadius: 2,
                                        //     blurRadius: 5,
                                        //     offset: const Offset(0, 3),
                                    
                                        //   )
                                        // ]
                                      ),
                                    
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(7.0),
                                            child: Text(
                                              note.title_text,
                                              style: TextStyle(
                                                color: Color( int.parse(darknotefontcolor ?? note.font_color)),  // <---- be also from note
                                                fontSize: 20, 
                                                fontWeight: FontWeight.w700
                                              ),
                                            ),
                                          ),

                                          Padding(
                                            padding: const EdgeInsets.all(6.0),
                                            child: Text(
                                              note.note_text,
                                              style: TextStyle(
                                                color: Color(int.parse(darknotefontcolor ?? note.font_color)),  // <---- be also from note
                                                fontSize: 16, 
                                                fontWeight: FontWeight.w300
                                              ),
                                            ),
                                          ),

                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(75, 15, 0, 0),
                                            child: Text(
                                              "Cr: ${note.date_created}",
                                              style:  TextStyle(
                                                color: Color(int.parse(darknotefontcolor ?? note.font_color)),  // <---- be also from note
                                                fontSize: 8, 
                                                fontWeight: FontWeight.w500
                                              ),
                                            ),
                                          ),

                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(75, 0, 0, 10),
                                            child: Text(
                                              "Ed: ${note.last_modofied}",
                                              style: TextStyle(
                                                color: Color(int.parse(darknotefontcolor ?? note.font_color)),  // <---- be also from note
                                                fontSize: 8, 
                                                fontWeight: FontWeight.w500
                                              ),
                                            ),
                                          ),


                                        ],
                                      )
                                      
                                       
                                    ),
                                  ),
                                );
              
                                allNotesAsWidgets.add(oneNote);
              
                              });
              
                              return Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            "My Notes",
                                            style: TextStyle(
                                              fontSize: 50,
                                              fontWeight: FontWeight.w500,
                                              color: Color(int.parse(foregroundColor)),
                                            ),  
                                          ),
                                        ),

                                        SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            children: [
                                          
                                              Padding(
                                                padding: const EdgeInsets.fromLTRB(5, 20, 5, 20),
                                                child: Container(
                                          
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(40),
                                                    color: Color(int.parse(foregroundColor)),
                                                    
                                                    border: Border.all(
                                                      color: Color(int.parse(foregroundColor)),
                                                      width: 1
                                                    ),
                                                    
                                                  ),
                                                
                                          
                                                  child: Padding(
                                                    padding: const EdgeInsets.fromLTRB(17, 5, 17, 5),
                                                    child: Text(
                                                        "All Notes",
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight: FontWeight.w400,
                                                          color: Color(int.parse(backgroundColor)),
                                                        ),  
                                                      ),
                                                  ),
                                                  
                                                ),
                                              ),
                                          
                                              Padding(
                                                padding: const EdgeInsets.fromLTRB(5, 20, 5, 20),
                                          
                                          
                                                child: Container(
                                                  // padding: const EdgeInsets.all(8),
                                          
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(40),
                                                    color: Color(int.parse(backgroundColor)),

                                                    border: Border.all(
                                                      color: Color(int.parse(foregroundColor)),
                                                      width: 1
                                                    )
                                                  ),
                                                
                                          
                                                  child: Padding(
                                                    padding: const EdgeInsets.fromLTRB(17, 5, 17, 5),
                                                    child: Text(
                                                        "Favourites",
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight: FontWeight.w400,
                                                          color: Color(int.parse(foregroundColor)),
                                                        ),  
                                                      ),
                                                  ),
                                                  
                                                ),
                                              ),
                                          
                                              Padding(
                                                padding: const EdgeInsets.fromLTRB(5, 20, 5, 20),
                                          
                                          
                                                child: Container(
                                                  // padding: const EdgeInsets.all(8),
                                          
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(40),
                                                    color: Color(int.parse(backgroundColor)),

                                                    border: Border.all(
                                                      color: Color(int.parse(foregroundColor)),
                                                      width: 1
                                                    )

                                                  ),
                                                
                                          
                                                  child: Padding(
                                                    padding: const EdgeInsets.fromLTRB(17, 5, 17, 5),
                                                    child: Text(
                                                        "Important",
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight: FontWeight.w400,
                                                          color: Color(int.parse(foregroundColor)),
                                                        ),  
                                                      ),
                                                  ),
                                                  
                                                ),
                                              ),
                                          
                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                          
                                          
                                                child: Container(
                                                  // padding: const EdgeInsets.all(8),
                                          
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(40),
                                                    color: Color(int.parse(backgroundColor)),

                                                    border: Border.all(
                                                      color: Color(int.parse(foregroundColor)),
                                                      width: 1
                                                    )
                                                  ),
                                                
                                          
                                                  child: Padding(
                                                    padding: const EdgeInsets.fromLTRB(17, 5, 17, 5),
                                                    child: Text(
                                                        "Bookmarked",
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight: FontWeight.w400,
                                                          color: Color(int.parse(foregroundColor)),
                                                        ),  
                                                      ),
                                                  ),
                                                  
                                                ),
                                              ),
                                          
                                            ],
                                          ),
                                        ),

                                        StaggeredGrid.count(
                                          crossAxisCount: 2,
                                          crossAxisSpacing: 0.0,
                                          mainAxisSpacing: 0.0,
                                        
                                          children: allNotesAsWidgets.toList(),
                                        
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                              
                            default:
                              return CircularProgressIndicator(
                                backgroundColor: Color(int.parse(backgroundColor)),
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
        ),
      
    );
  }
}