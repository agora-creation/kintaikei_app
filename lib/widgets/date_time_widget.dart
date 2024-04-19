import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kintaikei_app/common/functions.dart';
import 'package:kintaikei_app/common/style.dart';

class DateTimeWidget extends StatefulWidget {
  const DateTimeWidget({super.key});

  @override
  State<DateTimeWidget> createState() => _DateTimeWidgetState();
}

class _DateTimeWidgetState extends State<DateTimeWidget> {
  String date = '----/--/-- (-)';
  String time = '--:--:--';

  void _onTimer(Timer timer) {
    DateTime now = DateTime.now();
    if (mounted) {
      setState(() {
        date = convertDateText('yyyy/MM/dd (E)', now);
        time = convertDateText('HH:mm:ss', now);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 1), _onTimer);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          date,
          style: const TextStyle(
            color: kGrey600Color,
            fontSize: 18,
          ),
        ),
        Text(
          time,
          style: const TextStyle(
            color: kGrey600Color,
            fontSize: 40,
            fontWeight: FontWeight.bold,
            fontFamily: 'SourceHanSansJP-Bold',
            letterSpacing: 2,
          ),
        ),
      ],
    );
  }
}
