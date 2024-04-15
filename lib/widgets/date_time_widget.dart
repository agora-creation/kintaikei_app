import 'package:flutter/material.dart';

class DateTimeWidget extends StatelessWidget {
  const DateTimeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          '2024/04/11 (木)',
          style: TextStyle(fontSize: 18),
        ),
        Text(
          '16:00',
          style: TextStyle(
            fontSize: 42,
            fontWeight: FontWeight.bold,
            fontFamily: 'SourceHanSansJP-Bold',
            letterSpacing: 4,
          ),
        ),
      ],
    );
  }
}
