import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:verve/views/responsive/responsive.dart';

class OnboardingContentView extends StatelessWidget {
  final String photo;
  final String? title;
  final String description;
  const OnboardingContentView({
    super.key,
    this.title,
    required this.description,
    required this.photo,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: (Responsive.isDesktop(context))

              // Desktop View
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      photo,
                      height: 400,
                    ),
                    // if (Responsive.isPhone(context))
                    // const SizedBox(
                    //   width: 20,
                    // ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
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
                        ),
                      ],
                    )
                  ],
                )

              // Phone view
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: SvgPicture.asset(
                        photo,
                        height: MediaQuery.of(context).size.width * 0.6,
                      ),
                    ),
                    // if (Responsive.isPhone(context))
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
      ),
    );
  }
}
