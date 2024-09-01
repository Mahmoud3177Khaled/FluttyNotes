// ignore_for_file: unused_import, use_build_context_synchronously, avoid_function_literals_in_foreach_calls

import 'package:firstfluttergo/constants/Enumerations.dart';
import 'package:firstfluttergo/constants/colors.dart';
import 'package:firstfluttergo/Globals/global_vars.dart';
import 'package:firstfluttergo/services/CRUD/cloud/firestore_cloud_notes_services.dart';
import 'package:firstfluttergo/tools/alert_boxes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firstfluttergo/constants/routes.dart';
// import 'package:firstfluttergo/services/CRUD/notes_service.dart';
import 'package:firstfluttergo/services/auth/auth_services.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

// import '../tools/alert_boxes.dart';


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


List<Widget> allTabsAsWidgets = [];
List<PopupMenuItem> addOptions = [];

class _HomepageviewState extends State<Homepageview> {
  late final TextEditingController _newTabTitle;

  final user = AuthService.firebase().currentUser?.user;
  late final FirestoreCloudNotesServices _cloudNotesService;

  late final String userID;
  String lastActiveTabId = "";

  
  // late final String currUserName;

  String image1BasedOnMode = "assets/images/no_notes.png";
  String image2BasedOnMode = "assets/images/add_arrow.png";
  bool? mode = false;
 

  Future<void> loadGlobalVariables() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // currUserName = await _cloudNotesService.getUserName(userID: userID);

