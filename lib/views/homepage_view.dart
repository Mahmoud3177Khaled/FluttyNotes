// ignore_for_file: use_build_context_synchronously, prefer_interpolation_to_compose_strings, prefer_const_constructors,, avoid_function_literals_in_foreach_calls

import 'package:firstfluttergo/constants/Enumerations.dart';
import 'package:firstfluttergo/constants/colors.dart';
import 'package:firstfluttergo/Globals/global_vars.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firstfluttergo/constants/routes.dart';
import 'package:firstfluttergo/services/CRUD/notes_service.dart';
import 'package:firstfluttergo/services/auth/auth_services.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../tools/alert_boxes.dart';


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
  late final TextEditingController _newTabTitle;

  final user = AuthService.firebase().currentUser?.user;
  late final NotesService _notesService;

  String get userEmail => AuthService.firebase().currentUser!.email!;

  String image1BasedOnMode = "assets/images/no_notes.png";
  String image2BasedOnMode = "assets/images/add_arrow.png";
  bool? mode = false;
  bool tabsEmpty = false;

  List<Map<String, String>> tabsAsListOfMaps = [
    {"name": "All Notes", "foregroundColor": foregroundColor, "backgroundColor": backgroundColor},
    
  ];

  List<int> tabsNumOfNotes = [0];
  List<Widget> allTabsAsWidgets = [];
  List<int> tabsActivity = [0, 0];
  List<PopupMenuItem> addOptions = [];
  Widget placeholder = Text("");


  void addNewTabAsMap({required String name}) {
    tabsAsListOfMaps.add({"name": name, "foregroundColor": foregroundColor, "backgroundColor": backgroundColor});
  }

  void addATabAsWidget({required String name}) {

    tabsNumOfNotes.add(0);
    addNewTabAsMap(name: name);

    int noteNum = tabsNumOfNotes.length-1;
    
    Widget newTab = Padding(
        padding: const EdgeInsets.fromLTRB(5, 20, 5, 20),
        child: InkWell(
          onTap: () {
            devtools.log("tap!");

            tabsActivity.add(noteNum);
            setActiveTabAndChangeColor();

          },

          onLongPress: () {
            showAlertBox(context, title: "Delete?", 
              content: const SizedBox(
                width: 300,
                child: Text(
                  "Are you sure you want to remove this tab?",
                  style: TextStyle(
                    color: Colors.white
                  ),  
                ) 
              ),

              opt1: TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },

                child: const Text(
                  "Cancel",
                  style: TextStyle(
                    color: Colors.white
                  ),   
                )
              ),

              opt2: TextButton(
                onPressed: () {
                  
                  removeTab(tabNum: noteNum);
                  Navigator.of(context).pop(false);

                  setState(() {
                    
                  });

                },

                child: const Text(
                  "Delete",
                  style: TextStyle(
                    color: Colors.white
                  ),   
                ),

              ),

            );
          },
        
          child: Container(
                                                    
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              color: Color(int.parse(tabsAsListOfMaps[noteNum]["backgroundColor"]!)),
              
              border: Border.all(
                color: Color(int.parse(tabsAsListOfMaps[noteNum]["foregroundColor"]!)),
                width: 1
              ),
              
            ),
          
                                                    
            child: Padding(
              padding: const EdgeInsets.fromLTRB(17, 10, 17, 10),
              child: Row(
                children: [
                  Text(
                      name,
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Raleway',
                        fontWeight: FontWeight.bold,
                        color: Color(int.parse(tabsAsListOfMaps[noteNum]["foregroundColor"]!)),
                      ),  

                    ),
                    
                    
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: Container(

                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            color: (mode ?? false) ?  const Color.fromARGB(255, 75, 75, 75) : const Color.fromARGB(255, 177, 177, 177),
                            
                          ),

                          child: Center(
                            child: Text(
                              tabsNumOfNotes[tabsNumOfNotes.length-1].toString(),
                              style: TextStyle(
                                fontSize: 12,
                                // fontFamily: 'Raleway',
                                // fontWeight: FontWeight.bold,
                                color: Color(int.parse(foregroundColor)),
                              ),  
                            ),
                          ),
                        ),
                      ),
                    ),

                ],
              ),
            ),
            
          ),
        ),
      );
    // final addNutton = allTabsAsWidgets.removeLast();
    allTabsAsWidgets.add(newTab);
    isTabsEmpty();
    // allTabsAsWidgets.add(addNutton);

  }

  void setFirstTabAndUpdate({required int tabNum, required numOFNotes}) {

    if(allTabsAsWidgets.isEmpty) {

    Widget newTab = Padding(
        padding: const EdgeInsets.fromLTRB(5, 20, 5, 20),
        child: InkWell(
          onTap: () {
            devtools.log("tap!");

            tabsActivity.add(0);
            setActiveTabAndChangeColor();

          },

          onLongPress: () {
            showAlertBox(context, title: "Delete?", 
              content: const SizedBox(
                width: 300,
                child: Text(
                  "Are you sure you want to remove this tab?",
                  style: TextStyle(
                    color: Colors.white
                  ),   
                ) 
              ),

              opt1: TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },

                child: const Text(
                  "Cancel",
                  style: TextStyle(
                    color: Colors.white
                  ), 
                )
              ),

              opt2: TextButton(
                onPressed: () {
                  
                  removeTab(tabNum: tabNum);
                  Navigator.of(context).pop(false);

                  setState(() {
                    
                  });

                },

                child: const Text(
                  "Delete",
                  style: TextStyle(
                    color: Colors.white
                  ),   
                ),

              ),

            );
          },
        
          child: Container(
                                                    
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              color: Color(int.parse(tabsAsListOfMaps[0]["backgroundColor"]!)),
              
              border: Border.all(
                color: Color(int.parse(tabsAsListOfMaps[0]["foregroundColor"]!)),
                width: 1
              ),
              
            ),
          
                                                    
            child: Padding(
              padding: const EdgeInsets.fromLTRB(17, 10, 17, 10),
              child: Row(
                children: [
                  Text(
                      "All Notes",
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Raleway',
                        fontWeight: FontWeight.bold,
                        color: Color(int.parse(tabsAsListOfMaps[0]["foregroundColor"]!)),
                      ),  

                    ),
                    
                    
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: Container(

                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            color: (mode ?? false) ?  const Color.fromARGB(255, 75, 75, 75) : const Color.fromARGB(255, 177, 177, 177),
                            
                          ),

                          child: Center(
                            child: Text(
                              tabsNumOfNotes[0].toString(),
                              style: TextStyle(
                                fontSize: 12,
                                // fontFamily: 'Raleway',
                                // fontWeight: FontWeight.bold,
                                color: Color(int.parse(foregroundColor)),
                              ),  
                            ),
                          ),
                        ),
                      ),
                    ),

                ],
              ),
            ),
            
          ),
        ),
      );

      allTabsAsWidgets.add(newTab);
    } else {

      if(allTabsAsWidgets[tabNum] != placeholder)
      {

      allTabsAsWidgets[tabNum] = Padding(
        padding: const EdgeInsets.fromLTRB(5, 20, 5, 20),
        child: InkWell(
          onTap: () {
            devtools.log("tap! note $tabNum will be created/updated");

            tabsActivity.add(tabNum);
            setActiveTabAndChangeColor();

          },

          onLongPress: () {
            showAlertBox(context, title: "Delete?", 
              content: const SizedBox(
                width: 300,
                child: Text(
                  "Are you sure you want to remove this tab?",
                  style: TextStyle(
                    color: Colors.white
                  ),   
                ) 
              ),

              opt1: TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                  
                },

                child: const Text(
                  "Cancel",
                  style: TextStyle(
                    color: Colors.white
                  ),   
                )
              ),

              opt2: TextButton(
                onPressed: () {
                  removeTab(tabNum: tabNum);
                  Navigator.of(context).pop(false);

                  setState(() {
                    
                  });

                },

                child: const Text(
                  "Delete",
                  style: TextStyle(
                    color: Colors.white
                  ),   
                ),

              ),

            );
          },
        
          child: Container(
                                                    
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              color: Color(int.parse(tabsAsListOfMaps[tabNum]["foregroundColor"]!)),
              
              border: Border.all(
                color: Color(int.parse(tabsAsListOfMaps[tabNum]["backgroundColor"]!)),
                width: 1
              ),
              
            ),
          
                                                    
            child: Padding(
              padding: const EdgeInsets.fromLTRB(17, 10, 17, 10),
              child: Row(
                children: [
                  Text(
                      tabsAsListOfMaps[tabNum]["name"]!,
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Raleway',
                        fontWeight: FontWeight.bold,
                        color: Color(int.parse(tabsAsListOfMaps[tabNum]["backgroundColor"]!)),
                      ),  

                    ),
                    
                    
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: Container(

                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            color: (mode ?? false) ?  const Color.fromARGB(255, 75, 75, 75) : const Color.fromARGB(255, 177, 177, 177),
                            
                          ),

                          child: Center(
                            child: Text(
                              numOFNotes.toString(),
                              style: TextStyle(
                                fontSize: 12,
                                // fontFamily: 'Raleway',
                                // fontWeight: FontWeight.bold,
                                color: Color(int.parse(foregroundColor)),
                              ),  
                            ),
                          ),
                        ),
                      ),
                    ),

                ],
              ),
            ),
            
          ),
        ),
      );

      }
    }

    isTabsEmpty();
  }

  void setActiveTabAndChangeColor() {                  // <-------- This is shit, must be refactored to use arrays instead...

    int beforeLastTab = tabsActivity[tabsActivity.length-2];
    int lastTab = tabsActivity[tabsActivity.length-1];

    devtools.log("tap!! $lastTab");
    devtools.log("before last tap: index:$beforeLastTab");

      // remove active state
      tabsAsListOfMaps[beforeLastTab]["foregroundColor"] = backgroundColor;
      tabsAsListOfMaps[beforeLastTab]["backgroundColor"] = foregroundColor;
      setFirstTabAndUpdate(tabNum: beforeLastTab, numOFNotes: tabsNumOfNotes[beforeLastTab]);

      // set active state
      tabsAsListOfMaps[lastTab]["foregroundColor"] = foregroundColor;
      tabsAsListOfMaps[lastTab]["backgroundColor"] = backgroundColor;
      setFirstTabAndUpdate(tabNum: lastTab, numOFNotes: tabsNumOfNotes[lastTab]);


    setState(() {
      

    });
  }

  void removeTab({required int tabNum}) {
    devtools.log("before: " + allTabsAsWidgets.toString());

    // tabsNumOfNotes[tabNum] = 0;
    allTabsAsWidgets[tabNum] = placeholder;    //  <------ all tabs as widgets must be a map <String: tabnum, Widget>
    tabsAsListOfMaps[tabNum] = {};

    tabsActivity.add(0);

    devtools.log("\nafter: " + allTabsAsWidgets.toString() + "\n");
    devtools.log("\nDeleted: " + tabNum.toString() + "\n");

    isTabsEmpty();

  }


  void updateOptions() {
    addOptions = [];

    int i = 0;
    tabsAsListOfMaps.forEach((tab) {
      if(allTabsAsWidgets[i] != placeholder && i != 0 && tab != {}) {
        addOptions.add(
          PopupMenuItem<int>(
            value: i,
            child: Text(tab["name"]!),
            
          ),
        );
      }
        devtools.log(i.toString());
        i++;
    },);

    addOptions.add(
      PopupMenuItem<int>(
            value: 0,
            child: Text("Remove"),
            
          ),
    );

    // addOptions = addOptions.toSet().toList();

    
  }

  void isTabsEmpty() {

    tabsEmpty = false;

    int j = 0;

    allTabsAsWidgets.forEach((tab) {
      if(tab != placeholder) {
        j++;
      }
    },);

    if(j == 1) {
      tabsEmpty = true;
    }
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

        if((mode ?? false)) {
          
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

        for( var map in tabsAsListOfMaps) {
          if(map["foregroundColor"] == foregroundColor) {
            map["foregroundColor"] = foregroundColor;
          } else {
            map["foregroundColor"] = backgroundColor;
          }

          if(map["backgroundColor"] == backgroundColor) {
            map["backgroundColor"] = backgroundColor;
          } else {
            map["backgroundColor"] = foregroundColor;
          }
        }
    
      });
  }
  

  @override
  void initState() {
    _notesService = NotesService();
    _newTabTitle = TextEditingController();

    _notesService.open().then((_) => loadGlobalVariables());     // <------ very important solution to use the database in the appbar togther with setState()

    setFirstTabAndUpdate(tabNum: 0, numOFNotes: 0);
    setActiveTabAndChangeColor();
    isTabsEmpty();

    super.initState();
  }

  @override
  void dispose() {
    // _notesService.close();
    _newTabTitle.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    setActiveTabAndChangeColor();
    updateOptions();
    isTabsEmpty();

    devtools.log(allTabsAsWidgets.toString());

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
            onPressed: ( ) {
              Navigator.of(context).pushNamed(search);
            }, 
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
        // shape
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
                                Widget? pinnedNote;
                                      
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
                                            constraints: BoxConstraints(
                                              maxHeight: note.pinned ? 180 : 295,
                                            ),
                                          
                                            decoration:  BoxDecoration(
                                              color: (note.pinned && (mode ?? false)) ? maintheme :  Color(int.parse(darknotecolor ?? note.color)),  // <---- be also from note
                                              borderRadius: BorderRadius.circular(25),
                                          
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
                                                        color: (note.pinned && (mode ?? false)) ? Colors.black : Color(int.parse(darknotefontcolor ?? note.font_color)),  // <---- be also from note
                                                        fontSize: 19, 
                                                      ),
                                                    ),
                                                  ),
                                                                                      
                                                  Padding(
                                                    padding: const EdgeInsets.all(6.0),
                                                    child: Text(
                                                      note.note_text,
                                                      style: TextStyle(
                                                        color: (note.pinned && (mode ?? false)) ? Colors.black : Color(int.parse(darknotefontcolor ?? note.font_color)),  // <---- be also from note
                                                        fontSize: 14, 
                                                        fontFamily: 'Raleway',
                                                        fontWeight: FontWeight.bold,
                        
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
                                                                  color: (note.pinned && (mode ?? false)) ? Colors.black :Color(int.parse(darknotefontcolor ?? note.font_color)),  // <---- be also from note
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
                                                                  color: (note.pinned && (mode ?? false)) ? Colors.black :Color(int.parse(darknotefontcolor ?? note.font_color)),  // <---- be also from note
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
                                                          child: !tabsEmpty ?  PopupMenuButton(

                                                            icon:   Icon(
                                                              Icons.add,

                                                              color: (note.pinned && (mode ?? false)) ? Colors.black : ((mode ?? false) ? Colors.white : const Color(0xFF47454c)),    
                                                            ),

                                                            onSelected: (value) async {

                                                              await _notesService.updateCategory(note: note, category: value); 

                                                              setState(() {
                                                                
                                                              });

                                                            },  
                                                            
                                                            itemBuilder: (context) {
                                                              
                                                              return addOptions;
                                                            },
                                                          )  : Text(""),
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

                                                                  color: (note.pinned && (mode ?? false)) ? Colors.black : (mode ?? false) ? Colors.white : const Color(0xFF47454c),  
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
                                      
                                  allNotesAsWidgets.add(oneNote);   // يا كريم يا رب
                                      
                                });

                                tabsNumOfNotes[tabsActivity[tabsActivity.length-1]] = allNotesAsWidgets.length;
                                setFirstTabAndUpdate(tabNum: tabsActivity[tabsActivity.length-1], numOFNotes:  tabsNumOfNotes[tabsActivity[tabsActivity.length-1]]);

                                devtools.log("tab: " + (tabsActivity[tabsActivity.length-1]).toString());
                                devtools.log("# of notes:" + tabsNumOfNotes[tabsActivity[tabsActivity.length-1]].toString());
                                      
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

                                                  Row(
                                                      children: allTabsAsWidgets
                                                  ),

                                                  InkWell(
                                                  onTap: () {
                                                    showAlertBox(context, title: "Name your new tab:", 
                                                      content: SizedBox(
                                                        width: 300,
                                                        child: TextField(
                                                          cursorColor: maintheme,
                                                          controller: _newTabTitle,
                                                          // obscureText: true,
                                                          enableSuggestions: true,
                                                          autocorrect: true,
                                                          autofocus: true,
                                                          style: TextStyle(
                                                            color: Colors.white
                                                          ),
                                                          decoration: const InputDecoration(
                                                            
                                                        
                                                            // hintText: "Enter your Password",
                                                        
                                                            labelText: "Tab name",
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

                                                      opt1: TextButton(
                                                        onPressed: () {
                                                          addATabAsWidget(name: _newTabTitle.text);
                                                          Navigator.of(context).pop(false);
                                                          _newTabTitle.text = "";

                                                          setState(() {
                                                            
                                                          });
                                                        },
                                                        child: const Text(
                                                          "Done",
                                                          style: TextStyle(
                                                            color: Colors.white
                                                          ),  
                                                        ))
                                                    );
                                                  },
                                              
                                                  child: Padding(
                                                    padding: const EdgeInsets.fromLTRB(7, 0, 0, 0),
                                                    child: SizedBox(
                                                      width: 40,
                                                      height: 40,
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                          color: const Color.fromARGB(255, 0, 0, 0),
                                                          borderRadius: BorderRadius.circular(100),
                                                    
                                                          border: Border.all(
                                                            color: Colors.white,
                                                    
                                                            width: 1  
                                                          )
                                                        ),
                                                    
                                                        child: Center(
                                                          child: Text(
                                                            "+",
                                                    
                                                            style: TextStyle(
                                                              fontSize: 20,
                                                              color: Colors.white
                                                            ) 
                                                            
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),


                                          if (pinnedNote != null) StaggeredGrid.count(
                                            crossAxisCount: 1,
                                            crossAxisSpacing: 0.0,
                                            mainAxisSpacing: 0.0,
                                          
                                            children: [

                                              pinnedNote!

                                            ]
                                          
                                          ) else 
                                            Container(),

                                          StaggeredGrid.count(
                                            crossAxisCount: 2,
                                            crossAxisSpacing: 0.0,
                                            mainAxisSpacing: 0.0,
                                          
                                            children: allNotesAsWidgets.toList(),
                                          
                                          ),


                                          if (allNotesAsWidgets.isEmpty && pinnedNote == null) Padding(
                                            padding: const EdgeInsets.fromLTRB(20, 110, 0, 0),
                                            child: Center(
                                              child: Opacity(
                                                opacity: (mode ?? false) ? 0.3 : 0.7, 
                                                child: const Image(
                                                  image: AssetImage("assets/images/empty_category.png"),
                                                )
                                              )
                                            ),
                                          ) else 
                                            const Text("")


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