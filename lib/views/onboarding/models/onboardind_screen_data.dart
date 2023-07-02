import 'package:flutter/foundation.dart' show immutable;

@immutable
class OnboardingScreenData {
  final String? title;
  final String description;
  final String photo;

  const OnboardingScreenData({
    this.title,
    required this.description,
    required this.photo,
  });
}
