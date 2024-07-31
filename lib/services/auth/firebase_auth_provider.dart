import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth, FirebaseAuthException;
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'auth_providers.dart';
import 'auth_user.dart';
import 'auth_exceptions.dart';


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
  Future<AuthUser> signup({required email, required password}) async {

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
    } catch (e) {
      throw GenericAuthException();
    }

  }

  @override
  Future<AuthUser> login({required email, required password}) async  {

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
  Future<void> logout() async {
    final user =  FirebaseAuth.instance.currentUser;
    
    if(user != null) {
      await FirebaseAuth.instance.signOut();

    } else {
      throw UserNotLoggedInAuthException();
    }

  }

  @override
  Future<void> sendEmailVerification() async {

    final user = FirebaseAuth.instance.currentUser;

    if(user != null) {
      await user.sendEmailVerification();
    } else {
      throw UserNotLoggedInAuthException();
    }


  }


}
