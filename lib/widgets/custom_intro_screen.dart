import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

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
      showBottomPart: false,
      freeze: true,
    );
  }
}
