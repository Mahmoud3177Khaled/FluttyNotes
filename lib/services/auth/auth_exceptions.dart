import 'dart:developer'as devtools show log;

// login exceptions

class InvalidCredentialAuthException implements Exception {
  InvalidCredentialAuthException() {
    devtools.log("Invalid credentials entered");
  }
}

class ChannelErrorAuthException implements Exception {
  ChannelErrorAuthException() {
    devtools.log("Channel error occuered, make sure there are no empty fields");
  }
}

class InvalidEmailAuthException implements Exception {
  InvalidEmailAuthException() {
    devtools.log("This email is invalid or has a space at the end");
  }
}

// sign up exceptions

class UsedEmailAuthException implements Exception {
  UsedEmailAuthException() {
    devtools.log("This email is already used");
  }
}

class WeakPasswordAuthException implements Exception {
  WeakPasswordAuthException() {
    devtools.log("This password is too short, make it at least 8 chars long");
  }
}

// generic exceptions 

class UserNotLoggedInAuthException implements Exception {
  UserNotLoggedInAuthException() {
    devtools.log("No user loggedin to begin with");
  }
}

class GenericAuthException implements Exception {
  GenericAuthException() {
    devtools.log("An error happened");
  }
}
