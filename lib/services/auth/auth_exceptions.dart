import 'package:firstfluttergo/tools/alert_boxes.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

// login exceptions

class InvalidCredentialAuthException implements Exception {

  InvalidCredentialAuthException(context)
  {
    showAlertBox(
      context,
      title: "Wrong E-mail or Password",
      content: "Please check your credentials and try again...",
      opt1: TextButton(
        onPressed: () {
          Navigator.of(context).pop(false);
        },
          child: const Text("Ok")
      )
      
      );
    devtools.log("Email or Password are incorrect");
  }
  
}

class ChannelErrorAuthException implements Exception {
  ChannelErrorAuthException(context)
  {
    showAlertBox(
      context,
      title: "Email or password missing",
      content: "Please enter both your E-mail and password",
      opt1: TextButton(
        onPressed: () {
          Navigator.of(context).pop(false);
        },
          child: const Text("Ok")
      )
      
      );

    devtools.log("Missing password or Email");

  }

}

class InvalidEmailAuthException implements Exception {
  InvalidEmailAuthException(context) {
    showAlertBox(
      context,
      title: "Invalid E-mail",
      content: "Please check you entered your email correctly and without a space at the end",
      opt1: TextButton(
        onPressed: () {
          Navigator.of(context).pop(false);
        },
          child: const Text("Ok")
      )
      
      );

    devtools.log("Email is invalid");

  }

}

// sign up exceptions

class UsedEmailAuthException implements Exception {
  UsedEmailAuthException(context) {

    showAlertBox(
      context,
      title: "Email already in use",
      content: "You enetered an already registerd email... \n\nPlease try again with a different one...",
      opt1: TextButton(
        onPressed: () {
          Navigator.of(context).pop(false);
        },
          child: const Text("Ok")
      )
      
      );

  }
}

class WeakPasswordAuthException implements Exception {
  WeakPasswordAuthException(context) {

  showAlertBox(
    context,
    title: "Invalid E-mail",
    content: "Please check you entered your email correctly and without a space at the end",
    opt1: TextButton(
      onPressed: () {
        Navigator.of(context).pop(false);
      },
        child: const Text("Ok")
    )
    
  );

  }
}

// generic exceptions 

class UserNotLoggedInAuthException implements Exception {
  UserNotLoggedInAuthException(context) {

    showAlertBox(
      context,
      title: "Null user",
      content: "No user logged in right now...",
      opt1: TextButton(
        onPressed: () {
          Navigator.of(context).pop(false);
        },
          child: const Text("Ok")
      )
      
      );

  }
}

class GenericAuthException implements Exception {
  GenericAuthException(context) {

    showAlertBox(
      context,
      title: "Procces can not be done",
      content: "Please try again later...",
      opt1: TextButton(
        onPressed: () {
          Navigator.of(context).pop(false);
        },
          child: const Text("Ok")
      )
      
      );


  devtools.log("Some error happened...");

  }
}
