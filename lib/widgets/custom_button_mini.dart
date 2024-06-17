import 'package:flutter/material.dart';

class CustomButtonMini extends StatelessWidget {
  final String label;
  final Color labelColor;
  final Color backgroundColor;
  final Function()? onPressed;

  const CustomButtonMini({
    required this.label,
    required this.labelColor,
    required this.backgroundColor,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 12,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: labelColor,
          fontSize: 16,
          fontWeight: FontWeight.bold,
          fontFamily: 'SourceHanSansJP-Bold',
        ),
      ),
    );
  }
}
