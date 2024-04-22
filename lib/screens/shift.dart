import 'package:flutter/material.dart';
import 'package:kintaikei_app/common/style.dart';
import 'package:kintaikei_app/widgets/shift_calendar.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class ShiftScreen extends StatefulWidget {
  const ShiftScreen({super.key});

  @override
  State<ShiftScreen> createState() => _ShiftScreenState();
}

class _ShiftScreenState extends State<ShiftScreen> {
  CalendarController calendarController = CalendarController();
  List<CalendarResource> resourceColl = [];
  List<Appointment> source = [];

  @override
  void initState() {
    super.initState();
    calendarController.selectedDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        backgroundColor: kWhiteColor,
        automaticallyImplyLeading: false,
        title: const Text('シフト表'),
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
        child: ShiftCalendar(
          dataSource: _ShiftDataSource(source, resourceColl),
          controller: calendarController,
          onLongPress: (CalendarLongPressDetails details) {},
        ),
      ),
    );
  }
}

class _ShiftDataSource extends CalendarDataSource {
  _ShiftDataSource(
    List<Appointment> source,
    List<CalendarResource> resourceColl,
  ) {
    appointments = source;
    resources = resourceColl;
  }
}
