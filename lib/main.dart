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


// import 'package:bloc/bloc.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class Countertest extends StatefulWidget {
//   const Countertest({super.key});

//   @override
//   State<Countertest> createState() => _CountertestState();
// }

// class _CountertestState extends State<Countertest> {

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
//         ),

//         body: const Column(
//           children: [

//           ],
          
//         ),
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