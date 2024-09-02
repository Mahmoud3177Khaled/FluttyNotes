// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firstfluttergo/services/CRUD/cloud/cloud_note.dart';
import 'package:firstfluttergo/services/CRUD/cloud/cloud_storage_constants.dart';
import 'package:firstfluttergo/services/CRUD/cloud/cloud_storge_exceptions.dart';
import 'package:firstfluttergo/services/CRUD/cloud/cloud_tab.dart';
// import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FirestoreCloudNotesServices {

  final notes = FirebaseFirestore.instance.collection("notes");
  final usernames = FirebaseFirestore.instance.collection("usernames");
  final tabs = FirebaseFirestore.instance.collection("tabs");

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

      DateTime now = DateTime.now();
      String currentMonth = DateFormat('MMMM').format(DateTime.now());

      await notes.doc(noteId).update({
        note_text_field: newText,
        note_title_field: newTitle,
        color_field: newColor,
        font_color_field: newFontColor,
        last_modified_field: "${now.day} ${currentMonth.substring(0, 3)} at ${now.hour}:${now.minute}",
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


  Future<void> setUserName({required String userID, required String username}) async {
    await usernames.doc("allUserNames").update({
      userID: username
    });
  }

  Future<String> getUserName({required String userID}) async {
    return await usernames.where(
      userID
    ).get()
    .then((value) => value.docs[0].data()[userID],);
  }



  Stream<Iterable<CloudTab>> allTabsInStream ({required String ownerUserId}) {
    return tabs.snapshots().map((snapshot) => snapshot.docs.map((doc) => CloudTab.fromSnapshot(doc)).where((tab) => ((tab.user_id == ownerUserId)) || tab.name == "All Notes"));
  }
  
  Future<Iterable<CloudTab>> getAllTabsFor ({required String ownerUserId}) async {

    try {
      return await tabs.where(
        user_id_field,
        isEqualTo: ownerUserId
      )
      .get()
      .then((value) => value.docs.map((doc) {
          return CloudTab.fromSnapshot(doc);
        },),);

    } catch (e) {
      throw CouldNotGetAllNotesException();
    }


  }

  Future<void> createCloudTab ({required String ownerUserId, required String tabName, required String color, required String font_and_border_color}) async {

    await tabs.add({
      user_id_field: ownerUserId,
      name_field: tabName,
      color_field: color,
      font_and_border_color_field: font_and_border_color,
      num_of_notes_field: "0",
    });

  }

  Future<void> updateTab({required String tabId, required String newName, required String newColor, required String newFontAndBorderColor, required String newNumOfNotes}) async {

    try {

      await tabs.doc(tabId).update({
        name_field: newName,
        color_field: newColor,
        font_and_border_color_field: newFontAndBorderColor,
        num_of_notes_field: newNumOfNotes,
      });

    } catch (e) {
      throw CouldNotUpdateNoteException();
    }
  }

  Future<void> updateTabIncNum({required CloudTab tab}) async {

    try {

      await tabs.doc(tab.id).update({
        num_of_notes_field: (int.parse(tab.numOfNotes) + 1).toString(),
      });

    } catch (e) {
      throw CouldNotUpdateNoteException();
    }
  }

  Future<void> setAllNotesTabNum({required String tabId, required int num}) async {

    try {
      

      await tabs.doc(tabId).update({
        num_of_notes_field: num.toString(),
      });

    } catch (e) {
      throw CouldNotUpdateNoteException();
    }
  }


  Future<void> resetTabColor({required String ownerUserId, required String newColor, required String newFontAndBorderColor}) async {
    try {

      final docs = await tabs.get();

      for(final doc in docs.docs) {
        await tabs.doc(doc.id).update({
          color_field: newColor,
          font_and_border_color_field: newFontAndBorderColor,
        });
        
      }


    } catch (e) {
      throw CouldNotUpdateNoteException();
    }
  }

  Future<void> deleteTab({required String tabId}) async {
    try {
      await tabs.doc(tabId).delete();
    } catch (e) {
      throw CouldNotDeleteNoteException();
    }
  }




}