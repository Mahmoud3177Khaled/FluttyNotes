import 'package:firstfluttergo/main.dart';
import 'package:flutter/material.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Settings"),
        backgroundColor: maintheme,
        foregroundColor: Colors.white,
      ),
    );
  }
}