import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class OnboardingContentView extends StatelessWidget {
  final String photo;
  final String? title;
  final String description;
  const OnboardingContentView({
    super.key,
    this.title = null,
    required this.description,
    required this.photo,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: SvgPicture.asset(
                photo,
                height: MediaQuery.of(context).size.width * 0.7,
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            (title != null)
                ? Text(
                    title ?? '',
                    style: TextStyle(
                        fontFamily: GoogleFonts.montez().fontFamily,
                        fontSize: 70,
                        fontWeight: FontWeight.w800),
                  )
                : const SizedBox(),
            const SizedBox(
              height: 20,
            ),
            Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: GoogleFonts.josefinSans().fontFamily,
                fontSize: 24,
              ),
            )
          ],
        ),
      ),
    );
  }
}
