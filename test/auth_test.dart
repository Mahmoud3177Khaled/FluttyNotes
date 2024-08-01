// import 'package:firebase_core/firebase_core.dart';
import 'package:firstfluttergo/services/auth/auth_exceptions.dart';
import 'package:firstfluttergo/services/auth/auth_providers.dart';
import 'package:firstfluttergo/services/auth/auth_user.dart';
import 'package:test/test.dart';

void main() {
  group("Auth_provider_tests", () {
    final provider = MockAuthProvider();

    test("_isIntisialised must be false by default", () { 
      expect(provider._isinitialised, false);
    });

    test("no logout with out initialisation", () {
      expect(provider.logout(), throwsA(const TypeMatcher<IntiialisationException>()));
    });

    test("Should be able to be inistalized", () async {
      await provider.initializeApp();

      expect(provider._isinitialised, true);
    });

    test("User should be bull after initialization", () {
      expect(provider._user, null);
    });

    test("Should finish in less than two seconds", () async {
      await provider.initializeApp();
      expect(provider._isinitialised, true);

    }, timeout: const Timeout(Duration(seconds: 3)));

    test("signup with 123 as email should throw exception", () async {
      final signedupuser = provider.signup(email: "123@gmail.com", password: "123");

      expect(signedupuser, throwsA(const TypeMatcher<InvalidEmailAuthException>()));
    });

    test("signup with 123 as password should throw exception", () async {
      final signedupuser = provider.signup(email: "1234@gmail.com", password: "123");

      expect(signedupuser, throwsA(const TypeMatcher<WeakPasswordAuthException>()));
    });

    test("sign up should set user to nto null", () async {
      final signedupuser = await provider.signup(email: "123", password: "1234");

      expect(provider._user, signedupuser);
    });

    test("Once user is created its _isemailverifiied should be set to false", () async {
      final signupuser = await provider.signup(email: "1234", password: "1234");

      expect(provider._user, signupuser);
      expect(provider._user?.isEmailVerified, false);
    });

    test("email should be verified after calling sendEmailVerification()", () async {
      expect(provider.isInotialised, true);
      expect(provider._user, isNotNull);

      await provider.sendEmailVerification();

      expect(provider._user?.isEmailVerified, true);
    });

    test("should be able to logout and log back in", () async {
      expect(provider._user, isNotNull);
      
      await provider.logout();

      expect(provider._user, null);

      await provider.login(email: "1234", password: "1234");

      expect(provider._user, isNotNull);
    });



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
    await Future.delayed(const Duration(seconds: 2));
    _isinitialised = true;

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
  Future<AuthUser> signup({required email, required password}) async {
    if(_isinitialised == false) {
      throw IntiialisationException();
    }

    await Future.delayed(const Duration(seconds: 2));

    return await login(email: email, password: password, );
  }

}