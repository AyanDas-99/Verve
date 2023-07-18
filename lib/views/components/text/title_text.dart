import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget titleText(String text) {
  return Text(
    text,
    style: TextStyle(
      fontFamily: GoogleFonts.josefinSans().fontFamily,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  );
}
