import 'package:firstfluttergo/services/CRUD/notes_service.dart';
import 'package:firstfluttergo/services/auth/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:firstfluttergo/constants/colors.dart';
import 'dart:developer' as devtools show log;

class NewNoteView extends StatefulWidget {
  const NewNoteView({super.key});

  @override
  State<NewNoteView> createState() => _NewNoteViewState();
}

class _NewNoteViewState extends State<NewNoteView> {
  late final TextEditingController _text;
  late final TextEditingController _title;

  String color = "0xFFFBB45E";
  String fontcolor = "0xFFFFFFFF";

  late final NotesService _notesService;
  String get userEmail => AuthService.firebase().currentUser!.email!;


  // ignore: unused_field
  DataBaseNote? _note;
  
  Future<void> saveNote() async {

    if(_text.text != "" || _title.text != "") {
      final DataBaseNote newNote = await _notesService.createNote(
        owner_user: await _notesService.getUser(
          email: userEmail,
        ), 
        text: _text.text,
        title: _title.text,
        color: color,
        fontcolor: fontcolor,
      );

      _note = newNote;
      devtools.log("Note id: ${newNote.id} Created");

      await _notesService.cachNotesFor(currUserEmail: userEmail);
    
    }
    
  }


  @override
  void initState() {
    _text = TextEditingController();
    _title = TextEditingController();
    _notesService = NotesService();
    _notesService.open();

    super.initState();
  }

  @override
  void dispose() {
    _text.dispose();
    _title.dispose();
    saveNote();
    // _notesService.close();

    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

    // final travellingUserName = ModalRoute.of(context)?.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        title: const Text(""),

        backgroundColor: Color(int.parse(color)),
        foregroundColor: Color(int.parse(fontcolor)),

        actions: [

          PopupMenuButton<String>(
            color: Colors.white,
            elevation: 11,

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusDirectional.circular(12),
              
            ),

            icon: const Icon(Icons.brush_outlined),

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
            color: Color(int.parse(fontcolor)),
            elevation: 11,

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusDirectional.circular(12),
              
            ),

            icon: const Icon(Icons.brush),

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
          
        ],
      ),

      backgroundColor: Color(int.parse(color)),

      body: Expanded(
        child: Padding(
          padding: const EdgeInsets.all(13.0),
          child: SingleChildScrollView(
            child: Column(
                children: [
                    TextField(
                      autocorrect: true,
                      enableSuggestions: true,
                      autofocus: true,
                      controller: _title,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      
                      decoration: InputDecoration(
                        hintText: 'Title',
            
                        hintStyle: TextStyle(
                          color: Color(int.parse(fontcolor))
                        ),
            
                        // labelText: "",
            
                        enabledBorder: InputBorder.none,
            
                        focusedBorder: InputBorder.none,
            
                        filled: true,
                        fillColor: Color(int.parse(color))
                        
                      ),
            
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w500,
                        color: Color(int.parse(fontcolor))
                      ),
                    
                    ),
            
                  TextField(
                      autocorrect: true,
                      enableSuggestions: true,
                      autofocus: true,
                      controller: _text,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      
                      decoration: InputDecoration(
                        hintText: 'Your note here',
            
                        hintStyle: TextStyle(
                          color: Color(int.parse(fontcolor))
                        ),
            
                        // labelText: "",
            
                        enabledBorder: InputBorder.none,
            
                        focusedBorder: InputBorder.none,
            
                        filled: true,
                        fillColor: Color(int.parse(color))
                        
                      ),
            
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        color: Color(int.parse(fontcolor))
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