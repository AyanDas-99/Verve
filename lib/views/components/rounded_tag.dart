import 'package:flutter/material.dart';
import 'package:verve/views/components/text/regular_text.dart';

Widget roundedTag(String title, {Color color = Colors.blueGrey}) {
  return Padding(
    padding: const EdgeInsets.all(5),
    child: Container(
      padding: const EdgeInsets.all(5),
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)),
      child: regularText(title),
    ),
  );
}
