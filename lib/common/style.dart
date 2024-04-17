import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const kBackgroundColor = Color(0xFFFFFFFF);
const kMainColor = Color(0xFF333333);
const kBlackColor = Color(0xFF333333);
const kGreyColor = Color(0xFF9E9E9E);
const kGrey300Color = Color(0xFFE0E0E0);
const kGrey600Color = Color(0xFF757575);
const kWhiteColor = Color(0xFFFFFFFF);
const kBlueColor = Color(0xFF2196F3);
const kRedColor = Color(0xFFF44336);

ThemeData customTheme() {
  return ThemeData(
    scaffoldBackgroundColor: kBackgroundColor,
    fontFamily: 'SourceHanSansJP-Regular',
    appBarTheme: const AppBarTheme(
      backgroundColor: kBackgroundColor,
      elevation: 0,
      centerTitle: false,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      titleTextStyle: TextStyle(
        color: kBlackColor,
        fontSize: 18,
        fontWeight: FontWeight.bold,
        fontFamily: 'SourceHanSansJP-Bold',
      ),
      iconTheme: IconThemeData(color: kBlackColor),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: kBlackColor),
      bodyMedium: TextStyle(color: kBlackColor),
      bodySmall: TextStyle(color: kBlackColor),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      foregroundColor: kWhiteColor,
      backgroundColor: kBlueColor,
      focusColor: kWhiteColor,
      hoverColor: kWhiteColor,
      elevation: 0,
      focusElevation: 0,
      hoverElevation: 0,
      highlightElevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(100),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: kWhiteColor,
      elevation: 0,
      selectedItemColor: kBlackColor,
      unselectedItemColor: kBlackColor,
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}

List<String> kWeeks = ['月', '火', '水', '木', '金', '土', '日'];
List<String> kRepeatIntervals = ['毎日', '毎週', '毎月', '毎年'];
List<int> kAlertMinutes = [0, 10, 30, 60];

DateTime kFirstDate = DateTime.now().subtract(const Duration(days: 1095));
DateTime kLastDate = DateTime.now().add(const Duration(days: 1095));

const kWatchImageUrl =
    'https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgfALktBXFm5A7QFVyExrpaJQauav4dleIUjY7xv14bEVDBAYaCeuoBEjJFmWPHzNytrXBuXAfQ5xB-GJ2dh7MZ_Zf8EKVsYRsTSxLV4bC2xoLkLc-9PvpeNflxhhsUoD2kfdd0LIqGjGM/s800/stopwatch.png';
const kIntroStyle = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.bold,
  fontFamily: 'SourceHanSansJP-Bold',
);
