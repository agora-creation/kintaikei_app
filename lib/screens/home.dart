import 'package:flutter/material.dart';
import 'package:kintaikei_app/common/style.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Appointment> appointments = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: SfCalendar(
          dataSource: _DataSource(appointments),
          view: CalendarView.month,
          showNavigationArrow: true,
          showDatePickerButton: true,
          headerDateFormat: 'yyyy年MM月',
          onTap: (CalendarTapDetails details) {},
          monthViewSettings: const MonthViewSettings(
            appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
            monthCellStyle: MonthCellStyle(
              textStyle: TextStyle(fontSize: 16),
            ),
          ),
          cellBorderColor: kBorderColor,
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
