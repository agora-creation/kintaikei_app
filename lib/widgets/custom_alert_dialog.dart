import 'package:flutter/material.dart';
import 'package:kintaikei_app/common/style.dart';

class CustomAlertDialog extends StatelessWidget {
  final List<Widget> children;

  const CustomAlertDialog({
    required this.children,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: kAlertBackColor,
      surfaceTintColor: kAlertBackColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: children,
      ),
    );
  }
}
