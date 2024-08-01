import 'package:firstfluttergo/tools/alert_boxes.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

// login exceptions

class InvalidCredentialAuthException implements Exception {}

class ChannelErrorAuthException implements Exception {}

class InvalidEmailAuthException implements Exception {}

// sign up exceptions

class UsedEmailAuthException implements Exception {}

class WeakPasswordAuthException implements Exception {
  WeakPasswordAuthException() {

  

  }
}

// generic exceptions 

class UserNotLoggedInAuthException implements Exception {}

class GenericAuthException implements Exception {}
