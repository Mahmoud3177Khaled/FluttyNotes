import 'package:firstfluttergo/constants/curr_user_name.dart';
import 'package:firstfluttergo/constants/enumerations.dart';
import 'package:firstfluttergo/constants/routes.dart';
import 'package:firstfluttergo/services/CRUD/notes_service.dart';
import 'package:firstfluttergo/services/auth/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:firstfluttergo/constants/colors.dart';
import 'dart:developer' as devtools show log;


class UpdateNoteView extends StatefulWidget {
  const UpdateNoteView({super.key});

  @override
  State<UpdateNoteView> createState() => _UpdateNoteViewState();
}



class _UpdateNoteViewState extends State<UpdateNoteView> {

  late final TextEditingController _text;
  late final TextEditingController _title;

  String color = "0xFF000000";

  late final NotesService _notesService;

  String get userEmail => AuthService.firebase().currentUser!.email!;

  // ignore: unused_field
  DataBaseNote? _note;



  void showSentNodeText(DataBaseNote sentNote) {
    _text.text = sentNote.note_text;
    _title.text = sentNote.title_text;

  }

  Future<void> saveNote(DataBaseNote sentNote) async {
      
    final DataBaseNote updatedNote = await _notesService.updateNote(
      oldNote: sentNote,
      text: _text.text,
      title: _title.text,
      color: color
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
    _title = TextEditingController();
    _notesService = NotesService();
    _notesService.open();

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


    final sentNote = ModalRoute.of(context)?.settings.arguments as DataBaseNote?;
    // devtools.log(sentNote.toString());

    showSentNodeText(sentNote!);


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

        actions: [

          PopupMenuButton<ColorSelector>(

            onSelected: (value) async {

              devtools.log("This is $value");

              switch (value) {
                case ColorSelector.c1:
                  color = noteC1;
                  break;
                case ColorSelector.c2:
                  color = noteC2;
                  break;
                case ColorSelector.c3:
                  color = noteC3;
                  break;
                case ColorSelector.c4:
                  color = noteC4;
                  break;
                case ColorSelector.c5:
                  color = noteC5;
                  break;
                case ColorSelector.c6:
                  color = noteC6;
                  break;
                case ColorSelector.c7:
                  color = noteC7;
                  break;

                default:
              }
            }, 
            
            itemBuilder: (context) {
              return [

                PopupMenuItem<ColorSelector>(
                  value: ColorSelector.c1,
                  child: SizedBox(
                    width: 20,
                    height: 20, 
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(int.parse(noteC1)),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    )
                  )
                ),

                PopupMenuItem<ColorSelector>(
                  value: ColorSelector.c2,
                  child: SizedBox(
                    width: 20,
                    height: 20, 
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(int.parse(noteC2)),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    )
                  )
                ),

                PopupMenuItem<ColorSelector>(
                  value: ColorSelector.c3,
                  child: SizedBox(
                    width: 20,
                    height: 20, 
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(int.parse(noteC3)),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    )
                  )
                ),

                PopupMenuItem<ColorSelector>(
                  value: ColorSelector.c4,
                  child: SizedBox(
                    width: 20,
                    height: 20, 
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(int.parse(noteC4)),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    )
                  )
                ),
                PopupMenuItem<ColorSelector>(
                  value: ColorSelector.c5,
                  child: SizedBox(
                    width: 20,
                    height: 20, 
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(int.parse(noteC5)),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    )
                  )
                ),

                PopupMenuItem<ColorSelector>(
                  value: ColorSelector.c6,
                  child: SizedBox(
                    width: 20,
                    height: 20, 
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(int.parse(noteC6)),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    )
                  )
                ),

                PopupMenuItem<ColorSelector>(
                  value: ColorSelector.c7,
                  child: SizedBox(
                    width: 20,
                    height: 20, 
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(int.parse(noteC7)),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    )
                  )
                ),


              ];
              
            },
          ),

          FutureBuilder(
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
          )
              
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