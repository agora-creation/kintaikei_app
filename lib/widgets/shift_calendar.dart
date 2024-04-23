import 'package:flutter/material.dart';
import 'package:kintaikei_app/common/style.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class ShiftCalendar extends StatelessWidget {
  final CalendarDataSource<Object?>? dataSource;
  final CalendarController? controller;
  final Function(CalendarLongPressDetails)? onLongPress;

  const ShiftCalendar({
    required this.dataSource,
    required this.controller,
    required this.onLongPress,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SfCalendar(
      dataSource: dataSource,
      view: CalendarView.timelineMonth,
      controller: controller,
      showDatePickerButton: true,
      showNavigationArrow: true,
      showTodayButton: true,
      headerDateFormat: 'yyyy年MM月',
      onLongPress: onLongPress,
      resourceViewSettings: const ResourceViewSettings(
        visibleResourceCount: 5,
        showAvatar: false,
        displayNameTextStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          fontFamily: 'SourceHanSansJP-Bold',
        ),
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
    );
  }
}
