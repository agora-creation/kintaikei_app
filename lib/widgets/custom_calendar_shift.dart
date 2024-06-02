import 'package:flutter/material.dart';
import 'package:kintaikei_app/common/style.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CustomCalendarShift extends StatelessWidget {
  final CalendarDataSource<Object?>? dataSource;
  final Function(CalendarTapDetails)? onTap;

  const CustomCalendarShift({
    required this.dataSource,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SfCalendar(
      headerStyle: const CalendarHeaderStyle(
        backgroundColor: kWhiteColor,
      ),
      dataSource: dataSource,
      view: CalendarView.timelineMonth,
      showDatePickerButton: true,
      showNavigationArrow: true,
      showTodayButton: true,
      headerDateFormat: 'yyyy年MM月',
      onTap: onTap,
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
