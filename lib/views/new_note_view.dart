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
        text: _text.text,
        title: _title.text
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
        title: TextField(
            cursorColor: Colors.white,
            controller: _title,
            enableSuggestions: true,
            autocorrect: true,
            decoration: const InputDecoration(

              hintText: "Title",

              hintStyle: TextStyle(
                color: Colors.white70
              ),

              enabledBorder: InputBorder.none,

              focusedBorder: InputBorder.none,

            ),

            style: const TextStyle(
              color: Colors.white
            ),
            
        ),

        backgroundColor: maintheme,
        foregroundColor: Colors.white,

        // actions: [
          
        // ],
      ),

      backgroundColor: const Color.fromARGB(255, 255, 236, 179),

      body: Column(
          children: [

            TextField(
                autocorrect: true,
                autofocus: true,
                controller: _text,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                
                decoration: const InputDecoration(
                  hintText: 'Your note here',

                  enabledBorder: InputBorder.none,

                  focusedBorder: InputBorder.none,

                  filled: true,
                  fillColor: Color.fromARGB(255, 255, 236, 179),
                  
                )
              
              ),

          ],
        ),
    );
  }
}