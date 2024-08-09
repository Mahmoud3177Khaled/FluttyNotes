import 'package:firstfluttergo/constants/curr_user_name.dart';
import 'package:firstfluttergo/constants/routes.dart';
import 'package:firstfluttergo/services/CRUD/notes_service.dart';
import 'package:firstfluttergo/services/auth/auth_services.dart';
// import 'package:firstfluttergo/tools/alert_boxes.dart';
// import 'package:firstfluttergo/tools/alert_boxes.dart';
// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firstfluttergo/constants/colors.dart';
import 'dart:developer' as devtools show log;
// import 'package:firstfluttergo/views/homepage_view.dart';



class UpdateNoteView extends StatefulWidget {
  const UpdateNoteView({super.key});

  @override
  State<UpdateNoteView> createState() => _UpdateNoteViewState();
}



class _UpdateNoteViewState extends State<UpdateNoteView> {

  late final TextEditingController _text;
  late final NotesService _notesService;

  String get userEmail => AuthService.firebase().currentUser!.email!;

  // ignore: unused_field
  DataBaseNote? _note;



  void showSentNodeText(DataBaseNote sentNote) {
    _text.text = sentNote.note_text;

  }

  Future<void> saveNote(DataBaseNote sentNote) async {
      
    final DataBaseNote updatedNote = await _notesService.updateNote(
      oldNote: sentNote,
      text: _text.text,
    );

    _note = updatedNote;

    // devtools.log(_note.toString());
    // devtools.log(_note!.note_text);
    devtools.log("Note id: ${sentNote.id} updated");

    await _notesService.cachNotesFor(currUserEmail: userEmail);

  }

  Future<int> deleteNote(DataBaseNote sentNote) async {
    final deletedCount = await _notesService.deleteNote(targetNote: sentNote);

    devtools.log("Note id: ${sentNote.id} deleted");
    _note = null;

    return deletedCount;
  }


  @override
  void initState() {
    _text = TextEditingController();
    _notesService = NotesService();
    // _notesService.open();

    super.initState();
  }

  @override
  void dispose() {
    _text.dispose();
    // saveNote();
    // _notesService.close();

    super.dispose();
  }



  @override
  Widget build(BuildContext context) {


    final sentNote = ModalRoute.of(context)?.settings.arguments as DataBaseNote?;
    // devtools.log(sentNote.toString());

    showSentNodeText(sentNote!);


    return Scaffold(
      appBar: AppBar(
        title: const Text("Update Your note"),
        backgroundColor: maintheme,
        foregroundColor: Colors.white,

        actions: [
          FutureBuilder(
              future: _notesService.open(),
              builder: (context, snapshot) {

                return FutureBuilder(
                  future: _notesService.getOrCreateUser(email: userEmail, username: userNameInGlobal),
                  builder: (context, snapshot) {

                    switch (snapshot.connectionState) {
                      case ConnectionState.done:
                        return Row(
                          children: [
                
                            Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: IconButton(
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: maintheme,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(7),
                                  ),
                                ),
                                        
                                onPressed: () async {
                                   await deleteNote(sentNote);
                            
                                   Navigator.of(context).pushNamedAndRemoveUntil(homepage, (route) => false,);
                                },
                                        
                                icon: const Icon(Icons.delete),
                
                                
                              ),
                            
                          ),
                
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: IconButton(

                                style: TextButton.styleFrom(
                                        foregroundColor: maintheme,
                                        backgroundColor: const Color.fromARGB(255, 255, 251, 255),
                                        shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(7),
                                    ),
                
                                    side: const BorderSide(
                                        color: maintheme,
                                        width: 3
                                  ), 
                                    ),
                                
                                        
                                onPressed: () async {
                                  await saveNote(sentNote);
                            
                                  Navigator.of(context).pushNamedAndRemoveUntil(homepage, (route) => false,);
                                },
                                        
                                icon: const Icon(Icons.save),
                              ),
                            
                          ),
                
                          ],
                        );       
                
                      default:
                        return const CircularProgressIndicator();
                    }
                  },
                );
              }
            ),
        ],
      ),

      backgroundColor: const Color.fromARGB(255, 255, 236, 179),

      body: Column(
          mainAxisSize: MainAxisSize.min,
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