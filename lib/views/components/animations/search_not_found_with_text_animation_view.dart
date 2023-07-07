import 'package:flutter/material.dart';
import 'package:verve/views/components/animations/search_not_found_animation_view.dart';
import 'package:verve/views/components/text/regular_text.dart';

Widget searchNotFoundWithTextAnimationView({required String text}) {
  return Expanded(
      child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      SearchNotFoundAnimationView(),
      const SizedBox(height: 10),
      regularText(text, fontSize: 25),
    ],
  ));
}
