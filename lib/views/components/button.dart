import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget button({
  required Color backgroundColor,
  Color color = Colors.black,
  String? text,
  IconData? icon,
  required VoidCallback onPress,
  int limit = 18,
}) {
  if (text != null && text.length > 18) {
    text = '${text.substring(0, 18)}...';
  }
  return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          )),
      onPressed: onPress,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (text != null)
            Text(
              text,
              style: TextStyle(
                fontFamily: GoogleFonts.josefinSans().fontFamily,
                fontSize: 15,
                color: color,
              ),
            ),
          if (icon != null) ...[
            const SizedBox(width: 5),
            Icon(icon),
          ]
        ],
      ));
}
