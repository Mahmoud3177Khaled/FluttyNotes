import 'package:firstfluttergo/Globals/global_vars.dart';
import 'package:firstfluttergo/constants/colors.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {

  late final TextEditingController _searchText;

  @override
  void initState() {
    _searchText = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _searchText.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.fromLTRB(93, 0, 0, 0),
          child: Text(
            "Search",
            style: TextStyle(
              // fontFamily: 'Montserrat',
              fontWeight: FontWeight.bold,
              fontSize: 24
            ),  
          ),
        ),

        backgroundColor: Color(int.parse(backgroundColor)),
        foregroundColor: Color(int.parse(foregroundColor)),
        
      ),

      body: Column(
        children: [

          Row(
            children: [

              Padding(
                padding: const EdgeInsets.all(10.0),
                child: SizedBox(
                  height: 50,
                  width: 330,
                  child: TextField(
                    cursorColor: maintheme,
                    controller: _searchText,
                    autofocus: true,
                    onChanged: (value) {
                      devtools.log("tick!");

                      


                    },
                    enableSuggestions: true,
                    autocorrect: true,
                    // keyboardType: TextInputType.emailAddress,
                    
                    decoration: InputDecoration(
              
                      filled: true,
                      fillColor: const Color.fromARGB(255, 234, 224, 219),
                  
                      // hintText: "Enter your E-mail",
                  
                      hintText: "Search all your notes",
                      // labelStyle: TextStyle(),
                      floatingLabelStyle: const TextStyle(
                        color: maintheme
                      ),
                  
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
              
                  
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0)
                      )
                    ),
                  ),
                ),
              ),
                  
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: SizedBox(
                  // width: 30,
                  child: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {

                    },
                  )
                ),
              ),
            ],
          ),

          const Text("---------------------------------------------------------------------------------------")

        ],
      ),

      backgroundColor: Color(int.parse(backgroundColor)),

    );
  }
}