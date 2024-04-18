import 'package:flutter/material.dart';
import 'package:kintaikei_app/common/style.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class TimeCalendar extends StatelessWidget {
  final DateTime initialDisplayDate;
  final CalendarDataSource<Object?>? dataSource;
  final Function(CalendarTapDetails)? onTap;

  const TimeCalendar({
    required this.initialDisplayDate,
    required this.dataSource,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SfCalendar(
      headerHeight: 0,
      viewHeaderHeight: 0,
      viewNavigationMode: ViewNavigationMode.none,
      initialDisplayDate: initialDisplayDate,
      dataSource: dataSource,
      view: CalendarView.day,
      onTap: onTap,
      cellBorderColor: kGreyColor,
      todayHighlightColor: kMainColor,
      selectionDecoration: BoxDecoration(
        color: kMainColor.withOpacity(0.3),
        border: Border.all(
          color: kMainColor,
          width: 2,
        ),
      ),
    );
  }
}
