import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LottieAnimationView extends StatelessWidget {
  final String animation;
  final bool reverse;
  final bool repeat;
  const LottieAnimationView({
    super.key,
    required this.animation,
    required this.reverse,
    required this.repeat,
  });

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      animation,
      repeat: repeat,
      reverse: reverse,
    );
  }
}
