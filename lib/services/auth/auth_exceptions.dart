// login exceptions

class InvalidCredentialAuthException implements Exception {}

class ChannelErrorAuthException implements Exception {}

class InvalidEmailAuthException implements Exception {}

// sign up exceptions

class UsedEmailAuthException implements Exception {}

class WeakPasswordAuthException implements Exception {}

// class InvalidEmailAuthException implements Exception {}

// generic exceptions 

class UserNotLoggedInAuthException implements Exception {}

class GenericAuthException implements Exception {}
