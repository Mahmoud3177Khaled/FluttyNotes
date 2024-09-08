import 'package:flutter/foundation.dart' show immutable;

typedef CloseStreamController = bool Function();
typedef UpdateStreamController = bool Function(String text);

@immutable
class LoadingController {
  final CloseStreamController close;
  final UpdateStreamController update;

  const LoadingController({required this.close, required this.update});
}