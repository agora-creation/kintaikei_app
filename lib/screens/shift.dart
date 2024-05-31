import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kintaikei_app/common/style.dart';
import 'package:kintaikei_app/models/user.dart';
import 'package:kintaikei_app/providers/home.dart';
import 'package:kintaikei_app/providers/login.dart';
import 'package:kintaikei_app/services/plan.dart';
import 'package:kintaikei_app/services/plan_shift.dart';
import 'package:kintaikei_app/services/user.dart';
import 'package:kintaikei_app/widgets/group_dropdown.dart';
import 'package:kintaikei_app/widgets/shift_calendar.dart';
import 'package:multiple_stream_builder/multiple_stream_builder.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class ShiftScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;

  const ShiftScreen({
    required this.loginProvider,
    required this.homeProvider,
    super.key,
  });

  @override
  State<ShiftScreen> createState() => _ShiftScreenState();
}

class _ShiftScreenState extends State<ShiftScreen> {
  PlanService planService = PlanService();
  PlanShiftService planShiftService = PlanShiftService();
  UserService userService = UserService();
  CalendarController calendarController = CalendarController();
  List<CalendarResource> resourceColl = [];

  void _init() async {
    List<UserModel> users = await userService.selectListToUserIds(
      userIds: widget.homeProvider.currentGroup?.userIds ?? [''],
    );
    if (users.isNotEmpty) {
      for (UserModel user in users) {
        resourceColl.add(CalendarResource(
          displayName: user.name,
          id: user.id,
          color: kGrey300Color,
        ));
      }
    }
    setState(() {});
  }

  @override
  void initState() {
    calendarController.selectedDate = DateTime.now();
    _init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var planStream = planService.streamList(
      group: widget.homeProvider.currentGroup,
      userId: widget.loginProvider.user?.id,
    );
    var planShiftStream = planShiftService.streamList(
      group: widget.homeProvider.currentGroup,
    );
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: GroupDropdown(
                      value: null,
                      groups: widget.loginProvider.groups,
                      onChanged: (value) {},
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () =>
                        Navigator.of(context, rootNavigator: true).pop(),
                  ),
                ],
              ),
            ),
            Expanded(
              child: StreamBuilder2<QuerySnapshot<Map<String, dynamic>>,
                  QuerySnapshot<Map<String, dynamic>>>(
                streams: StreamTuple2(planStream!, planShiftStream!),
                builder: (context, snapshot) {
                  List<Appointment> source = [];
                  source = planService.convertList(
                    snapshot.snapshot1,
                    shiftView: true,
                  );
                  source.addAll(
                      PlanShiftService().convertList(snapshot.snapshot2));
                  return SafeArea(
                    child: ShiftCalendar(
                      dataSource: _ShiftDataSource(source, resourceColl),
                      controller: calendarController,
                      onLongPress: (CalendarLongPressDetails details) {},
                    ),
                  );
                },
              ),
            ),
          ],
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
