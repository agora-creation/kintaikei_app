import 'package:flutter/material.dart';
import 'package:kintaikei_app/common/functions.dart';
import 'package:kintaikei_app/common/style.dart';
import 'package:kintaikei_app/providers/login.dart';
import 'package:kintaikei_app/widgets/time_calendar.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class TimeScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final DateTime date;

  const TimeScreen({
    required this.loginProvider,
    required this.date,
    super.key,
  });

  @override
  State<TimeScreen> createState() => _TimeScreenState();
}

class _TimeScreenState extends State<TimeScreen> {
  List<Appointment> appointments = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        backgroundColor: kWhiteColor,
        automaticallyImplyLeading: false,
        title: Text(convertDateText('yyyy年MM月dd日(E)', widget.date)),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.close,
              color: kBlackColor,
            ),
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
          ),
        ],
        shape: const Border(bottom: BorderSide(color: kGrey300Color)),
      ),
      body: SafeArea(
        child: TimeCalendar(
          initialDisplayDate: widget.date,
          dataSource: _DataSource(appointments),
          onTap: (CalendarTapDetails details) {},
        ),
      ),
    );
  }
}

class _DataSource extends CalendarDataSource {
  _DataSource(List<Appointment> source) {
    appointments = source;
  }
}
