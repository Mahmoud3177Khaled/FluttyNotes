import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth, FirebaseAuthException;
import 'package:firebase_core/firebase_core.dart';
import 'package:firstfluttergo/Globals/global_vars.dart';
import 'package:firstfluttergo/firebase_options.dart';
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
  Future<AuthUser> signup({required email, required password,}) async {

    try {
      if(userNameInGlobal == "") {
        
          throw NoUserNameProvided();
        }

      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password
      );

      final user = currentUser;


      if (user != null) {
        return user;
      }
      else {
        throw UserNotLoggedInAuthException();
      }


    } on FirebaseAuthException catch (e) {

      if (e.code == "email-already-in-use") {
        throw UsedEmailAuthException();

      } else if (e.code == "channel-error") {
        throw ChannelErrorAuthException();

      } else if (e.code == "weak-password") {
        throw WeakPasswordAuthException();

      } else if (e.code == "invalid-email") {
        throw InvalidEmailAuthException(); 
      } else {
        throw GenericAuthException();
      }
    } on NoUserNameProvided catch (_) {
      throw NoUserNameProvided();
    } catch (e) {
      throw GenericAuthException();
    }

  }

  @override
  Future<AuthUser> login({required email, required password }) async  {

    try {
      // await Future.delayed(const Duration(seconds: 20));
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password
      );

      final user = currentUser;

      if(user != null) {
        return user;
      }
      else {
        throw UserNotLoggedInAuthException();
      }

    } on FirebaseAuthException catch (e) {
      if (e.code == "invalid-credential") {
        throw InvalidCredentialAuthException();
        
      } else if (e.code == "channel-error") {
        throw ChannelErrorAuthException();
        
      }
      else if (e.code == "invalid-email") {
        throw InvalidEmailAuthException();
    } else {
      throw GenericAuthException();
    }

  } catch (e) {
    throw GenericAuthException();

  }
}

  @override
  Future<void> logout({required ,}) async {
    final user =  FirebaseAuth.instance.currentUser;
    
    if(user != null) {
      // await Future.delayed(const Duration(seconds: 5));
      await FirebaseAuth.instance.signOut();

    } else {
      throw UserNotLoggedInAuthException();
    }

  }

  @override
  Future<void> sendEmailVerification({required ,}) async {

    final user = FirebaseAuth.instance.currentUser;
    try {
      if(user != null) {
        await user.sendEmailVerification();
      } else {
        throw UserNotLoggedInAuthException();
      }

    } catch (e) {
      devtools.log(e.toString());
      throw GenericAuthException();
    }


  }

  @override
  Future<FirebaseApp> initializeApp({required ,}) async {
    try {
      final firebaseapp =  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

      // ignore: unnecessary_null_comparison
      if(firebaseapp != null) {
        return firebaseapp;

      } else {
        throw GenericAuthException();
      }
    } catch (e) {
      throw GenericAuthException();
    }
  }
  
  @override
  Future<void> sendPasswordReset({required String email}) async {

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      devtools.log(e.code);
      if(e.code == 'invalid-email') {
        throw InvalidEmailAuthException();

      } else if (e.code == 'user-not-found') {
        throw UserNotLoggedInAuthException();

      } else if (e.code == 'channel-error') {
        throw ChannelErrorAuthException();

      }  else {
        throw GenericAuthException();

      }
    } catch (_) {
      throw GenericAuthException();
    }
    
    // throw UnimplementedError();
  }

  




}
