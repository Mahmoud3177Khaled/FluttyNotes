// ignore_for_file: use_build_context_synchronously

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

  String tab1foregroundColor = backgroundColor;
  String tab1backgroundColor = foregroundColor;
  String tab2foregroundColor = foregroundColor;
  String tab2backgroundColor = backgroundColor;
  String tab3foregroundColor = foregroundColor;
  String tab3backgroundColor = backgroundColor;
  String tab4foregroundColor = foregroundColor;
  String tab4backgroundColor = backgroundColor;

  String image1BasedOnMode = "assets/images/no_notes.png";
  String image2BasedOnMode = "assets/images/add_arrow.png";

  
  bool? mode = false;
  List<int> tabsActivity = [0];

  void setActiveTabAndChangeColor(int index) {                  // <-------- This is shit, must be refactored to use arrays instead...
    devtools.log("tap!! $index");

    int beforelasttab = tabsActivity[tabsActivity.length-2];

    devtools.log("before last tap: index:$beforelasttab");

      // remove active state
      switch(beforelasttab) {
        case 0:
          tab1foregroundColor = foregroundColor;
          tab1backgroundColor = backgroundColor;
          break;
        case 1:
          tab2foregroundColor = foregroundColor;
          tab2backgroundColor = backgroundColor;
          break;
        case 2:
          tab3foregroundColor = foregroundColor;
          tab3backgroundColor = backgroundColor;
          break;
        case 3:
          tab4foregroundColor = foregroundColor;
          tab4backgroundColor = backgroundColor;
          break;
      }
      
      // add active state
      switch(index) {
        case 0:
          tab1foregroundColor = backgroundColor;
          tab1backgroundColor = foregroundColor;
          break;
        case 1:
          tab2foregroundColor = backgroundColor;
          tab2backgroundColor = foregroundColor;
          break;
        case 2:
          tab3foregroundColor = backgroundColor;
          tab3backgroundColor = foregroundColor;
          break;
        case 3:
          tab4foregroundColor = backgroundColor;
          tab4backgroundColor = foregroundColor;
          break;
      }


    setState(() {
      

    });
  }


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

          image1BasedOnMode = "assets/images/no_notes_dark.png";
          image2BasedOnMode = "assets/images/add_arrow_dark.png";
          devtools.log("Nighmode on");
            
        } else {
          backgroundColor = "0xFFe5e5e5";
          foregroundColor = "0xFF000000";
          darknotecolor = null;
          darknotefontcolor = null;

          image1BasedOnMode = "assets/images/no_notes.png";
          image2BasedOnMode = "assets/images/add_arrow.png";
          devtools.log("Nighmode off");
        }

        tab1foregroundColor = backgroundColor;
        tab1backgroundColor = foregroundColor;
        tab2foregroundColor = foregroundColor;
        tab2backgroundColor = backgroundColor;
        tab3foregroundColor = foregroundColor;
        tab3backgroundColor = backgroundColor;
        tab4foregroundColor = foregroundColor;
        tab4backgroundColor = backgroundColor;
    
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

    // loadGlobalVariables();

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
                    color: maintheme,
                    width: 1
                  )
                ),

                child: Center(
                  child: ClipOval(
                      child: Image.asset(
                        "assets/images/someone.jpg",
                        width: 200.0,
                        height: 200.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                ),
                    
              ),
            ),

            Text(
              "  Hi, $userNameInGlobal",
              style: const TextStyle(
                fontFamily: 'montserrat',
                fontWeight: FontWeight.bold,
                fontSize: 20,
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

        backgroundColor: maintheme,
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
                                      
                                return const Column(
                                  children: [
                                      
                                    Text("\nLoading"),
                                  ],
                                );
                                      
                                    
                              case ConnectionState.active:

                                if(snapshot.data!.isEmpty) {
                                  return Column(
                                      children: [
                                        
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(0, 40, 0 ,60),
                                          child: Opacity(
                                            opacity: 0.4,
                                            child: Image(
                                              image: AssetImage(image1BasedOnMode)
                                            ),
                                          ),
                                        ),
                                    
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(0, 0 ,0 ,10),
                                          child: Text(
                                            "Hello There! :)",
                                          
                                            style: TextStyle(
                                              color: Color(int.parse(foregroundColor)),
                                              fontSize: 17,
                                              fontFamily: 'montserrat',
                                              fontWeight: FontWeight.bold,
                                          
                                            ),
                                            
                                          ),
                                        ),
                                    
                                    
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 7),
                                          child: Text(
                                            "Looks like you don't have any saved notes",
                                          
                                            style: TextStyle(
                                              color: Color(int.parse(foregroundColor)),
                                              fontSize: 15,
                                              fontFamily: 'montserrat',
                                              fontWeight: FontWeight.bold,
                                          
                                            ),  
                                          ),
                                        ),
                                    
                                    
                                        Text(
                                          "Press the 'add' button to begin",
                                    
                                          style: TextStyle(
                                            color: Color(int.parse(foregroundColor)),
                                              fontSize: 15,
                                              fontFamily: 'montserrat',
                                              fontWeight: FontWeight.bold,
                                          
                                            ),      
                                        ),
                                        
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(50, 30, 0, 0),
                                          child: Opacity(
                                            opacity: 0.1,
                                            child: Image(
                                              image: AssetImage(image2BasedOnMode)
                                            )
                                          ),
                                        ),
                                      ],
                                    );
                                  
                                }
                                      
                                var allDataBaseNotes = snapshot.data;
                                List<Widget> allNotesAsWidgets = [];
                                Widget pinnedNote = const Text("");
                                      
                                allDataBaseNotes?.forEach((var note) {

                                  if(tabsActivity[tabsActivity.length-1] != 0) {
                                    if(note.category != tabsActivity[tabsActivity.length-1]) {
                                      return;
                                    }
                                  }

                                  Widget oneNote = InkWell(
                                
                                    onTap: () {
                                      Navigator.of(context).pushNamed(updateNote, arguments: note);
                                    },
                                
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: IntrinsicHeight(
                                          child: Container(
                                            padding: const EdgeInsets.all(9),
                                            constraints: const BoxConstraints(
                                              maxHeight: 295,
                                            ),
                                          
                                            decoration:  BoxDecoration(
                                              color: note.pinned ? maintheme :  Color(int.parse(darknotecolor ?? note.color)),  // <---- be also from note
                                              borderRadius: BorderRadius.circular(25),
                                          
                                              // boxShadow: [
                                              //   BoxShadow(
                                              //     color: Colors.grey.withOpacity(0.5),
                                              //     spreadRadius: 1,
                                              //     blurRadius: 5,
                                              //     offset: const Offset(0, 3),
                                          
                                              //   )
                                              // ]
                                            ),
                                          
                                            child: SingleChildScrollView(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.all(7.0),
                                                    child: Text(
                                                      note.title_text,
                                                      style: TextStyle(
                                                        // fontFamily: 'montserrat',
                                                        fontWeight: FontWeight.bold,
                                                        color: Color(int.parse(darknotefontcolor ?? note.font_color)),  // <---- be also from note
                                                        fontSize: 20, 
                                                      ),
                                                    ),
                                                  ),
                                                                                      
                                                  Padding(
                                                    padding: const EdgeInsets.all(6.0),
                                                    child: Text(
                                                      note.note_text,
                                                      style: TextStyle(
                                                        color: Color(int.parse(darknotefontcolor ?? note.font_color)),  // <---- be also from note
                                                        fontSize: 14, 
                                                        fontFamily: 'Raleway',
                                                        fontWeight: FontWeight.w600,
                        
                                                      ),
                                                    ),
                                                  ),
                                                                                      
                                                  Row(
                                                    children: [
                                                      Padding(
                                                        padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                                        child: Column(
                                                          children: [
                                                            
                                                            Opacity(
                                                              opacity: 0.8,
                                                              child: Text(
                                                                "Cr: ${note.date_created}",
                                                                style:  TextStyle(
                                                                  color: Color(int.parse(darknotefontcolor ?? note.font_color)),  // <---- be also from note
                                                                  fontSize: 7,
                                                                  fontWeight: FontWeight.bold
                                                                ),
                                                              ),
                                                            ),
                                                            
                                                            Opacity(
                                                              opacity: 0.8,
                                                              child: Text(
                                                                "Ed: ${note.last_modofied}",
                                                                style: TextStyle(
                                                                  color: Color(int.parse(darknotefontcolor ?? note.font_color)),  // <---- be also from note
                                                                  fontSize: 7,
                                                                  fontWeight: FontWeight.bold
                                                                ),
                                                              ),
                                                            ),
                                                        
                                                          ],
                                                        ),
                                                      ),

                                                      Padding(
                                                        padding: EdgeInsets.fromLTRB(note.pinned ? 210 : 12, 0, 0, 0),
                                                        child: SizedBox(
                                                          width: 35,
                                                          child: PopupMenuButton<int>(

                                                            icon: Icon(
                                                              Icons.add,

                                                              color: isDarkMode ? Colors.white : const Color(0xFF47454c),    
                                                            ),

                                                            onSelected: (value) async {

                                                              await _notesService.updateCategory(note: note, category: value); 

                                                              setState(() {
                                                                
                                                              });

                                                            },  
                                                            
                                                            itemBuilder: (context) {
                                                              
                                                              return [
                                                                const PopupMenuItem<int>(
                                                                  value: 1,
                                                                  child: Text("Favourites"),
                                                                  
                                                                ),

                                                                const PopupMenuItem<int>(
                                                                  value: 2,
                                                                  child: Text("Important"),
                                                                  
                                                                ),

                                                                const PopupMenuItem<int>(
                                                                  value: 3,
                                                                  child: Text("Bookmsrked"),
                                                                  
                                                                ),

                                                                const PopupMenuItem<int>(
                                                                  value: 0,
                                                                  child: Text("Remove"),
                                                                  
                                                                ),

                                                              ];
                                                            },
                                                          )
                                                        ),
                                                      ),

                                                      SizedBox(
                                                        width: 35,
                                                        child: Padding(
                                                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                                          child: IconButton(
                                                            onPressed: () async {
                                                              devtools.log("Pin clicked!");
                                                        
                                                              await _notesService.togglePinned(note: note);
                                                        
                                                              setState(() {       // <--- to refresh homepage stream with the newly pinned note 
                                                                    
                                                              });
                                                        
                                                            }, 

                                                            icon: 
                                                            // Transform.rotate(
                                                            //     angle: 20 * 3.1415927 / 180, // Convert 45 degrees to radians
                                                            //     child: 
                                                                Icon(
                                                                  note.pinned ? Icons.push_pin : Icons.push_pin_outlined,

                                                                  color: isDarkMode ? Colors.white : const Color(0xFF47454c),  
                                                                )
                                                          //     ),
                                                          )
                                                        
                                                        ),
                                                      ),

                                                    ],
                                                  ),
                                                                                                                        
                                                ],
                                              ),
                                            )
                                            
                                             
                                          ),
                                        ),
                                      
                                    ),
                                  );

                                  if(note.pinned) {
                                    pinnedNote = oneNote;
                                    return;
                                  }
                                      
                                  allNotesAsWidgets.add(oneNote);   // when we implement bookmarking we will filter this "allNotesAsWidgets"
                                                                    // based on which is the last note currently in "tabsActivity[]" 
                                                                    // and thses will be what's going to be returned in the column of the staggeredview below
                                                                    // يا كريم يا رب
                                      
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
                                                fontFamily: 'Raleway',
                                                fontSize: 50,
                                                fontWeight: FontWeight.w800,
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
                                                  child: InkWell(
                                                    onTap: () {
                                                      // devtools.log("tap!");
                                                      tabsActivity.add(0);
                                                      setActiveTabAndChangeColor(0);
                                                    },
                                                  
                                                    child: Container(
                                                                                              
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(40),
                                                        color: Color(int.parse(tab1backgroundColor)),
                                                        
                                                        border: Border.all(
                                                          color: Color(int.parse(tab1foregroundColor)),
                                                          width: 1
                                                        ),
                                                        
                                                      ),
                                                    
                                                                                              
                                                      child: Padding(
                                                        padding: const EdgeInsets.fromLTRB(17, 5, 17, 5),
                                                        child: Text(
                                                            "All Notes",
                                                            style: TextStyle(
                                                              fontSize: 15,
                                                              fontFamily: 'Raleway',
                                                              fontWeight: FontWeight.bold,
                                                              color: Color(int.parse(tab1foregroundColor)),
                                                            ),  
                                                          ),
                                                      ),
                                                      
                                                    ),
                                                  ),
                                                ),
                                            
                                                Padding(
                                                  padding: const EdgeInsets.fromLTRB(5, 20, 5, 20),
                                            
                                            
                                                  child: InkWell(
                                                    onTap: () {
                                                      // devtools.log("tap!");
                                                      
                                                      tabsActivity.add(1);
                                                      setActiveTabAndChangeColor(1);
                                                    },
                                                    child: Container(
                                                      // padding: const EdgeInsets.all(8),
                                                                                              
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(40),
                                                        color: Color(int.parse(tab2backgroundColor)),
                                                    
                                                        border: Border.all(
                                                          color: Color(int.parse(tab2foregroundColor)),
                                                          width: 1
                                                        )
                                                      ),
                                                    
                                                                                              
                                                      child: Padding(
                                                        padding: const EdgeInsets.fromLTRB(17, 5, 17, 5),
                                                        child: Text(
                                                            "Favourites",
                                                            style: TextStyle(
                                                              fontSize: 15,
                                                              fontFamily: 'Raleway',
                                                              fontWeight: FontWeight.bold,
                                                              color: Color(int.parse(tab2foregroundColor)),
                                                            ),  
                                                          ),
                                                      ),
                                                      
                                                    ),
                                                  ),
                                                ),
                                            
                                                Padding(
                                                  padding: const EdgeInsets.fromLTRB(5, 20, 5, 20),
                                            
                                            
                                                  child: InkWell(
                                                    onTap: () {
                                                      // devtools.log("tap!");
                                                      
                                                      tabsActivity.add(2);
                                                      setActiveTabAndChangeColor(2);
                                                    },
                                                    child: Container(
                                                      // padding: const EdgeInsets.all(8),
                                                                                              
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(40),
                                                        color: Color(int.parse(tab3backgroundColor)),
                                                    
                                                        border: Border.all(
                                                          color: Color(int.parse(tab3foregroundColor)),
                                                          width: 1
                                                        )
                                                    
                                                      ),
                                                    
                                                                                              
                                                      child: Padding(
                                                        padding: const EdgeInsets.fromLTRB(17, 5, 17, 5),
                                                        child: Text(
                                                            "Important",
                                                            style: TextStyle(
                                                              fontSize: 15,
                                                              fontFamily: 'Raleway',
                                                              fontWeight: FontWeight.bold,
                        
                                                              color: Color(int.parse(tab3foregroundColor)),
                                                            ),  
                                                          ),
                                                      ),
                                                      
                                                    ),
                                                  ),
                                                ),
                                            
                                                Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                            
                                            
                                                  child: InkWell(
                                                    onTap: () {
                                                      // devtools.log("tap!");
                        
                                                      tabsActivity.add(3);
                                                      setActiveTabAndChangeColor(3);
                                                    },
                                                    child: Container(
                                                      // padding: const EdgeInsets.all(8),
                                                                                              
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(40),
                                                        color: Color(int.parse(tab4backgroundColor)),
                                                    
                                                        border: Border.all(
                                                          color: Color(int.parse(tab4foregroundColor)),
                                                          width: 1
                                                        )
                                                      ),
                                                    
                                                                                              
                                                      child: Padding(
                                                        padding: const EdgeInsets.fromLTRB(17, 5, 17, 5),
                                                        child: Text(
                                                            "Bookmarked",
                                                            style: TextStyle(
                                                              fontSize: 15,
                                                              fontFamily: 'Raleway',
                                                              fontWeight: FontWeight.bold,
                        
                                                              color: Color(int.parse(tab4foregroundColor)),
                                                            ),  
                                                          ),
                                                      ),
                                                      
                                                    ),
                                                  ),
                                                ),
                                            
                                              ],
                                            ),
                                          ),

                                          StaggeredGrid.count(
                                            crossAxisCount: 1,
                                            crossAxisSpacing: 0.0,
                                            mainAxisSpacing: 0.0,
                                          
                                            children: [

                                              pinnedNote

                                            ]
                                          
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
              
            ],
          ),
        ),
      
    );
  }
}