// import 'package:firebase_auth/firebase_auth.dart';
// ignore_for_file: constant_identifier_names

import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path show join;
import 'package:firstfluttergo/services/CRUD/cerd_expentions.dart';


const dbName = "Notes.db";

const user_table = "User";
const notes_table = "Notes";

const idcolumn = 'id';
const emailcolumn = 'email';
const user_id_column = 'id';  
const note_text_column = 'text';  
const date_created_column = 'date_created';  
const last_modofied_column = 'last_modified';  
const is_synced_column = 'is_synced';

const userTableCommand = 

      ''' CREATE TABLE IF NOT EXISTS "User" (
            "id"	INTEGER NOT NULL,
            "email"	TEXT NOT NULL UNIQUE,
            PRIMARY KEY("id" AUTOINCREMENT)
          );

      ''';

const notesTableCommand = 

      ''' CREATE TABLE "Notes" (
            "id"	INTEGER NOT NULL,
            "user_id"	INTEGER NOT NULL,
            "note_text"	TEXT,
            "date_created"	TEXT NOT NULL,
            "last_modified"	TEXT NOT NULL,
            "is_synced"	INTEGER DEFAULT 0,
            PRIMARY KEY("id" AUTOINCREMENT),
            FOREIGN KEY("user_id") REFERENCES "User"("id")
          );

      ''';

class NotesService {
  Database? _db;

  Future<void> open() async {

    if(_db != null) {
      throw DbAlreadyOpenedException;
    }
    
    try {
      final docsPath = await getApplicationDocumentsDirectory();
      final dbPath = path.join(docsPath.path, dbName);

      _db = await openDatabase(dbPath);

      await _db?.execute(userTableCommand);
      await _db?.execute(notesTableCommand);

    } on MissingPlatformDirectoryException catch (_) {
      throw UnableTOGetDocumentDirectoryException;
    }
  }

