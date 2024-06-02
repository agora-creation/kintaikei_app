import 'package:flutter/material.dart';
import 'package:kintaikei_app/common/style.dart';

class SettingHeader extends StatelessWidget {
  final String label;

  const SettingHeader(
    this.label, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Text(
        label,
        style: const TextStyle(
          color: kBlackColor,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          fontFamily: 'SourceHanSansJP-Bold',
        ),
      ),
    );
  }
}
