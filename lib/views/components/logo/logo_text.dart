import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:verve/views/onboarding/constants/strings.dart';

Widget logoText({double size = 50}) {
  return Text(
    Strings.verve,
    style: TextStyle(
        fontFamily: GoogleFonts.montez().fontFamily,
        fontSize: size,
        fontWeight: FontWeight.w800),
  );
}
