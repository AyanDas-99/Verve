import 'package:flutter/material.dart';
import 'package:verve/views/components/animations/lottie_animation_view.dart';
import 'package:verve/views/constants/asset_files.dart';

Widget dotLoadingAnimationView() {
  return LottieAnimationView(
    animation: AssetFiles.dotLoadingLottieAnimation,
    reverse: false,
    repeat: true,
  );
}
