import 'dart:math';

import 'package:alert_banner/exports.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kintaikei_app/widgets/custom_alert_banner.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:package_info_plus/package_info_plus.dart';

void showMessage(BuildContext context, String msg, bool success) {
  showAlertBanner(
    context,
    () {},
    CustomAlertBanner(msg: msg, success: success),
    alertBannerLocation: AlertBannerLocation.top,
  );
}

void pushScreen(BuildContext context, Widget widget) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => widget,
      fullscreenDialog: true,
    ),
  );
}

void pushReplacementScreen(BuildContext context, Widget widget) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => widget,
      fullscreenDialog: true,
    ),
  );
}

Future showBottomUpScreen(BuildContext context, Widget widget) async {
  await showMaterialModalBottomSheet(
    expand: true,
    isDismissible: false,
    enableDrag: false,
    context: context,
    builder: (context) => widget,
  );
}

String convertDateText(String format, DateTime? date) {
  String ret = '';
  if (date != null) {
    ret = DateFormat(format, 'ja').format(date);
  }
  return ret;
}

String generatePassword(int length) {
  const chars =
      'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
  const charsLength = chars.length;
  final units = List.generate(
    length,
    (index) {
      final n = Random().nextInt(charsLength);
      return chars.codeUnitAt(n);
    },
  );
  return String.fromCharCodes(units);
}

Future<String> getVersionInfo() async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  return '${packageInfo.version}(${packageInfo.buildNumber})';
}
