import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:verve/views/components/dot_indicator.dart';
import 'package:verve/views/constants/asset_files.dart';
import 'package:verve/views/onboarding/constants/strings.dart';
import 'package:verve/views/onboarding/login_view.dart';
import 'package:verve/views/onboarding/models/onboardind_screen_data.dart';
import 'package:verve/views/onboarding/onboarding_content_view.dart';

class OnBoardingView extends StatefulWidget {
  const OnBoardingView({super.key});

  @override
  State<OnBoardingView> createState() => _OnBoardingViewState();
}

class _OnBoardingViewState extends State<OnBoardingView> {
  late PageController _pageController;

  int pageIndex = 0;
  double opacity = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: screens.length,
              onPageChanged: (index) {
                setState(() {
                  pageIndex = index;
                  if (index == screens.length - 1) {
                    opacity = 1.0;
                  } else {
                    opacity = 0.0;
                  }
                });
              },
              itemBuilder: (context, index) => OnboardingContentView(
                title: screens[index].title,
                description: screens[index].description,
                photo: screens[index].photo,
              ),
            ),
          ),
          SizedBox(
            height: 80,
            child: Row(
              children: [
                ...List.generate(screens.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.all(5),
                    child: DotIndicator(isActive: index == pageIndex),
                  );
                }),
                const Spacer(),
                AnimatedOpacity(
                  opacity: opacity,
                  duration: const Duration(milliseconds: 300),
                  child: ElevatedButton(
                    onPressed: opacity == 0
                        ? null
                        : () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginView(),
                            )),
                    child: Text(
                      Strings.login,
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                const Spacer(),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        backgroundColor: Colors.purple),
                    onPressed: () {
                      _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.ease);
                    },
                    child: const FaIcon(
                      FontAwesomeIcons.arrowRightLong,
                      size: 15,
                      color: Colors.white,
                    )),
              ],
            ),
          )
        ]),
      ),
    );
  }

  // on-boarding data
  final screens = [
    OnboardingScreenData(
      title: Strings.verve,
      description: Strings.unleashYourCreativity,
      photo: AssetFiles.makingArtSvg,
    ),
    OnboardingScreenData(
      description: Strings.expressYourSelfThrough,
      photo: AssetFiles.singingSvg,
    ),
    OnboardingScreenData(
      description: Strings.connectWithLikeMinded,
      photo: AssetFiles.connectSvg,
    )
  ];
}
