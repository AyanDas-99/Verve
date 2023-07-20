import 'package:flutter/material.dart';
import 'package:verve/views/components/text/regular_text.dart';

Widget likeCountText(int likesCount) {
  final String text = (likesCount == 1) ? ' like' : ' likes';
  return regularText(
    likesCount.toString() + text,
    fontSize: 12,
  );
}
