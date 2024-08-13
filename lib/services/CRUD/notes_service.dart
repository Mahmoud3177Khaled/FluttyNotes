// import 'package:firebase_auth/firebase_auth.dart';
// ignore_for_file: constant_identifier_names, non_constant_identifier_names
import 'dart:developer' as devtools show log;
import 'dart:async';

import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path show join;
import 'package:firstfluttergo/services/CRUD/crud_expentions.dart';

// DateTime now = DateTime.now();


const dbName = "Notes.db";

const user_table = "User";
const notes_table = "Notes";

const idcolumn = 'id';
const emailcolumn = 'email';
const username_column = 'user_name';
const user_id_column = 'user_id';  
const note_title_column = 'title';  
const note_text_column = 'note_text';
const color_column = 'color';
const font_color_column = 'font_color';
const date_created_column = 'date_created';  
const last_modofied_column = 'last_modified';  
const is_synced_column = 'is_synced';

const userTableCommand = 

      ''' CREATE TABLE IF NOT EXISTS "User" (
          "id"	INTEGER NOT NULL,
          "email"	TEXT NOT NULL UNIQUE,
          "user_name"	TEXT NOT NULL,
          PRIMARY KEY("id" AUTOINCREMENT)
        );

      ''';

const notesTableCommand = 

      ''' CREATE TABLE IF NOT EXISTS "Notes" (
            "id"	INTEGER NOT NULL,
            "user_id"	INTEGER NOT NULL,
            "note_text"	TEXT,
            "date_created"	TEXT NOT NULL,
            "last_modified"	TEXT NOT NULL,
            "is_synced"	INTEGER DEFAULT 0,
            "title"	TEXT,
            "color"	TEXT,
            "font_color"	TEXT,
            PRIMARY KEY("id" AUTOINCREMENT),
            FOREIGN KEY("user_id") REFERENCES "User"("id")
          );

      ''';

class NotesService {

  Database? _db;

  List<DataBaseNote> _notes = [];
  final _notesStreamController = StreamController<List<DataBaseNote>>.broadcast();

  Stream<List<DataBaseNote>> get allNotes => _notesStreamController.stream;


  static final NotesService _onlyInstance = NotesService._sharedInctance();
  NotesService._sharedInctance();
  factory NotesService() => _onlyInstance;


  

  Future<void> cachNotes() async {
    final allNotes = await getAllNotes();
    _notes = allNotes.toList();
    _notesStreamController.add(_notes);

  }

  Future<void> cachNotesFor({required currUserEmail}) async {
    final allNotes = await getAllNotesFor(currUserEmail);
    _notes = allNotes.toList();
    _notesStreamController.add(_notes);
  }




  Future<void> open() async {

    if(_db != null) {
      return;
      // throw DbAlreadyOpenedException();
    }
    
    try {
      final docsPath = await getApplicationDocumentsDirectory();
      final dbPath = path.join(docsPath.path, dbName);

      _db = await openDatabase(dbPath);

      await _db?.execute(userTableCommand);
      await _db?.execute(notesTableCommand);

      _notesStreamController.add(_notes);

    } on MissingPlatformDirectoryException catch (_) {
      throw UnableTOGetDocumentDirectoryException();
    }
  }

  // Future<void> _ensureDbIsOpen() async {
  //   try {
  //     await open();
  //   } on DbAlreadyOpenedException {
  //     // empty
  //   }
  // }

  Future<void> close() async {

    if(_db == null) {
      throw NoOpenedDbException();
    }

    await _db?.close();

    _db = null;

  }

  Database? getCurrentDataBase() {
    if(_db == null) {
      throw NoOpenedDbException();

    } else {
      return _db ;

    }

  } 



Future<DataBaseUser> getOrCreateUser({required String email, required String username}) async {
  _db = getCurrentDataBase();

  try {
    final user = await getUser(email: email.toLowerCase());
    return user;


  } on NoSuchUserINDbException catch (_) {
    final user = await createUser(email: email.toLowerCase(), username: username);
    return user;

  } catch (_) {
    rethrow;

  }

}

