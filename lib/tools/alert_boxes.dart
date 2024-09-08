import 'package:flutter/material.dart';


// enum AppBarMenuActions { profile, settings, logout }

Future<void> showAlertBox(BuildContext context, {String? title, Widget? content, TextButton? opt1, TextButton? opt2})
async {
  return await showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title:  Text(
          title ?? "null",
          style: const TextStyle(
            color: Colors.white
          ),
        ),
        content:  content,
        actions: [

          opt1 ?? const Text(""),

          opt2 ?? const Text(""),

        ],
        backgroundColor: const Color.fromARGB(255, 20, 26, 28),
      );
    },
     
  ).then((value) => value);
}
