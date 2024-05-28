import 'package:flutter/material.dart';
import 'package:kintaikei_app/common/style.dart';

class InfoLabel extends StatelessWidget {
  final String label;
  final Widget child;

  const InfoLabel({
    required this.label,
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: kBlackColor,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 4),
        child,
      ],
    );
  }
}
