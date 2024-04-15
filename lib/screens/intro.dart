import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:kintaikei_app/services/ldb.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  LDBService ldbService = LDBService();

  List<PageViewModel> _getPages() {
    return [
      PageViewModel(
        title: "Title",
        body: "body",
        decoration: const PageDecoration(
          titleTextStyle:
              TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
          bodyTextStyle: TextStyle(fontSize: 20.0),
          pageColor: Color.fromARGB(108, 146, 193, 209),
        ),
      ),
      PageViewModel(
        title: "Title",
        body: "body",
        decoration: const PageDecoration(
          titleTextStyle:
              TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
          bodyTextStyle: TextStyle(fontSize: 20.0),
          pageColor: Color.fromARGB(108, 146, 193, 209),
        ),
      ),
    ];
  }

  Future _setCompleteIntro() async {
    await ldbService.setBool('hasCompletedIntro', true);
  }

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      pages: _getPages(),
      onDone: () async {
        await _setCompleteIntro();
      },
      next: const Icon(Icons.arrow_forward),
      done: const Text('スタート', style: TextStyle(fontWeight: FontWeight.bold)),
      dotsDecorator: DotsDecorator(
        size: const Size.square(10.0),
        activeSize: const Size(20.0, 10.0),
        activeColor: Theme.of(context).primaryColor,
        color: Colors.black26,
        spacing: const EdgeInsets.symmetric(horizontal: 3.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
      ),
    );
  }
}
