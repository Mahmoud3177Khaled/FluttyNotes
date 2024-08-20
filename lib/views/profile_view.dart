import 'package:firstfluttergo/constants/colors.dart';
import 'package:firstfluttergo/services/CRUD/notes_service.dart';
import 'package:firstfluttergo/services/auth/auth_services.dart';
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



class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {

  String get userEmail => AuthService.firebase().currentUser!.email;
  late final NotesService _notesService;

  String username = "123";


  Future<String> getUserName() async {
    final user = await _notesService.getUser(email: userEmail);

    setState(() {
      username = user.username;
    });

    return username;
  }


  @override
  void initState() {
    _notesService = NotesService();
    _notesService.open().then((value) => getUserName());
    
    super.initState();
  }

  @override
  void dispose() {
    // _notesService.close();
    super.dispose();
  }


  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text("Your Profile"),
      //   backgroundColor: maintheme,
      //   foregroundColor: Colors.white,
      // ),

      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            // AppBar(
            //   title: const Text("Imagin this working"),
            // ),
            

            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 70),
              child: 
              
              
              Stack(
                clipBehavior: Clip.none,
              
                children: [

                  SizedBox(
                    // width: 400,
                    height: 200,
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [maintheme, Color.fromARGB(255, 255, 178, 130)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                                
                    ),
                  ),

                  AppBar(
                    title: const Text(
                      "Your Profile",

                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600
                      ),  
                    ),
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.white,
                  ),
              
                  Positioned(
                    top: 100, // Adjust to move the image up or down
                    left: 113, // Adjust to move the image left or right
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: SizedBox(
                          width: 150,
                          height: 150,
                          child: Container(

                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(500),
                              border: Border.all(
                                color: const Color.fromARGB(255, 255, 98, 0),
                                width: 2
                              )
                            ),
              
                            child: ClipOval(
                                child: Image.asset(
                                  "assets/images/someone.jpg",
                                  width: 200.0,
                                  height: 200.0,
                                  fit: BoxFit.cover,
                                ),
                              )
                                
                          ),
                        ),
                      ),
              
                    ),
                  ),
              
                  
                    // CircleAvatar(
                    //   radius: 50,
                    //   backgroundImage: AssetImage("assets/images/someone.jpg"),
                    // ),
                ] 
              ),
            ),


            Padding(
              padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
              child: SizedBox(
                // width: , 
                // height: 40,
                child: TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: maintheme,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                
                  onPressed: () async {

                  },
                
                  child: const Padding(
                    padding: EdgeInsets.fromLTRB(17, 4, 17, 4),
                    child: Text(
                      "Change Profile Image",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600
                      ),
                    ),
                  )
                      
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
            
                Padding(
                  padding: const EdgeInsets.fromLTRB(50, 0, 0, 0),
                  child: SizedBox(
                    // width: 170,
                    // height: 60,
                    child: OutlinedButton(
                      style: TextButton.styleFrom(
                          foregroundColor: Colors.black,
                          backgroundColor: const Color.fromARGB(255, 255, 251, 255),
                          shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7),
                      ),
            
                      side: const BorderSide(
                          color: Colors.black,
                          width: 3
                    ), 
                      ),
                      
                      onPressed: () {
                        switchModeoff();
                      },
                  
                      child: const Text(
                            "Light mode",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600
                            ),
                      ),
                  
                    ),
            
                  ),
            
                ),
            
                    
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                child: SizedBox(
                  // width: 170,
                  // height: 60,
                  child: OutlinedButton(
                    style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                    ),
            
                    side: const BorderSide(
                        color: Colors.black,
                        width: 5
                  ), 
                    ),
                    
                    onPressed: () {
                     switchModeOn();
                    },
                
                    child: const Text(
                          "Dark mode",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600
                          ),
                    ),
                
                  ),
            
                ),
            
              )
              ],
            ),
          ),

            
          ],
        ),
      ),
    );
  }
}