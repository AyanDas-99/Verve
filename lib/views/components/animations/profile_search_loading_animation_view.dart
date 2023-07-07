import 'package:flutter/material.dart';
import 'package:verve/views/components/animations/lottie_animation_view.dart';
import 'package:verve/views/constants/asset_files.dart';

Widget profileSearchLoadingAnimationView() {
  return Expanded(
      child: LottieAnimationView(
    animation: AssetFiles.profileSearchAnimation,
    repeat: true,
    reverse: false,
  ));
}
