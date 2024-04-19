import 'package:flutter/material.dart';
import 'package:kintaikei_app/common/style.dart';

class InfoValue extends StatelessWidget {
  final String value;

  const InfoValue(
    this.value, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: kGrey300Color,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(value),
    );
  }
}
