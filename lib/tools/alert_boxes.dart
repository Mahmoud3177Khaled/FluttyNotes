// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firstfluttergo/constants/routes.dart';
import 'package:flutter/material.dart';


enum AppBarMenuActions { profile, settings, logout }

Future<bool> showAlertBox(BuildContext context, {String? title, String? content, TextButton? opt1})
{
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title:  Text(title ?? "null"),
        content:  Text(content ?? "null"),
        actions: [

          opt1 ?? const Text(""),

        ],
      );
    },
  ).then((value) => value ?? false);
}
