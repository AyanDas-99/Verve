import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:verve/state/auth/providers/auth_state_provider.dart';
import 'package:verve/views/onboarding/constants/strings.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Text(
              Strings.signin,
              style: TextStyle(
                fontFamily: GoogleFonts.josefinSans().fontFamily,
                fontSize: 30,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          Padding(
              padding: const EdgeInsets.all(20.0),
              child: Consumer(builder: (context, ref, child) {
                return InkWell(
                  onTap: () async {
                    await ref
                        .read(authStateProvider.notifier)
                        .loginWithGoogle();
                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  },
                  child: Container(
                      constraints: BoxConstraints(maxWidth: 250),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.blueGrey),
                      ),
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const FaIcon(FontAwesomeIcons.google),
                          const SizedBox(
                            width: 15,
                          ),
                          Text(
                            Strings.google,
                            style: TextStyle(
                              fontFamily: GoogleFonts.josefinSans().fontFamily,
                              fontSize: 20,
                            ),
                          )
                        ],
                      )),
                );
              })),
        ],
      ),
    );
  }
}
