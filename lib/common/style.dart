import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const kBackColor = Color(0xFFECEFF1);
const kFontColor = Color(0xFF333333);
const kButtonBackColor = Color(0xFF2196F3);
const kButtonFontColor = Color(0xFFFFFFFF);
const kNaviBackColor = Color(0xFFFFFFFF);
const kBorderColor = Color(0xFF757575);
const kIconColor = Color(0xFF757575);
const kAlertBackColor = Color(0xFFFFFFFF);

ThemeData customTheme() {
  return ThemeData(
    scaffoldBackgroundColor: kBackColor,
    fontFamily: 'SourceHanSansJP-Regular',
    appBarTheme: const AppBarTheme(
      backgroundColor: kBackColor,
      elevation: 0,
      centerTitle: false,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      titleTextStyle: TextStyle(
        color: kFontColor,
        fontSize: 18,
        fontWeight: FontWeight.bold,
        fontFamily: 'SourceHanSansJP-Bold',
      ),
      iconTheme: IconThemeData(color: kFontColor),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: kFontColor),
      bodyMedium: TextStyle(color: kFontColor),
      bodySmall: TextStyle(color: kFontColor),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      foregroundColor: kButtonFontColor,
      backgroundColor: kButtonBackColor,
      focusColor: kButtonFontColor,
      hoverColor: kButtonFontColor,
      elevation: 0,
      focusElevation: 0,
      hoverElevation: 0,
      highlightElevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(100),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: kNaviBackColor,
      elevation: 0,
      selectedItemColor: kFontColor,
      unselectedItemColor: kFontColor,
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}

List<String> kWeeks = ['月', '火', '水', '木', '金', '土', '日'];
List<String> kRepeatIntervals = ['毎日', '毎週', '毎月', '毎年'];
List<int> kAlertMinutes = [0, 10, 30, 60];

DateTime kFirstDate = DateTime.now().subtract(const Duration(days: 1095));
DateTime kLastDate = DateTime.now().add(const Duration(days: 1095));
