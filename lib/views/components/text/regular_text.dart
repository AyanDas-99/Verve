import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget regularText(
  String text, {
  Color color = Colors.black,
  double fontSize = 15,
}) {
  return Text(
    text,
    style: TextStyle(
      color: color,
      fontFamily: GoogleFonts.josefinSans().fontFamily,
      fontSize: fontSize,
    ),
  );
}
