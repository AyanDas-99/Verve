import 'package:flutter/material.dart';
import 'package:verve/views/components/text/regular_text.dart';

Widget commentCountText(int commentCount) {
  final String text = (commentCount == 1) ? ' comment' : ' comments';
  return regularText(
    commentCount.toString() + text,
    fontSize: 12,
  );
}
