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
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: SfCalendar(
          dataSource: dataSource,
          view: CalendarView.month,
          controller: controller,
          showDatePickerButton: true,
          headerDateFormat: 'yyyy年MM月',
          onLongPress: onLongPress,
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
      ),
    );
  }
}
