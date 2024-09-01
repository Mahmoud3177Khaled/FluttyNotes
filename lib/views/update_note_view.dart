// ignore_for_file: use_build_context_synchronously

import 'package:firstfluttergo/Globals/global_vars.dart';
import 'package:firstfluttergo/constants/routes.dart';
import 'package:firstfluttergo/services/CRUD/cloud/cloud_note.dart';
import 'package:firstfluttergo/services/CRUD/cloud/firestore_cloud_notes_services.dart';
// import 'package:firstfluttergo/services/CRUD/notes_service.dart';
import 'package:firstfluttergo/services/auth/auth_services.dart';
import 'package:firstfluttergo/tools/alert_boxes.dart';
import 'package:flutter/material.dart';
import 'package:firstfluttergo/constants/colors.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:developer' as devtools show log;

import 'package:shared_preferences/shared_preferences.dart';


class UpdateNoteView extends StatefulWidget {
  const UpdateNoteView({super.key});

  @override
  State<UpdateNoteView> createState() => _UpdateNoteViewState();
}



class _UpdateNoteViewState extends State<UpdateNoteView> {

  late final TextEditingController _text;
  late final TextEditingController _title;

  String color = "0xFF000000";
  String fontcolor = "0xFFFFFFFF";

  late final FirestoreCloudNotesServices _cloudNotesService;

  late final String userID; 

  // ignore: unused_field
  CloudNote? _note;

  bool hasRunOnce = false;
  bool? mode = false;


  Future<void> loadGlobalVariables() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // String? savedUsername = prefs.getString('userNameInGlobal');
    
