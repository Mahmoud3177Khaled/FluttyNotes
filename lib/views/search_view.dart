// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:firstfluttergo/Globals/global_vars.dart';
import 'package:firstfluttergo/constants/colors.dart';
import 'package:firstfluttergo/constants/routes.dart';
import 'package:firstfluttergo/services/CRUD/notes_service.dart';
import 'package:firstfluttergo/services/auth/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'dart:developer' as devtools show log;

import 'package:shared_preferences/shared_preferences.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  
  late final TextEditingController _searchText;
  late final NotesService _notesService;
  bool? mode = false;
  List<Widget> matchedNotesAsWidgets = [];

  String get userEmail => AuthService.firebase().currentUser!.email;


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
    _searchText = TextEditingController();
    _notesService = NotesService();

    _notesService.open().then((_) => loadGlobalVariables());
    super.initState();
  }

  @override
  void dispose() {
    _searchText.dispose();
    // _notesService.close();

    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.fromLTRB(93, 0, 0, 0),
          child: Text(
            "Search",
            style: TextStyle(
              // fontFamily: 'Montserrat',
              fontWeight: FontWeight.bold,
              fontSize: 24
            ),  
          ),
        ),

        backgroundColor: Color(int.parse(backgroundColor)),
        foregroundColor: Color(int.parse(foregroundColor)),
        
      ),

      body: Expanded(
        child: SingleChildScrollView(
          child: Column(
            children: [
          
              Row(
                children: [
          
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SizedBox(
                      height: 50,
                      width: 330,
                      child: TextField(
                        cursorColor: maintheme,
                        controller: _searchText,
                        // autofocus: true,
                        onChanged: (value) async {

                          devtools.log("tick!");

                          matchedNotesAsWidgets = [];
                          final matchedDataBaseNotes = await _notesService.getAllNoteSatisfying(currUserEmail: userEmail, search_text: _searchText.text);
          
                          matchedDataBaseNotes.forEach((note) {
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
                                                  color: (note.pinned && (mode ?? false)) ? Colors.black : Color(int.parse(darknotefontcolor ?? note.font_color)),  // <---- be also from note
                                                  fontSize: 20, 
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
          
                                                
          
                                              ],
                                            ),
                                                                                                                  
                                          ],
                                        ),
                                      )
                                      
                                        
                                    ),
                                  ),
                                
                              ),
                            );
                             
                            if(_searchText.text != "") {         
                              matchedNotesAsWidgets.add(oneNote);      // يا كريم يا رب
                            }  
          
          
                          });

                          setState(() {
                            
                          });

                          devtools.log(matchedNotesAsWidgets.toString());
          
                        },

                        enableSuggestions: true,
                        autocorrect: true,
                        
                        
                        
                        decoration: InputDecoration(
                  
                          filled: true,
                          fillColor: (mode ?? false) ? const Color.fromARGB(255, 91, 91, 91) : const Color.fromARGB(255, 234, 224, 219),
                      
                          // hintText: "Enter your E-mail",
                      
                          hintText: "Search all your notes",
                          hintStyle: TextStyle(
                            color: !(mode ?? false) ? const Color.fromARGB(255, 91, 91, 91) : const Color.fromARGB(255, 234, 224, 219),
                          ),

                          floatingLabelStyle: const TextStyle(
                            color: maintheme
                          ),
                      
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                  
                      
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0)
                          )

                          
                        ),

                        style: TextStyle(color: (mode ?? false) ? const Color.fromARGB(255, 255, 255, 255) : const Color.fromARGB(255, 0, 0, 0),),

                      ),
                    ),
                  ),
                      
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: SizedBox(
                      // width: 30,
                      child: IconButton(
                        icon: Icon(
                          Icons.search, 
                          color: (mode ?? false) ? Colors.white : Colors.black
                        ),
                        onPressed: () {
          
                        },
                      )
                    ),
                  ),
                ],
              ),
          
              Text("---------------------------------------------------------------------------------------", 
                style: TextStyle(
                  color: Color(int.parse(foregroundColor))
                ),
              ),


              if (matchedNotesAsWidgets.isNotEmpty)
                StaggeredGrid.count(  
                  crossAxisCount: 2,
                  crossAxisSpacing: 0.0,
                  mainAxisSpacing: 0.0,
                
                  children: matchedNotesAsWidgets.toList(),
                
                ) else
               
                Text("No notes", 
                  style: TextStyle(
                  color: Color(int.parse(foregroundColor))
                ),
                )
          
            ],
          ),
        ),
      ),

      backgroundColor: Color(int.parse(backgroundColor)),

    );
  }
}