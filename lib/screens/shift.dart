import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kintaikei_app/common/style.dart';
import 'package:kintaikei_app/models/company_group.dart';
import 'package:kintaikei_app/models/user.dart';
import 'package:kintaikei_app/providers/home.dart';
import 'package:kintaikei_app/providers/login.dart';
import 'package:kintaikei_app/services/plan.dart';
import 'package:kintaikei_app/services/plan_shift.dart';
import 'package:kintaikei_app/services/user.dart';
import 'package:kintaikei_app/widgets/custom_calendar_shift.dart';
import 'package:kintaikei_app/widgets/group_dropdown.dart';
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
  CompanyGroupModel? currentGroup;
  List<CalendarResource> resourceColl = [];

  void _getUsers() async {
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
    currentGroup = widget.homeProvider.currentGroup;
    calendarController.selectedDate = DateTime.now();
    _getUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var planStream = planService.streamList(
      group: widget.homeProvider.currentGroup,
      user: widget.loginProvider.user,
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
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: GroupDropdown(
                        value: currentGroup?.id,
                        groups: widget.loginProvider.groups,
                        onChanged: (value) async {
                          await widget.homeProvider.changeGroup(value);
                          setState(() {
                            currentGroup = widget.homeProvider.currentGroup;
                          });
                        },
                      ),
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
                  source = planService.convertListCalendar(
                    snapshot.snapshot1,
                    shiftView: true,
                  );
                  source.addAll(PlanShiftService().convertList(
                    snapshot.snapshot2,
                  ));
                  return SafeArea(
                    child: CustomCalendarShift(
                      dataSource: _ShiftDataSource(source, resourceColl),
                      controller: calendarController,
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
