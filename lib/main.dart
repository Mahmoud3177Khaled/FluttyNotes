import 'package:firstfluttergo/constants/routes.dart';
import 'package:firstfluttergo/services/auth/auth_services.dart';
import 'package:firstfluttergo/views/profile_view.dart';
import 'package:firstfluttergo/views/search_view.dart';
import 'package:firstfluttergo/views/update_note_view.dart';
import 'package:firstfluttergo/views/welcome_view.dart';
import 'package:firstfluttergo/views/verification_view.dart';
import 'package:firstfluttergo/views/new_note_view.dart';
import 'package:flutter/material.dart';
import 'views/login_view.dart';
import 'views/registration_view.dart';
import 'views/homepage_view.dart';
import 'dart:developer' as devtools show log;
import 'constants/colors.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          // primarySwatch: Color.fromARGB(255, 0, 60, 255),
          // inputDecorationTheme: const InputDecorationTheme(
          //   focusedBorder: OutlineInputBorder(
          //     borderSide: BorderSide(
          //         color: maintheme), // Blue border when focused
          //   ),
          //   enabledBorder: OutlineInputBorder(
          //     borderSide: BorderSide(
          //         color:
          //             Color.fromARGB(255, 0, 0, 0)), // Blue border when enabled
          //   ),
          //   hintStyle: TextStyle(
          //       color: Color.fromARGB(255, 0, 33, 140)), // Blue hint text
          //   labelStyle: TextStyle(
          //       color: Color.fromARGB(255, 0, 60, 255)), // Blue label text
          //),
          textSelectionTheme: const TextSelectionThemeData(
            cursorColor: maintheme,// Blue cursor
            selectionColor:
                Color.fromARGB(99, 0, 104, 189), // Blue selection color
            selectionHandleColor: maintheme,
          ),
          textTheme: const TextTheme()),
      home: const CheckAccountState(),
      routes: {
        login: (context) => const LoginView(),
        register: (context) => const RegistrationView(),
        verify: (context) => const VerificationView(),
        welcomeview: (context) => const WelcomeView(),
        homepage: (context) => const Homepageview(),
        check: (context) => const CheckAccountState(),
        profile: (context) => const ProfileView(),
        // settings: (context) => const SettingsView(),
        newNote: (context) => const NewNoteView(),
        updateNote: (context) => const UpdateNoteView(),
        search: (context) => const SearchView(),
      },
    );
  }
}

class CheckAccountState extends StatelessWidget {
  const CheckAccountState({super.key});
  

  @override
  Widget build(BuildContext context) {
    

    return Scaffold(
      appBar: AppBar(
        title: const Text("Checking user state"),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        foregroundColor: const Color.fromARGB(255, 255, 255, 255)

        ),

        body: FutureBuilder(
          future: AuthService.firebase().initializeApp(),

           builder: (context, snapshot) {
             switch (snapshot.connectionState) {

              case ConnectionState.done:
              devtools.log(DateTime.now().toString());

              final user = AuthService.firebase().currentUser;
              devtools.log(user.toString());

              WidgetsBinding.instance.addPostFrameCallback((_) {

                if(user == null)
                {
                  Navigator.of(context).pushNamedAndRemoveUntil(welcomeview,  (route) => false,);
                }
                else if(user.isEmailVerified == false)
                {
                  Navigator.of(context).pushNamedAndRemoveUntil(verify, (route) => false,);
                }
                else 
                {
                  Navigator.of(context).pushNamedAndRemoveUntil(homepage,  (route) => false,);
                }
              },              
              );

              return const Center(child: Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 200),
                child: CircularProgressIndicator(),
              ));

              default:
                return const Text("Failed to connect to Firebase services");
             }
           },
           ),
    );
  }
}




// ###################################################################################################################




// // import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:firstfluttergo/constants/routes.dart';
// // import 'package:firstfluttergo/services/auth/auth_services.dart';
// import 'package:firstfluttergo/views/profile_view.dart';
// import 'package:firstfluttergo/views/search_view.dart';
// import 'package:firstfluttergo/views/update_note_view.dart';
// import 'package:firstfluttergo/views/welcome_view.dart';
// import 'package:firstfluttergo/views/verification_view.dart';
// import 'package:firstfluttergo/views/new_note_view.dart';
// import 'package:flutter/material.dart';
// import 'views/login_view.dart';
// import 'views/registration_view.dart';
// import 'views/homepage_view.dart';
// // import 'dart:developer' as devtools show log;
// import 'constants/colors.dart';


// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   runApp(const MyApp());
// }


// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//           textSelectionTheme: const TextSelectionThemeData(
//             cursorColor: maintheme,// Blue cursor
//             selectionColor:
//                 Color.fromARGB(99, 0, 104, 189), // Blue selection color
//             selectionHandleColor: maintheme,
//           ),
//           textTheme: const TextTheme()),
//       home: const CheckAccountState(),
//       routes: {
//         login: (context) => const LoginView(),
//         register: (context) => const RegistrationView(),
//         verify: (context) => const VerificationView(),
//         welcomeview: (context) => const WelcomeView(),
//         homepage: (context) => const Homepageview(),
//         check: (context) => const CheckAccountState(),
//         profile: (context) => const ProfileView(),
//         // settings: (context) => const SettingsView(),
//         newNote: (context) => const NewNoteView(),
//         updateNote: (context) => const UpdateNoteView(),
//         search: (context) => const SearchView(),
//       },
//     );
//   }
// }

// class CheckAccountState extends StatefulWidget {
//   const CheckAccountState({super.key});

//   @override
//   State<CheckAccountState> createState() => _CheckAccountStateState();
// }

// class _CheckAccountStateState extends State<CheckAccountState> {
//   late final TextEditingController _num;

//   @override
//   void initState() {
//     _num = TextEditingController();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _num.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => CounterBloc(),
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text("bloc test"),
//           backgroundColor: Colors.blue,
//           foregroundColor: Colors.white,
//         ),

//         body: BlocConsumer<CounterBloc, CounterState>(
//           listener: (context, state) {
//             // _num.clear();
//           },
//           builder: (context, state) {
//             return  Column(
//               children: [
//                 Text("Current Value: ${state.value}"),

//                 Visibility(
//                   visible: (state is CounterInvalidState),
//                   child: (state is CounterInvalidState) ?  Text("Invaled value: ${state.invalidValue}") : const Text(''),
//                 ),

//                 TextField(
//                   controller: _num,
//                   keyboardType: TextInputType.number,
//                   decoration: const InputDecoration(
//                     hintText: "Enter a num here"
//                   ),  
//                 ),

//                 Row(
//                   children: [
//                     TextButton(
//                       onPressed: () {
//                         context.read<CounterBloc>().add(IncrementEvent(value: _num.text));
//                       }, 
//                       child: const Text("+")
                      
//                     ),
//                     TextButton(
//                       onPressed: () {
//                         context.read<CounterBloc>().add(DecrementEvent(value: _num.text));
//                       }, 
//                       child: const Text("-")
                      
//                     ),
//                   ],
                  
//                   )
//               ],
              
//             );
//           },
//         )
//       ),
//     );

//   }
// }


// @immutable
// abstract class CounterState {
//   final int value;
//   const CounterState(this.value);
// }
// @immutable
// class CounterValidState extends CounterState {
// const CounterValidState(super.value);
// }
// @immutable
// class CounterInvalidState extends CounterState {
//   final String invalidValue;
//   const CounterInvalidState({required this.invalidValue, required previousValue}) : super(previousValue);
// }


// @immutable
// abstract class CounterEvent {
//   final String value;
//   const CounterEvent(this.value);
// }
// @immutable
// class IncrementEvent extends CounterEvent {
//   const IncrementEvent({required String value}) : super(value);
// } 
// @immutable
// class DecrementEvent extends CounterEvent {
//   const DecrementEvent({required String value}) : super(value);
// }

// class CounterBloc extends Bloc<CounterEvent, CounterState> {
//   CounterBloc() : super(const CounterValidState(0)) {
//     on<IncrementEvent>((event, emit) {
//       final num = int.tryParse(event.value);

//       if(num == null) {
//         emit(
//           CounterInvalidState(invalidValue: event.value, previousValue: state.value)
//         );
//       } else {
//         emit(
//           CounterValidState(state.value + num)
//         );
//       }

//     });

//     on<DecrementEvent>((event, emit) {
//       final num = int.tryParse(event.value);

