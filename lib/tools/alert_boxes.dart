// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firstfluttergo/constants/routes.dart';
import 'package:flutter/material.dart';


// enum AppBarMenuActions { profile, settings, logout }

Future<bool> showAlertBox(BuildContext context, {String? title, Widget? content, TextButton? opt1, String? tabTitle})
{
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title:  Text(title ?? "null"),
        content:  content,
        actions: [

          opt1 ?? const Text(""),

        ],
      );
    },
  ).then((value) => value ?? false);
}
