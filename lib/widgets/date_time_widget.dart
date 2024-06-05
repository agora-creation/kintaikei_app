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
  String date = '--月--日 -曜日';
  String time = '--:--:--';

  void _onTimer(Timer timer) {
    DateTime now = DateTime.now();
    if (mounted) {
      setState(() {
        date = convertDateText('MM月dd日 E曜日', now);
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
            fontSize: 20,
            height: 2,
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
            height: 1,
          ),
        ),
      ],
    );
  }
}