  Future<DataBaseUser> createUser({required String email, required String username}) async {
    // await _ensureDbIsOpen();
    _db = getCurrentDataBase();

    final result = await _db?.query(user_table, limit: 1, where: "email = ?", whereArgs: [email.toLowerCase()]);

    if(result?.isNotEmpty ?? true) {
      devtools.log("from inside the create User service: ");
      devtools.log(email);
      throw UserAlreadtPresent;
    }

    final id = await _db?.insert(user_table, {emailcolumn: email.toLowerCase(), username_column: username});

    if(id != null)
    {
      DataBaseUser newuser = DataBaseUser(id: id, email: email, username: username);
      return newuser;
    } else {
      devtools.log("from inside the create User service: ");
      devtools.log(email);
      throw InsertionError();
    }



  }

  Future<int> deleteUser({required String email}) async {
    // await _ensureDbIsOpen();
    _db = getCurrentDataBase();

    final deletedCount = await _db?.delete(user_table, where: "email = ?", whereArgs: [email.toLowerCase()]);

    if(deletedCount == 0 || deletedCount == null) {
      throw CouldNotDeleteUser();

    } else {
      return deletedCount;

    }


  }

  Future<DataBaseUser> getUser({required String email}) async {
    // await _ensureDbIsOpen();
    _db = getCurrentDataBase();
    
    final result = await _db?.query(user_table, limit: 1, where: 'email = ?', whereArgs: [email.toLowerCase()]);

    if(result != null && result.isNotEmpty) {
      // final fetched_user = DataBaseUser(id: result[0][idcolumn] as int, email: result[0][idcolumn] as String);
      final fetched_user = DataBaseUser.fromRow(result.first);
      return fetched_user;

    } else {
      devtools.log("from inside the getUser service: ");
      devtools.log(email);
      throw NoSuchUserINDbException();

    }
  }



  Future<DataBaseNote> createNote({required DataBaseUser owner_user, required text, String title = "",
                                       String color = "0xFF93C0FE", String fontcolor = "0xFFFFFFFF"}) async {
    
    _db = getCurrentDataBase();

    DateTime now = DateTime.now();
    String currentMonth = DateFormat('MMMM').format(DateTime.now());

    final user = await getUser(email: owner_user.email);

    if(user != owner_user) {
      throw NoSuchUserINDbException();
    }


    final id = await _db?.insert(notes_table, {
      user_id_column: owner_user.id,
      note_title_column: title,
      note_text_column: text,
      color_column: color,
      font_color_column: fontcolor,
      date_created_column:  "${now.day} ${currentMonth.substring(0, 3)} at ${now.hour}:${now.minute}", // put real date later
      last_modofied_column: "Never",
    });

    if(id != null) {
      final newNote = DataBaseNote(
        id: id, user_id: owner_user.id, title_text: title, color: color, font_color: fontcolor,
        note_text: text, date_created: "${now.day} ${currentMonth.substring(0, 3)} at ${now.hour}:${now.minute}",
        last_modofied: "Never", is_synced: false
        );

        _notes.add(newNote);
        _notesStreamController.add(_notes);

        return newNote;

    } else {
      throw CouldNotMakeNoteException();
    }

  }

  Future<int> deleteNote({required DataBaseNote targetNote}) async {
    // await _ensureDbIsOpen();
    _db = getCurrentDataBase();

    final deletedCount = await _db?.delete(notes_table, where: 'id = ?', whereArgs: [targetNote.id]);

    if(deletedCount == 0 || deletedCount == null) {
      throw CouldNotDeleteNoteException();

    } else {
      _notes.removeWhere((note) => note == targetNote);
      _notesStreamController.add(_notes);

      return deletedCount;

    }
  }

  Future<int> burnAllNotes() async {
    // await _ensureDbIsOpen();
    _db = getCurrentDataBase();
    final deletedcount = await _db?.delete(notes_table);

    if(deletedcount == 0 || deletedcount == null) {
      throw NoNotesToDeleteException();
    } else {
      _notes.clear();
      _notesStreamController.add(_notes);

      return deletedcount;

    }
  }

  Future<DataBaseNote> getNote({required id}) async {
    // await _ensureDbIsOpen();
    _db = getCurrentDataBase();

    final result = await _db?.query(notes_table, limit: 1, where: 'id = ?', whereArgs: [id]);

    if((result?.isEmpty ?? true) || result == null) {
      throw CouldNotFindNoteException();
    } else {

      final note = DataBaseNote.fromRow(result.first);

      _notesStreamController.add(_notes);

      return note;
    }



  }

