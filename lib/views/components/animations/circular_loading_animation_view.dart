import 'package:flutter/material.dart';
import 'package:verve/views/components/animations/lottie_animation_view.dart';
import 'package:verve/views/constants/asset_files.dart';

Widget circularLoadingAnimation() {
  return LottieAnimationView(
    animation: AssetFiles.circularLoadingLottieAnimation,
    reverse: false,
    repeat: true,
  );
}
