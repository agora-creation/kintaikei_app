import 'package:flutter/material.dart';
import 'package:kintaikei_app/common/style.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CustomCalendar extends StatelessWidget {
  final CalendarDataSource<Object?>? dataSource;
  final CalendarController controller;

  const CustomCalendar({
    required this.dataSource,
    required this.controller,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SfCalendar(
        headerStyle: const CalendarHeaderStyle(
          backgroundColor: kWhiteColor,
        ),
        dataSource: dataSource,
        view: CalendarView.month,
        showDatePickerButton: true,
        showNavigationArrow: true,
        headerDateFormat: 'yyyy年MM月',
        controller: controller,
        monthViewSettings: const MonthViewSettings(
          showAgenda: true,
        ),
        cellBorderColor: kGreyColor,
        todayHighlightColor: kMainColor,
        selectionDecoration: BoxDecoration(
          color: kMainColor.withOpacity(0.2),
          border: Border.all(
            color: kMainColor,
            width: 2,
          ),
        ),
      ),
    );
  }
}
