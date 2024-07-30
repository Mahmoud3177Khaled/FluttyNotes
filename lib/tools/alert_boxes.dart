import 'package:firebase_auth/firebase_auth.dart';
import 'package:firstfluttergo/constants/routes.dart';
import 'package:flutter/material.dart';


enum AppBarMenuActions { profile, settings, logout }

Future<bool> showLogoutAlert(BuildContext context)
{
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Alert!"),
        content: const Text("Are you sure you want to logout?"),
        actions: [

          TextButton(onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: const Text("Cancel")),

          TextButton(onPressed: () async {
            await FirebaseAuth.instance.signOut();
            Navigator.of(context).pushNamedAndRemoveUntil(welcomeview, (route) => false);
          },
          child: const Text("Confirm")),

        ],
      );
    },
  ).then((value) => value ?? false);
}
