import 'package:firstfluttergo/constants/curr_user_name.dart';
// import 'package:firstfluttergo/constants/enumerations.dart';
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
  String fontcolor = "0xFFFFFFFF";

  late final NotesService _notesService;

  String get userEmail => AuthService.firebase().currentUser!.email!;

  // ignore: unused_field
  DataBaseNote? _note;

  bool hasRunOnce = false;

  void showSentNodeText(DataBaseNote sentNote) {
    if(hasRunOnce == false) {
      _text.text = sentNote.note_text;
      _title.text = sentNote.title_text;
      color = sentNote.color;
      fontcolor = sentNote.font_color;

      hasRunOnce = true;

    }
  }

  Future<void> saveNote(DataBaseNote sentNote) async {

    if(color == "0xFF000000") {
      color = (await _notesService.getNote(id: sentNote.id)).color;
    }
      
    final DataBaseNote updatedNote = await _notesService.updateNote(
      oldNote: sentNote,
      text: _text.text,
      title: _title.text,
      color: color,
      fontcolor: fontcolor,
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
    showSentNodeText(sentNote!);
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   });
    // devtools.log(sentNote.toString());



    return Scaffold(
      appBar: AppBar(
        title: const Text(""),
        backgroundColor: Color(int.parse(color)),
        foregroundColor: Color(int.parse(fontcolor)),

        actions: [

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
                      child: TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: Color(int.parse(fontcolor)),
                            backgroundColor: Color(int.parse(color)),
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
                                  foregroundColor: Color(int.parse(color)),
                                  backgroundColor: Color(int.parse(fontcolor)),
                                  shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                              ),
          
                              side: BorderSide(
                                  color: Color(int.parse(color)),
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

      backgroundColor: Color(int.parse(color)),

      body: Column(
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
                    color: Color(int.parse(fontcolor))
                  ),
              
                  enabledBorder: InputBorder.none,

                  focusedBorder: InputBorder.none,

                  filled: true,
                  fillColor: Color(int.parse(color)),
                  
                ),

                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w600,
                  color: Color(int.parse(fontcolor))
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
                    color: Color(int.parse(fontcolor))
                  ),
              
                  enabledBorder: InputBorder.none,

                  focusedBorder: InputBorder.none,

                  filled: true,
                  fillColor: Color(int.parse(color)),
                  
                ),

                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color(int.parse(fontcolor))
                ),
              
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(250, 15, 0, 0),
                child: Text(
                  "Cr: ${sentNote.date_created}",
                  style: TextStyle(
                    color: Color(int.parse(fontcolor)),  // <---- be also from note
                    fontSize: 10, 
                    fontWeight: FontWeight.w500
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(250, 0, 0, 10),
                child: Text(
                  "Ed: ${sentNote.last_modofied}",
                  style: TextStyle(
                    color: Color(int.parse(fontcolor)), // <---- be also from note
                    fontSize: 10, 
                    fontWeight: FontWeight.w500
                  ),
                ),
              ),
            
          ],
        ),
      
    );
  }
}