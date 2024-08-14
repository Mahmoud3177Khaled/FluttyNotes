import 'package:firstfluttergo/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:firstfluttergo/Globals/global_vars.dart';
import 'package:shared_preferences/shared_preferences.dart';



void switchModeOn() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  isDarkMode = true;

  prefs.setBool('isDarkMode', isDarkMode);
  
}

void switchModeoff() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  isDarkMode = false;

  prefs.setBool('isDarkMode', isDarkMode);
}



class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Settings"),
        backgroundColor: maintheme,
        foregroundColor: Colors.white,
      ),

      body: Column(
        children: [
          TextButton(
            child: const Text("Switch on"),
          
            onPressed: () {
              setState(() {
                switchModeOn();
                
              });
            },
          
          ),

          TextButton(
            child: const Text("Switch off"),
          
            onPressed: () {
              setState(() {
                switchModeoff();
                
              });
            },
          
          ),
        ],
      ),
    );
  }
}