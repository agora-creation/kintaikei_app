import 'package:flutter/material.dart';
import 'package:kintaikei_app/providers/home.dart';
import 'package:kintaikei_app/providers/login.dart';
import 'package:kintaikei_app/widgets/bottom_navi_bar.dart';
import 'package:kintaikei_app/widgets/group_dropdown.dart';
import 'package:kintaikei_app/widgets/home_calendar.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;

  const CalendarScreen({
    required this.loginProvider,
    required this.homeProvider,
    super.key,
  });

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 10,
              ),
              child: GroupDropdown(
                value: null,
                groups: widget.loginProvider.groups,
                onChanged: (value) {},
              ),
            ),
            Expanded(
              child: HomeCalendar(
                dataSource: _DataSource([]),
                controller: CalendarController(),
                onLongPress: (value) {},
              ),
            ),
            BottomNaviBar(
              leftLabel: '打刻',
              leftOnTap: () => Navigator.pop(context),
            ),
          ],
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