//       if(num == null) {
//         emit(
//           CounterInvalidState(invalidValue: event.value, previousValue: state.value)
//         );
//       } else {
//         emit(
//           CounterValidState(state.value - num)
//         );
//       }

//     });
//   }
// }




// ###################################################################################################################




// // import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:firstfluttergo/constants/routes.dart';
// // import 'package:firstfluttergo/services/auth/auth_services.dart';
// import 'package:firstfluttergo/views/profile_view.dart';
// import 'package:firstfluttergo/views/search_view.dart';
// import 'package:firstfluttergo/views/update_note_view.dart';
// import 'package:firstfluttergo/views/welcome_view.dart';
// import 'package:firstfluttergo/views/verification_view.dart';
// import 'package:firstfluttergo/views/new_note_view.dart';
// import 'package:flutter/material.dart';
// import 'views/login_view.dart';
// import 'views/registration_view.dart';
// import 'views/homepage_view.dart';
// // import 'dart:developer' as devtools show log;
// import 'constants/colors.dart';


// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//           textSelectionTheme: const TextSelectionThemeData(
//             cursorColor: maintheme,// Blue cursor
//             selectionColor:
//                 Color.fromARGB(99, 0, 104, 189), // Blue selection color
//             selectionHandleColor: maintheme,
//           ),
//           textTheme: const TextTheme()),
//       home: const CheckAccountState(),
//       routes: {
//         login: (context) => const LoginView(),
//         register: (context) => const RegistrationView(),
//         verify: (context) => const VerificationView(),
//         welcomeview: (context) => const WelcomeView(),
//         homepage: (context) => const Homepageview(),
//         check: (context) => const CheckAccountState(),
//         profile: (context) => const ProfileView(),
//         // settings: (context) => const SettingsView(),
//         newNote: (context) => const NewNoteView(),
//         updateNote: (context) => const UpdateNoteView(),
//         search: (context) => const SearchView(),
//       },
//     );
//   }
// }



// class CheckAccountState extends StatefulWidget {
//   const CheckAccountState({super.key});

//   @override
//   State<CheckAccountState> createState() => _CheckAccountStateState();
// }

// class _CheckAccountStateState extends State<CheckAccountState> {
//   int i = 0;

//   @override
//   void initState() {
    
//     super.initState();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => Addbloc(),
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text("Bloc test 2"),
//         ),

//         // floatingActionButton: FloatingActionButton(
//         //   onPressed: () {
//         //     _num.text = (int.tryParse(_num.text)! + 1).toString();
//         //     context.read<Addbloc>().add(AddEvent(value: _num.text));
//         //   },
//         //   child: const Icon(Icons.add),
          
//         // ),

//         body: BlocConsumer<Addbloc, BState>(
//           listener: (context, state) {
//             // _num.clear();
//           },
//           builder: (context, state) {
//             return Center(
//               child:  Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   const Text("Your Counter"),
//                   Text(state.value.toString()),

//                   TextButton(
//                     onPressed: () {
//                       i++;
//                       context.read<Addbloc>().add(AddEvent(i));
//                     }, 
//                     child: const Icon(Icons.add)
                    
//                   ),

//                   TextButton(
//                     onPressed: () {
//                       i--;
//                       context.read<Addbloc>().add(DecEvent(i));
//                     }, 
//                     child: const Icon(Icons.minimize)
                    
//                   ),
//                 ],
//               )
//             );
//           },
//         ),
//       ),
//     );

//   }
// }


// @immutable
// class BState {
//   final int value;
//   const BState({required this.value});
// }
// @immutable
// class AddState extends BState {

//   const AddState(int value) : super(value: value);
// }
// @immutable
// class DecState extends BState {

//   const DecState(int value) : super(value: value);
// }



// @immutable
// abstract class Event {
//   final int value;
//   const Event({required this.value});
// }

// @immutable
// class AddEvent extends Event {

//   const AddEvent(int value) : super(value: value);
// }
// @immutable
// class DecEvent extends Event {

//   const DecEvent(int value) : super(value: value);
// }



// class Addbloc extends Bloc<Event, BState> {
//   Addbloc() : super(const BState(value: 0)) {
//     on<AddEvent>((event, emit) {
//       emit(
//         AddState(state.value + 1)
//       );
//     },);

//     on<DecEvent>((event, emit) {
//       emit(
//         DecState(state.value - 1)
//       );
//     },);
//   }

// }