// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firstfluttergo/services/CRUD/cloud/cloud_storage_constants.dart';
import 'package:flutter/foundation.dart';

@immutable
class CloudTab {
  final String id;
  final String name;
  final String color;
  final String fontAndBorderColor;
  final String? user_id;
  final String numOfNotes;

  const CloudTab({required this.color, required this.fontAndBorderColor, required this.id, required this.name, required this.user_id, required this.numOfNotes});

  CloudTab.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot) : 
  id = snapshot.id,
  name = snapshot.data()[name_field],
  color = snapshot.data()[color_field],
  fontAndBorderColor = snapshot.data()[font_and_border_color_field],
  user_id = snapshot.data()[user_id_field],
  numOfNotes = snapshot.data()[num_of_notes_field];


}