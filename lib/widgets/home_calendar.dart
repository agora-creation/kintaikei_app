import 'package:flutter/material.dart';
import 'package:kintaikei_app/common/style.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class HomeCalendar extends StatelessWidget {
  final CalendarDataSource<Object?>? dataSource;
  final CalendarController? controller;
  final Function(CalendarLongPressDetails)? onLongPress;

  const HomeCalendar({
    required this.dataSource,
    required this.controller,
    required this.onLongPress,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SfCalendar(
        dataSource: dataSource,
        view: CalendarView.month,
        controller: controller,
        showDatePickerButton: true,
        showNavigationArrow: true,
        showTodayButton: true,
        headerDateFormat: 'yyyy年MM月',
        onLongPress: onLongPress,
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
