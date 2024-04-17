import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final Color labelColor;
  final Color backgroundColor;
  final Function()? onPressed;

  const CustomButton({
    required this.label,
    required this.labelColor,
    required this.backgroundColor,
    this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
          padding: const EdgeInsets.symmetric(
            vertical: 16,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: labelColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'SourceHanSansJP-Bold',
          ),
        ),
      ),
    );
  }
}
