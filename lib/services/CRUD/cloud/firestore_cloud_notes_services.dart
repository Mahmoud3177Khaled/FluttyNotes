// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firstfluttergo/services/CRUD/cloud/cloud_note.dart';
import 'package:firstfluttergo/services/CRUD/cloud/cloud_storage_constants.dart';
import 'package:firstfluttergo/services/CRUD/cloud/cloud_storge_exceptions.dart';

class FirestoreCloudNotesServices {

  final notes = FirebaseFirestore.instance.collection("notes");

  static final FirestoreCloudNotesServices _onlyInstance = FirestoreCloudNotesServices._sharedInctance();
  FirestoreCloudNotesServices._sharedInctance();
  factory FirestoreCloudNotesServices() => _onlyInstance;


  Stream<Iterable<CloudNote>> allNotesInStream ({required String ownerUserId}) {
    return notes.snapshots().map((snapshot) => snapshot.docs.map((doc) => CloudNote.fromSnapshot(doc)).where((note) => note.user_id == ownerUserId));
  }
  
  Future<Iterable<CloudNote>> getAllNotesFor ({required String ownerUserId}) async {

    try {
      return await notes.where(
        user_id_field,
        isEqualTo: ownerUserId
      )
      .get()
      .then((value) => value.docs.map((doc) {
          return CloudNote.fromSnapshot(doc);
        },),);

    } catch (e) {
      throw CouldNotGetAllNotesException();
    }


  }


  Future<void> createCloudNote ({required String ownerUserId, required String note_text, required String note_title, required String color, required String font_color, required String date_created, required String last_modified, required bool pinned, required String category, }) async {

    await notes.add({
      user_id_field:  ownerUserId,
      note_text_field: note_text,  
      note_title_field: note_title,  
      color_field: color,  
      font_color_field: font_color,  
      date_created_field: date_created,
      last_modified_field: last_modified,  
      pinned_field: pinned ? "1" : "0",  
      category_field: category,  
    });

  }

  Future<void> updateNote({required String noteId, required String newText, required String newTitle, required String newColor, required String newFontColor, required bool pinned, required String category, }) async {

    try {

      await notes.doc(noteId).update({
        note_text_field: newText,
        note_title_field: newTitle,
        color_field: newColor,
        font_color_field: newFontColor,
        pinned_field: pinned ? "1" : "0",
        category_field: category,
      });

    } catch (e) {
      throw CouldNotUpdateNoteException();
    }
  }

  Future<void> deleteNote({required String noteId}) async {
    try {
      await notes.doc(noteId).delete();
    } catch (e) {
      throw CouldNotDeleteNoteException();
    }
  }
}