    setState(() {
      

      mode = prefs.getBool('isDarkMode');

      if((mode ?? false)) {
        
        backgroundColor = "0xFF000000";
        foregroundColor = "0xFFe5e5e5";
        darknotecolor = "0xFF1b1b1b";
        darknotefontcolor = "0xFFe5e5e5";

        image1BasedOnMode = "assets/images/no_notes_dark.png";
        image2BasedOnMode = "assets/images/add_arrow_dark.png";
        // devtools.log("Nighmode on");
          
      } else {
        backgroundColor = "0xFFe5e5e5";
        foregroundColor = "0xFF000000";
        darknotecolor = null;
        darknotefontcolor = null;

        image1BasedOnMode = "assets/images/no_notes.png";
        image2BasedOnMode = "assets/images/add_arrow.png";
        // devtools.log("Nighmode off");
      }
    
      });
  }

  @override
  void initState() {
    _cloudNotesService = FirestoreCloudNotesServices();

    userID = AuthService.firebase().currentUser!.id;

    _newTabTitle = TextEditingController();

    /*_cloudNotesService.open().then( (_) => */loadGlobalVariables();     // <------ very important solution to use the database in the appbar togther with setState()
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

    devtools.log(userID.toString());

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

            FutureBuilder(
              future: _cloudNotesService.getUserName(userID: userID),
              builder: (context, snapshot) {
                if(snapshot.connectionState == ConnectionState.done) {
                  return Text(
                    "  Hi, ${snapshot.data}",
                    style: const TextStyle(
                      fontFamily: 'montserrat',
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),  
                  );

                } else {
                  return const Text("");
                }
              }
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
            
                // devtools.log("This is $value");
            
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

      body: FutureBuilder(
        future: AuthService.firebase().initializeApp(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return Center(
              child: Column(
                // mainAxisSize: MainAxisSize.min,
                children: [
          
                  StreamBuilder(
                    stream: _cloudNotesService.allTabsInStream(ownerUserId: userID), 
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.active:
  
                          var allTabsAsObjects = snapshot.data;
                          devtools.log(allTabsAsObjects.toString());
                          if(allTabsAsObjects != null) {
  
                            allTabsAsWidgets = [];
                            
                            allTabsAsObjects.forEach((tab) {
                  
                              Widget oneTab = Padding(
                                padding: const EdgeInsets.fromLTRB(5, 20, 5, 20),
                                child: InkWell(
                                  onTap: () async {

                                    await _cloudNotesService.resetTabColor(
                                      ownerUserId: userID,
                                      newColor: (mode ?? false) ? "0xFF000000" : "0xFFe5e5e5",
                                      newFontAndBorderColor: (mode ?? false) ? "0xFFe5e5e5" : "0xFF000000", 
                                      
                                    );

                                    await _cloudNotesService.updateTab(
                                      tabId: tab.id, 
                                      newName: tab.name, 
                                      newColor: (mode ?? false) ? "0xFFe5e5e5" : "0xFF000000", 
                                      newFontAndBorderColor: (mode ?? false) ? "0xFF000000" : "0xFFe5e5e5"
                                      
                                    );

                                    lastActiveTabId = tab.id;

                                    setState(() {
                                      
                                    });
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
                                        onPressed: () async {
                                          await _cloudNotesService.deleteTab(tabId: tab.id);
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
                                      color: Color(int.parse(tab.color)),
                                      
                                      border: Border.all(
                                        color: Color(int.parse(tab.fontAndBorderColor)),
                                        width: 1
                                      ),
                                      
                                    ),
                                  
                                                                            
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(17, 10, 17, 10),
                                      child: Row(
                                        children: [
                                          Text(
                                              tab.name,
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontFamily: 'Raleway',
                                                fontWeight: FontWeight.bold,
                                                color: Color(int.parse(tab.fontAndBorderColor)),
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
                  
                                                  // child: Center(
                                                  //   child: Text(
                                                  //     numOFNotes.toString(),
                                                  //     style: TextStyle(
                                                  //       fontSize: 12,
                                                  //       // fontFamily: 'Raleway',
                                                  //       // fontWeight: FontWeight.bold,
                                                  //       color: Color(int.parse(foregroundColor)),
                                                  //     ),  
                                                  //   ),
                                                  // ),
                                                ),
                                              ),
                                            ),
                  
                                        ],
                                      ),
                                    ),
                                    
                                  ),
                                ),
                              );
                  
                              allTabsAsWidgets.add(oneTab);
                            },);

                            addOptions = [];

                            allTabsAsObjects.forEach((tab) {
                              addOptions.add(
                                PopupMenuItem<String>(
                                  value: tab.id,
                                  child: Text(tab.name),
                                  
                                ),
  
                              );

                            },);

                          } else {
                            devtools.log("tabs snapshot is null");
                          }
                  
                          return const Text("");
                        case ConnectionState.waiting:
                          devtools.log("waiting");
                          // devtools.log(snapshot.data.toString());
                          return const Text("no tabs");
                        case ConnectionState.none:
                          devtools.log("none");
                          return const Text("no tabs");
                        default:
                          return const Text("");
                      }
                    },
                    
                  ),
                    
          
                  
                    StreamBuilder(
                      stream: _cloudNotesService.allNotesInStream(ownerUserId: userID), 
                      builder: (context, snapshot) {
                            
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            // _notesService.cachNotesFor(currUserEmail: userEmail);
                                  
                            return const Column(
                              children: [
                                  
                                Text("\nLoading"),
                              ],
                            );
                                  
                                
                          case ConnectionState.active:

                            if(snapshot.data == null) {
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
                                  
                            var allDataBaseNotes = snapshot.data ?? [];

                            List<Widget> allNotesAsWidgets = [];
                            List<Widget> pinnedNotes = [];
                                  
                            allDataBaseNotes.forEach((var note) {
                              devtools.log(note.font_color);

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
                                          color: (note.pinned && (mode ?? false)) ? maintheme : Color(int.parse(darknotecolor ?? note.color)),  // <---- be also from note
                                          borderRadius: BorderRadius.circular(25),
                                      
                                        ),
                                      
                                        child: SingleChildScrollView(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.all(7.0),
                                                child: Text(
                                                  note.note_title,
                                                  
                                                  style: TextStyle(
                                                    fontFamily: 'Poppins',
                                                    fontWeight: FontWeight.bold,
                                                    color: (note.pinned && (mode ?? false)) ? Colors.black : Color(int.parse(darknotefontcolor ?? note.font_color)),  // <---- be also from note
                                                    fontSize: 15, 
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
                                                            "Ed: ${note.last_modified}",
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
                                                    padding: EdgeInsets.fromLTRB(note.pinned ? 210 : 20, 0, 0, 0),
                                                    child: SizedBox(
                                                      width: 34,
                                                      child: allTabsAsWidgets.isNotEmpty ?  PopupMenuButton(

                                                        icon:   Icon(
                                                          Icons.add,

                                                          color: (note.pinned && (mode ?? false)) ? Colors.black : ((mode ?? false) ? Colors.white : const Color(0xFF47454c)),    
                                                        ),

                                                        onSelected: (value) async {
                                                          // TODO: use the new update func
                                                          // await _notesService.updateCategory(note: note, category: value); 

                                                          setState(() {
                                                            
                                                          });

                                                        },  
                                                        
                                                        itemBuilder: (context) {
                                                          
                                                          return addOptions;
                                                        },
                                                      )  : const Text(""),
                                                    ),
                                                  ),

                                                  SizedBox(
                                                    width: 34,
                                                    child: Padding(
                                                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                                      child: IconButton(
                                                        onPressed: () async {
                                                    
                                                          await _cloudNotesService.updateNote(noteId: note.id, newText: note.note_text, newTitle: note.note_title, newColor: note.color, newFontColor: note.font_color, pinned: note.pinned ? false : true, category: note.category);
                                                    
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
                                pinnedNotes.add(oneNote);
                                return;
                              }
                                  
                              allNotesAsWidgets.add(oneNote);   // يا كريم يا رب
                                  
                            });

                            // tabsNumOfNotes[tabsActivity[tabsActivity.length-1]] = allNotesAsWidgets.length;
                            // setFirstTabAndUpdate(tabNum: tabsActivity[tabsActivity.length-1], numOFNotes:  tabsNumOfNotes[tabsActivity[tabsActivity.length-1]]);

                            // devtools.log("tab: " + (tabsActivity[tabsActivity.length-1]).toString());
                            // devtools.log("# of notes:" + tabsNumOfNotes[tabsActivity[tabsActivity.length-1]].toString());
                                  
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
                                                      style: const TextStyle(
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
                                                    onPressed: () async {

                                                      if(_newTabTitle.text == "") {
                                                        Navigator.of(context).pop(false);
                                                        return;
                                                      }

                                                      // addATabAsWidget(name: _newTabTitle.text, addNewMap: true);
                                                      await _cloudNotesService.createCloudTab(
                                                        ownerUserId: userID, 
                                                        tabName: _newTabTitle.text, 
                                                        color: (mode ?? false) ? "0xFF000000" : "0xFFe5e5e5", 
                                                        font_and_border_color: (mode ?? false) ? "0xe5e5e5FF" : "0xFF000000");

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
                                                
                                                    child: const Center(
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


                                      if (pinnedNotes.isNotEmpty) StaggeredGrid.count(
                                        crossAxisCount: 1,
                                        crossAxisSpacing: 0.0,
                                        mainAxisSpacing: 0.0,
                                      
                                        children: pinnedNotes
                                      
                                      ) else 
                                        Container(),

                                      StaggeredGrid.count(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 0.0,
                                        mainAxisSpacing: 0.0,
                                      
                                        children: allNotesAsWidgets.toList(),
                                      
                                      ),


                                      if (allNotesAsWidgets.isEmpty && pinnedNotes.isEmpty) Padding(
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
                    ),
                ],
              ),
            );
            default:
              devtools.log("future default");
              return const Text("");
          }
          
        }
      ),
      
    );
  }
}