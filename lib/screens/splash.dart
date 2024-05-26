import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kintaikei_app/common/style.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Text(
                  '勤怠計',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'SourceHanSansJP-Bold',
                    letterSpacing: 12,
                  ),
                ),
                Text(
                  'スタッフ用アプリ',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            SpinKitPouringHourGlassRefined(color: kBlackColor),
          ],
        ),
      ),
    );
  }
}
