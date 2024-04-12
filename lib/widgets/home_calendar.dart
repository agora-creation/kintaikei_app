import 'package:flutter/material.dart';
import 'package:kintaikei_app/common/style.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class HomeCalendar extends StatelessWidget {
  final CalendarDataSource<Object?>? dataSource;
  final CalendarController? controller;
  final Function(CalendarTapDetails)? onTap;

  const HomeCalendar({
    required this.dataSource,
    required this.controller,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SfCalendar(
        dataSource: dataSource,
        view: CalendarView.month,
        controller: controller,
        showNavigationArrow: true,
        showDatePickerButton: true,
        headerDateFormat: 'yyyy年MM月',
        onTap: onTap,
        monthViewSettings: const MonthViewSettings(
          showAgenda: true,
          appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
          monthCellStyle: MonthCellStyle(
            textStyle: TextStyle(fontSize: 16),
          ),
        ),
        cellBorderColor: kGreyColor,
        todayHighlightColor: kMainColor,
        selectionDecoration: BoxDecoration(
          color: kMainColor.withOpacity(0.3),
          border: Border.all(
            color: kMainColor,
            width: 2,
          ),
        ),
      ),
    );
  }
}