  Future<void> close() async {

    if(_db == null) {
      throw NoOpenedDbException;
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



  Future<DataBaseUser> createUser({required String email}) async {
    _db = getCurrentDataBase();

    final result = await _db?.query(user_table, limit: 1, where: "email = ?", whereArgs: [email.toLowerCase()]);

    if(result?.isNotEmpty ?? true) {
      throw UserAlreadtPresent;
    }

    final id = await _db?.insert(user_table, {emailcolumn: email.toLowerCase()});

    if(id != null)
    {
      DataBaseUser newuser = DataBaseUser(id: id, email: email);
      return newuser;
    } else {
      throw InsertionError();
    }



  }

  Future<int> deleteUser({required String email}) async {
    _db = getCurrentDataBase();

    final deletedCount = await _db?.delete(user_table, where: "email = ?", whereArgs: [email.toLowerCase()]);

    if(deletedCount == 0 || deletedCount == null) {
      throw CouldNotDeleteUser;

    } else {
      return deletedCount;

    }


  }

  Future<DataBaseUser> getUser({required String email}) async {
    _db = getCurrentDataBase();
    
    final result = await _db?.query(user_table, limit: 1, where: 'email = ?', whereArgs: [email.toLowerCase()]);

    if(result != null && result.isNotEmpty) {
      // final fetched_user = DataBaseUser(id: result[0][idcolumn] as int, email: result[0][idcolumn] as String);
      final fetched_user = DataBaseUser.fromRow(result.first);
      return fetched_user;

    } else {
      throw NoSuchUserINDbException;

    }
  }



  Future<DataBaseNote> createNote({required DataBaseUser owner_user}) async {
    _db = getCurrentDataBase();

    // final result = await _db?.query(user_table, limit: 1, where: "id = ?", whereArgs: [owner_user.id]);

    // if(result == null || result.isEmpty) {
    //   throw NoSuchUserINDbException;
    // }

    final user = await getUser(email: owner_user.email);

    if(user != owner_user) {
      throw NoSuchUserINDbException;
    }

    final text = '';

    final id = await _db?.insert(notes_table, {
      user_id_column: owner_user.id,
      note_text_column: text,
      date_created_column: "Today", // put real date later
      last_modofied_column: "2 mins ago",
    });

    if(id != null) {
      final newNote = DataBaseNote(
        id: id, user_id: owner_user.id,
        note_text: text, date_created: "Today",
        last_modofied: "2 mins ago", is_synced: false);

        return newNote;

    } else {
      throw CouldNotMakeNoteException;
    }

  }

  Future<int> deleteNote({required noteId}) async {
    _db = getCurrentDataBase();

    final deletedCount = await _db?.delete(notes_table, where: 'id = ?', whereArgs: [noteId]);

    if(deletedCount == 0 || deletedCount == null) {
      throw CouldNotDeleteNoteException;

    } else {
      return deletedCount;

    }
  }

  Future<int> burnAllNotes() async {
    _db = getCurrentDataBase();
    final deletedcount = await _db?.delete(notes_table);

    if(deletedcount == 0 || deletedcount == null) {
      throw NoNotesToDeleteException;
    } else {
      return deletedcount;

    }
  }

  Future<DataBaseNote> getNote({required id}) async {
    _db = getCurrentDataBase();

    final result = await _db?.query(notes_table, limit: 1, where: 'id = ?', whereArgs: [id]);

    if((result?.isEmpty ?? true) || result == null) {
      throw CouldNotFindNoteException;
    } else {

      final note = DataBaseNote.fromRow(result.first);

      return note;
    }



  }

  Future<List<DataBaseNote>> getAllNotes() async {
    _db = getCurrentDataBase();
    final List<DataBaseNote> allNotes = [];

    final result = await _db?.query(notes_table);

    if((result?.isEmpty ?? true) || result == null) {
      throw NotASingleNoteInDb;
    } else {
      for (var row in result) {
        
        final note = DataBaseNote.fromRow(row);
        allNotes.add(note);
        
      }

      return allNotes;

    }
  }

  Future<DataBaseNote> updateNote({required DataBaseNote oldNote, required String text}) async {
    _db = getCurrentDataBase();

    final updatedCount =  await _db?.update(notes_table, {
      note_text_column: text
    }, 
    where: 'id = ?', 
    whereArgs: [oldNote.id],);

    if(updatedCount == 0 || updatedCount == null) {
      throw CouldNotFindNoteToUpdateException;

    } else {
      final newNote = getNote(id: oldNote.id);
      return newNote;

    }

  }

}


class DataBaseUser {
  final int id;
  final String email;

  DataBaseUser({
     required this.id,
     required this.email
    });


  DataBaseUser.fromRow(Map<String, Object?> map) : id = map[idcolumn] as int, email = map[emailcolumn] as String;

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
  final String note_text;
  final String date_created;
  final String last_modofied;
  final bool is_synced;
  
  

  DataBaseNote({
      required this.id,
      required this.user_id,
      required this.note_text,
      required this.date_created,
      required this.last_modofied,
      required this.is_synced
    });


  // factory DataBaseNote.fromRow(Map<String, Object?> map) => DataBaseNote(id: 1, user_id: 1,note_text:'1',date_created: '1', last_modofied: '1', is_synced: true);

  DataBaseNote.fromRow(Map<String, Object?> map) :
    id = map[idcolumn] as int,
    user_id = map[user_id_column] as int,
    note_text = map[note_text_column] as String,
    date_created = map[date_created_column] as String,
    last_modofied = map[last_modofied_column] as String,
    is_synced = (map[is_synced_column] as int) == 1 ? true : false;

    
  @override
  String toString() {
    return "{Note} ... id: $id, user_id: $user_id, " +
    " date_created: $date_created_column, last_modofied: $last_modofied_column," +
    "  is_synced: $is_synced_column, note_text: $note_text_column, ";
  }

  @override
  bool operator ==(covariant DataBaseNote other) {

    return other.id == id ? true : false;

  }
  
  @override
  // TODO: implement hashCode
  int get hashCode => id.hashCode;
  

}
