// ignore_for_file: non_constant_identifier_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firstfluttergo/services/CRUD/cloud/cloud_storage_constants.dart';
import 'package:flutter/material.dart';

@immutable
class CloudNote {
  final String id;
  final String user_id;
  final String note_text;
  final String note_title;
  final String color;
  final String font_color;
  final String date_created;
  final String last_modified;
  final bool pinned;
  final String category;

  const CloudNote({
    required this.id,
    required this.user_id, 
    required this.note_text, 
    required this.note_title, 
    required this.color, 
    required this.font_color, 
    required this.date_created, 
    required this.last_modified, 
    required this.pinned, 
    required this.category, 

  });

  CloudNote.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot) : 
  id = snapshot.id, 
  user_id = snapshot.data()[user_id_field] as String,
  note_text = snapshot.data()[note_text_field] as String,
  note_title = snapshot.data()[note_title_field] as String,
  color = snapshot.data()[user_id_field] as String,
  font_color = snapshot.data()[font_color_field] as String,
  date_created = snapshot.data()[date_created_field] as String,
  last_modified = snapshot.data()[last_modified_field] as String,
  pinned = snapshot.data()[pinned_field] == "1" ? true : false,
  category = snapshot.data()[category_field] as String;



  @override
  bool operator ==(covariant CloudNote other) {
    return id == other.id;
  }
  
  @override
  int get hashCode => id.hashCode;
  
}