import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:kintaikei_app/common/style.dart';

class CustomIntroScreen extends StatelessWidget {
  final Key introKey;
  final List<PageViewModel> pages;

  const CustomIntroScreen({
    required this.introKey,
    required this.pages,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      key: introKey,
      pages: pages,
      showSkipButton: false,
      showNextButton: false,
      showDoneButton: false,
      showBackButton: false,
      freeze: true,
      dotsDecorator: DotsDecorator(
        size: const Size.square(10),
        activeSize: const Size(25, 10),
        activeColor: kMainColor,
        color: kGreyColor,
        spacing: const EdgeInsets.symmetric(horizontal: 3),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
      ),
    );
  }
}
