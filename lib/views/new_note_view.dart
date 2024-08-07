import 'package:firstfluttergo/services/CRUD/notes_service.dart';
import 'package:firstfluttergo/services/auth/auth_services.dart';
// import 'package:firstfluttergo/tools/alert_boxes.dart';
// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firstfluttergo/constants/colors.dart';
import 'dart:developer' as devtools show log;
// import 'package:firstfluttergo/views/homepage_view.dart';

class NewNoteView extends StatefulWidget {
  const NewNoteView({super.key});

  @override
  State<NewNoteView> createState() => _NewNoteViewState();
}

class _NewNoteViewState extends State<NewNoteView> {
  late final TextEditingController _text;

  late final NotesService _notesService;
  String get userEmail => AuthService.firebase().currentUser!.email!;


  // ignore: unused_field
  DataBaseNote? _note;
  
  Future<void> saveNote() async {

    if(_text.text != "") {
      final DataBaseNote newNote = await _notesService.createNote(
        owner_user: await _notesService.getUser(
          email: userEmail,
        ), 
        text: _text.text
      );

      _note = newNote;
      devtools.log("Note id: ${newNote.id} Created");

      await _notesService.cachNotes();
    
    }
    
  }


  @override
  void initState() {
    _text = TextEditingController();
    _notesService = NotesService();
    _notesService.open();

    super.initState();
  }

  @override
  void dispose() {
    _text.dispose();
    saveNote();
    // _notesService.close();

    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // devtools.log(userEmail);
      // final DataBaseUser dbUser = await _notesService.getUser(email: userEmail);
      // devtools.log(dbUser.email);


      // await _notesService.getAllNotes();

      },              
    );


    return Scaffold(
      appBar: AppBar(
        title: const Text("Create new note"),
        backgroundColor: maintheme,
        foregroundColor: Colors.white,
      ),

      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            SizedBox(
              width: 385,
              child: TextField(
                autocorrect: true,
                autofocus: true,
                controller: _text,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                
                decoration: const InputDecoration(
                  hintText: 'Your note here',
              
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12.0)),
                    borderSide: BorderSide(color: maintheme, width: 2.0),
                  ),
              
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12.0)),
                    borderSide: BorderSide(color: maintheme, width: 2.0),
                  ),
              
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12.0)),
                    borderSide: BorderSide(color: maintheme, width: 2.0),
                  ),

                  filled: true,
                  fillColor: Color.fromARGB(255, 255, 236, 179),
                  
                )
              
              ),
            ),

          ],
        ),
      ),
    );
  }
}