import 'package:flutter/material.dart';

Widget paddedDivider({double height = 10}) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: height),
    child: const Divider(height: 2),
  );
}
