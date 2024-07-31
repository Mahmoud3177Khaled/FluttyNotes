import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth, FirebaseAuthException;
import 'package:firebase_core/firebase_core.dart';
import 'package:firstfluttergo/firebase_options.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'auth_providers.dart';
import 'auth_user.dart';
import 'auth_exceptions.dart';
import 'dart:developer' as devtools show log;


class FirebaseAuthProvider implements AuthProvider
{
  @override
  AuthUser? get currentUser {
    final user = FirebaseAuth.instance.currentUser;
    if(user != null) {
      return AuthUser.fromFirebase(user);
    } 
    else {
      return null;
    }

  }

  @override
  Future<AuthUser> signup({required email, required password, required context,}) async {

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password
      );

      final user = currentUser;

      if (user != null) {
        return user;
      }
      else {
        throw UserNotLoggedInAuthException(context);
      }

    } on FirebaseAuthException catch (e) {

      if (e.code == "email-already-in-use") {
        throw UsedEmailAuthException(context);

      } else if (e.code == "channel-error") {
        throw ChannelErrorAuthException(context);

      } else if (e.code == "weak-password") {
        throw WeakPasswordAuthException(context);

      } else if (e.code == "invalid-email") {
        throw InvalidEmailAuthException(context); 
      } else {
        throw GenericAuthException(context);
      }
    } catch (e) {
      throw GenericAuthException(context);
    }

  }

  @override
  Future<AuthUser> login({required email, required password, required context}) async  {

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password
      );

      final user = currentUser;

      if(user != null) {
        return user;
      }
      else {
        throw UserNotLoggedInAuthException(context);
      }

    } on FirebaseAuthException catch (e) {
      if (e.code == "invalid-credential") {
        throw InvalidCredentialAuthException(context);
        
      } else if (e.code == "channel-error") {
        throw ChannelErrorAuthException(context);
        
      }
      else if (e.code == "invalid-email") {
        throw InvalidEmailAuthException(context);
    } else {
      throw GenericAuthException(context);
    }

  } catch (e) {
    throw GenericAuthException(context);

  }
}

  @override
  Future<void> logout({required context,}) async {
    final user =  FirebaseAuth.instance.currentUser;
    
    if(user != null) {
      await FirebaseAuth.instance.signOut();

    } else {
      throw UserNotLoggedInAuthException(context);
    }

  }

  @override
  Future<void> sendEmailVerification({required context,}) async {

    final user = FirebaseAuth.instance.currentUser;
    try {
      if(user != null) {
        await user.sendEmailVerification();
      } else {
        throw UserNotLoggedInAuthException(context);
      }

    } catch (e) {
      devtools.log(e.toString());
      throw GenericAuthException(context);
    }


  }

  @override
  Future<FirebaseApp> initializeApp({required context,}) async {
    try {
      final firebaseapp =  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

      // ignore: unnecessary_null_comparison
      if(firebaseapp != null) {
        return firebaseapp;

      } else {
        throw GenericAuthException(context);
      }
    } catch (e) {
      throw GenericAuthException(context);
    }
  }


}
