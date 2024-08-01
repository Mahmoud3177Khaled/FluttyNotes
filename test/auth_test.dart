import 'package:firebase_core/firebase_core.dart';
import 'package:firstfluttergo/services/auth/auth_exceptions.dart';
import 'package:firstfluttergo/services/auth/auth_providers.dart';
import 'package:firstfluttergo/services/auth/auth_user.dart';
import 'package:test/test.dart';

void main() {
  group("Auth_provider_tests", () {
    final provider = MockAuthProvider();

    provider.initializeApp();
  });  
}

class IntiialisationException implements Exception {}

class MockAuthProvider implements AuthProvider {

  AuthUser? _user;

  var _isinitialised = false;

  bool get isInotialised => _isinitialised;

  @override
  AuthUser? get currentUser {
    return _user;
  }

  @override
  Future<dynamic> initializeApp() async {
    _isinitialised = true;
    await Future.delayed(const Duration(seconds: 2));
  }

  @override
  Future<AuthUser> login({required email, required password}) async {

    if(!_isinitialised) {
      throw IntiialisationException();
    } 
    await Future.delayed(const Duration(seconds: 2));

    if(email == "123@gmail.com") throw InvalidEmailAuthException();
    if(password == "123") throw WeakPasswordAuthException();
    const user =  AuthUser(null, isEmailVerified: false);
    _user = user;

    if(_user != null) {
      return Future.value(user);
    } else {
      throw GenericAuthException();
    }
  }

  @override
  Future<void> logout() async {
    if(!_isinitialised) {
      throw IntiialisationException();
    }

    if(_user == null) {
      throw UserNotLoggedInAuthException();
    }

    await await Future.delayed(const Duration(seconds: 2));

    _user = null;
    
  }

  @override
  Future<void> sendEmailVerification() async {
    if(!_isinitialised) {
      throw IntiialisationException();
    }

    if(_user == null) {
      throw UserNotLoggedInAuthException();
    }

    await await Future.delayed(const Duration(seconds: 2));

    const user = AuthUser(null, isEmailVerified: true);

    _user = user;
    

  }

  @override
  Future<AuthUser> signup({required email, required password}) {
    if(_isinitialised == false) {
      throw IntiialisationException();
    }

    Future.delayed(const Duration(seconds: 2));

    return login(email: email, password: password, );
  }

}