  Future<List<DataBaseNote>> getAllNotes() async {
    // await _ensureDbIsOpen();
    _db = getCurrentDataBase();
    final List<DataBaseNote> allNotes = [];

    final result = await _db?.query(notes_table);

    if((result?.isEmpty ?? true) || result == null) {
      throw NotASingleNoteInDb;
    } else {

      for (var row in result) {
        final note = DataBaseNote.fromRow(row);
        allNotes.add(note);
        // devtools.log(row.toString());  // <---- might need to remove that
      }

      return allNotes;

    }
  }

  Future<List<DataBaseNote>> getAllNotesFor(String currUserEmail) async {
    // await _ensureDbIsOpen();
    _db = getCurrentDataBase();

    final List<DataBaseNote> allNotes = [];
    final currUser = await getUser(email: currUserEmail);

    final result = await _db?.query(notes_table, where: "user_id = ?", whereArgs: [currUser.id]);

    if((result?.isEmpty ?? true) || result == null) {
      throw NotASingleNoteInDb;
    } else {

      for (var row in result) {
        final note = DataBaseNote.fromRow(row);
        allNotes.add(note);
        // devtools.log(row.toString());  // <---- might need to remove that
      }

      return allNotes;

    }
  }

  Future<DataBaseNote> updateNote({required DataBaseNote oldNote, required String text, String title = "",
                                   String color = "", String fontcolor = "0xFFFFFFFF"}) async {
    // await _ensureDbIsOpen();
    _db = getCurrentDataBase();

    DateTime now = DateTime.now();
    final currentMonth = DateFormat('MMMM').format(DateTime.now());

    final updatedCount =  await _db?.update(notes_table, {
      note_text_column: text,
      note_title_column: title,
      color_column: color,
      font_color_column:fontcolor,
      last_modofied_column: "${now.day} ${currentMonth.substring(0, 3)} at ${now.hour}:${now.minute}",
    }, 
    where: 'id = ?', 
    whereArgs: [oldNote.id],);

    if(updatedCount == 0 || updatedCount == null) {
      throw CouldNotFindNoteToUpdateException();

    } else {
      final newNote = await getNote(id: oldNote.id);

      _notes[_notes.indexWhere((note) => note.id == oldNote.id)] = newNote;
      _notesStreamController.add(_notes);

      return newNote;

    }

  }

}


class DataBaseUser {
  final int id;
  final String email;
  final String username;

  DataBaseUser({
     required this.id,
     required this.email,
     required this.username
    });


  DataBaseUser.fromRow(Map<String, Object?> map) : id = map[idcolumn] as int, email = map[emailcolumn] as String, username = map[username_column] as String;

  @override
  String toString() {
    return "{User} ... User_id: $id, email: $email"; 
  }

  @override
  bool operator == (covariant DataBaseUser other) {
    if(id == other.id) {
      return true;

    } else {
      return false;

    }
  }
  
  @override
  // TODO: implement hashCode
  int get hashCode => id.hashCode;
  

}

class DataBaseNote {

  final int id;
  final int user_id;
  final String title_text;
  final String note_text;
  final String color;
  final String font_color;
  final String date_created;
  final String last_modofied;
  final bool is_synced;
  
  

  DataBaseNote({
      required this.id,
      required this.user_id,
      required this.title_text,
      required this.note_text,
      required this.color,
      required this.font_color,
      required this.date_created,
      required this.last_modofied,
      required this.is_synced
    });


  // factory DataBaseNote.fromRow(Map<String, Object?> map) => DataBaseNote(id: 1, user_id: 1,note_text:'1',date_created: '1', last_modofied: '1', is_synced: true);

  DataBaseNote.fromRow(Map<String, Object?> map) :
    id = map[idcolumn] as int,
    user_id = map[user_id_column] as int,
    title_text = map[note_title_column] as String,
    note_text = map[note_text_column] as String,
    color = map[color_column] as String,
    font_color = map[font_color_column] as String,
    date_created = map[date_created_column] as String,
    last_modofied = map[last_modofied_column] as String,
    is_synced = (map[is_synced_column] as int) == 1 ? true : false;

    
  @override
  String toString() {
    return "{Note} ... id: $id, user_id: $user_id,  date_created: $date_created_column, last_modofied: $last_modofied_column,  is_synced: $is_synced_column, note_text: $note_text_column, ";
  }

  @override
  bool operator ==(covariant DataBaseNote other) {

    return other.id == id ? true : false;

  }
  
  @override
  int get hashCode => id.hashCode;
  

}