      // final user = await _notesService.getUser(email: userEmail);
      setState(() {
        // userNameInGlobal = user.username;
        // prefs.setString('userNameInGlobal', userNameInGlobal);
        // prefs.setBool('isDarkMode', isDarkMode);

        mode = prefs.getBool('isDarkMode');

        if(mode ?? false) {
          
          // backgroundColor = "0xFF000000";
          // foregroundColor = "0xFFe5e5e5";
          darknotecolor = "0xFF1b1b1b";
          darknotefontcolor = "0xFFe5e5e5";
          devtools.log("Nighmode on");
            
        } else {
          // backgroundColor = "0xFFe5e5e5";
          // foregroundColor = "0xFF000000";
          darknotecolor = null;
          darknotefontcolor = null;
          devtools.log("Nighmode off");
        }
    
      });
  }

  void showSentNodeText(CloudNote sentNote) {
    if(hasRunOnce == false) {
      _text.text = sentNote.note_text;
      _title.text = sentNote.note_title;
      color = sentNote.color;
      fontcolor = sentNote.font_color;

      hasRunOnce = true;

    }
  }

  Future<void> saveNote(CloudNote sentNote) async {

    if(color == "0xFF000000") {
      color = sentNote.color;
    }
      
    await _cloudNotesService.updateNote(noteId: sentNote.id, newText: _text.text, newTitle: _title.text, newColor: color, newFontColor: fontcolor, pinned: sentNote.pinned, category: sentNote.category);

    devtools.log("Note id: ${sentNote.id} updated");
  }

  Future<void> deleteNote(CloudNote sentNote) async {
    await _cloudNotesService.deleteNote(noteId: sentNote.id);

    devtools.log("Note id: ${sentNote.id} deleted");
    _note = null;

    // return deletedCount;
  }


  @override
  void initState() {
    _text = TextEditingController();
    _title = TextEditingController();
    _cloudNotesService = FirestoreCloudNotesServices();
    // _notesService.open();

    userID = AuthService.firebase().currentUser!.id;


    super.initState();
  }

  @override
  void dispose() {
    _text.dispose();
    _title.dispose();
    // saveNote();
    // _notesService.close();

    super.dispose();
  }



  @override
  Widget build(BuildContext context) {


    final sentNote = ModalRoute.of(context)?.settings.arguments as CloudNote?;
    showSentNodeText(sentNote!);
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   });
    // devtools.log(sentNote.toString());



    return Scaffold(
      appBar: AppBar(
        title: const Text(""),
        backgroundColor: Color(int.parse(darknotecolor ?? color)),
        foregroundColor: Color(int.parse(darknotefontcolor ?? fontcolor)),

        actions: [

          IconButton(
            onPressed: () {
              if(_text.text == "") {
                showAlertBox(
                  context, 
                  title: "Sharing",
                  content: const Text(
                    "Can not share a note with empty text",
                    style: TextStyle(
                      color: Colors.white
                    ),  
                  ),
                  opt1: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    }, 
                    child: const Text(
                      "Ok",
                      style: TextStyle(
                        color: maintheme
                      ),  
                    )
                  )  
                );
                return;
              }

              String sharedString = "${_title.text} \n\n${_text.text}";

              Share.share(sharedString);
            }, 
            icon: const Icon(Icons.share)
            
          ),

          PopupMenuButton<String>(
            icon: const Icon(Icons.brush_outlined),
            color: Color(int.parse(fontcolor)),
            elevation: 11,

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusDirectional.circular(12),
              
            ),


            onSelected: (value) async {
              devtools.log("This is $value");

              setState(() {
                fontcolor = value;
                
              });

            }, 
            
            itemBuilder: (context) {
              return [

                PopupMenuItem<String>(
                  value: fontcolor1,
                  child: SizedBox(
                    width: 20,
                    height: 20, 
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(int.parse(fontcolor1)),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.black,
                          width: 1,
                        )
                      ),
                    )
                  )
                ),

                PopupMenuItem<String>(
                  value: fontcolor2,
                  child: SizedBox(
                    width: 20,
                    height: 20, 
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(int.parse(fontcolor2)),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.black,
                          width: 1,
                        )
                      ),
                    )
                  )
                ),

              ];
              
            },
          ),

          PopupMenuButton<String>(
            icon: const Icon(Icons.brush),
            color: Color(int.parse(fontcolor)),
            elevation: 11,

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusDirectional.circular(12),
              
            ),


            onSelected: (value) async {
              devtools.log("This is $value");

              setState(() {
                color = value;
                
              });


            }, 
            
            itemBuilder: (context) {
              return [

                PopupMenuItem<String>(
                  value: noteC1,
                  child: SizedBox(
                    width: 20,
                    height: 20, 
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(int.parse(noteC1)),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.black,
                          width: 1,
                        )
                      ),
                    )
                  )
                ),

                PopupMenuItem<String>(
                  value: noteC2,
                  child: SizedBox(
                    width: 20,
                    height: 20, 
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(int.parse(noteC2)),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.black,
                          width: 1,
                        )
                      ),
                    )
                  )
                ),

                PopupMenuItem<String>(
                  value: noteC3,
                  child: SizedBox(
                    width: 20,
                    height: 20, 
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(int.parse(noteC3)),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.black,
                          width: 1,
                        )
                      ),
                    )
                  )
                ),

                PopupMenuItem<String>(
                  value: noteC4,
                  child: SizedBox(
                    width: 20,
                    height: 20, 
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(int.parse(noteC4)),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.black,
                          width: 1,
                        )
                      ),
                    )
                  )
                ),
                
                PopupMenuItem<String>(
                  value: noteC5,
                  child: SizedBox(
                    width: 20,
                    height: 20, 
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(int.parse(noteC5)),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.black,
                          width: 1,
                        )
                      ),
                    )
                  )
                ),

                PopupMenuItem<String>(
                  value: noteC6,
                  child: SizedBox(
                    width: 20,
                    height: 20, 
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(int.parse(noteC6)),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.black,
                          width: 1,
                        )
                      ),
                    )
                  )
                ),

                PopupMenuItem<String>(
                  value: noteC7,
                  child: SizedBox(
                    width: 20,
                    height: 20, 
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(int.parse(noteC7)),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.black,
                          width: 1,
                        )
                      ),
                    )
                  )
                ),

                PopupMenuItem<String>(
                  value: noteC8,
                  child: SizedBox(
                    width: 20,
                    height: 20, 
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(int.parse(noteC8)),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.black,
                          width: 1,
                        )
                      ),
                    )
                  )
                ),


              ];
              
            },
          ),

          FutureBuilder(
            future: AuthService.firebase().initializeApp(),
            builder: (context, snapshot) {

              switch (snapshot.connectionState) {
                case ConnectionState.done:
                  return Row(
                    children: [
          
                      Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: Color(int.parse(darknotefontcolor ?? fontcolor)),
                            backgroundColor: Color(int.parse(darknotecolor ?? color)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                                  
                          onPressed: () async {
                              await deleteNote(sentNote);
                      
                              Navigator.of(context).pushNamedAndRemoveUntil(homepage, (route) => false,);
                          },
                                  
                          // icon: const Icon(Icons.delete),
                          child: const Text("Delete"),
          
                          
                        ),
                      
                    ),
          
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
                      child: TextButton(

                          style: TextButton.styleFrom(
                                  foregroundColor: Color(int.parse(darknotecolor ?? color)),
                                  backgroundColor: Color(int.parse(darknotefontcolor ?? fontcolor)),
                                  shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                              ),
          
                              side: BorderSide(
                                  color: Color(int.parse(darknotecolor ?? color)),
                                  width: 3
                            ), 
                              ),
                          
                                  
                          onPressed: () async {
                            await saveNote(sentNote);
                      
                            Navigator.of(context).pushNamedAndRemoveUntil(homepage, (route) => false,);
                          },
                                  
                          // icon: const Icon(Icons.save),
                          child: const Text("Save"),
                        ),
                      
                    ),
          
                    ],
                  );       
          
                default:
                  return const CircularProgressIndicator();
              }
            },
          )
              
        ],
      ),

      backgroundColor: Color(int.parse(darknotecolor ?? color)),

      body: Expanded(
        child: Padding(
          padding: const EdgeInsets.all(13.0),
          child: SingleChildScrollView(
            child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
            
                  TextField(
                      autocorrect: true,
                      autofocus: true,
                      enableSuggestions: true,
                      controller: _title,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      
                      decoration: InputDecoration(
                        hintText: 'Title',
            
                        hintStyle: TextStyle(
                          fontFamily: 'Poppins',
                          // fontWeight: FontWeight.bold,

                          color: Color(int.parse(darknotefontcolor ?? fontcolor))
                        ),
                    
                        enabledBorder: InputBorder.none,
            
                        focusedBorder: InputBorder.none,
            
                        filled: true,
                        fillColor: Color(int.parse(darknotecolor ?? color)),
                        
                      ),
            
                      style: TextStyle(
                        fontSize: 37,
                        fontFamily: 'Poppins',
                        // fontWeight: FontWeight.bold,
                        color: Color(int.parse(darknotefontcolor ?? fontcolor))
                      ),
                    
                    ),
            
                  TextField(
                      autocorrect: true,
                      autofocus: true,
                      enableSuggestions: true,
                      controller: _text,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      
                      decoration: InputDecoration(
                        hintText: 'Your note here',
            
                        hintStyle: TextStyle(
                          fontFamily: 'Raleway',
                          fontWeight: FontWeight.w900,

                          color: Color(int.parse(darknotefontcolor ?? fontcolor))
                        ),
                    
                        enabledBorder: InputBorder.none,
            
                        focusedBorder: InputBorder.none,
            
                        filled: true,
                        fillColor: Color(int.parse(darknotecolor ?? color)),
                        
                      ),
            
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Raleway',
                        fontWeight: FontWeight.w900,
                        color: Color(int.parse(darknotefontcolor ?? fontcolor))
                      ),
                    
                    ),
            
                    Padding(
                      padding: const EdgeInsets.fromLTRB(250, 15, 0, 0),
                      child: Text(
                        "Cr: ${sentNote.date_created}",
                        style: TextStyle(
                          color: Color(int.parse(darknotefontcolor ?? fontcolor)),  // <---- be also from note
                          fontSize: 10, 
                          fontWeight: FontWeight.w500
                        ),
                      ),
                    ),
            
                    Padding(
                      padding: const EdgeInsets.fromLTRB(250, 0, 0, 10),
                      child: Text(
                        "Ed: ${sentNote.last_modified}",
                        style: TextStyle(
                          color: Color(int.parse(darknotefontcolor ?? fontcolor)), // <---- be also from note
                          fontSize: 10, 
                          fontWeight: FontWeight.w500
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