import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const kBackgroundColor = Color(0xFFECEFF1);
const kFontColor = Color(0xFF212121);
const kAddColor = Color(0xFF2196F3);
const kWhiteColor = Color(0xFFFFFFFF);
const kBorderColor = Color(0xFF757575);

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
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: kAddColor,
      elevation: 5,
      extendedTextStyle: TextStyle(
        color: kWhiteColor,
        fontWeight: FontWeight.bold,
        fontFamily: 'SourceHanSansJP-Bold',
      ),
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    unselectedWidgetColor: kWhiteColor,
  );
}

List<String> kWeeks = ['月', '火', '水', '木', '金', '土', '日'];
List<String> kRepeatIntervals = ['毎日', '毎週', '毎月', '毎年'];
List<int> kAlertMinutes = [0, 10, 30, 60];

DateTime kFirstDate = DateTime.now().subtract(const Duration(days: 1095));
DateTime kLastDate = DateTime.now().add(const Duration(days: 1095));
