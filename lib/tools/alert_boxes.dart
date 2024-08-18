import 'package:flutter/material.dart';


// enum AppBarMenuActions { profile, settings, logout }

Future<bool> showAlertBox(BuildContext context, {String? title, Widget? content, TextButton? opt1, TextButton? opt2})
{
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title:  Text(title ?? "null"),
        content:  content,
        actions: [

          opt1 ?? const Text(""),

          opt2 ?? const Text(""),

        ],
      );
    },
  ).then((value) => value ?? false);
}
