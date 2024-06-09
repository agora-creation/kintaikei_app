import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kintaikei_app/common/style.dart';
import 'package:kintaikei_app/models/company_group.dart';
import 'package:kintaikei_app/models/user.dart';
import 'package:kintaikei_app/providers/home.dart';
import 'package:kintaikei_app/providers/login.dart';
import 'package:kintaikei_app/screens/plan_shift_add.dart';
import 'package:kintaikei_app/screens/plan_shift_mod.dart';
import 'package:kintaikei_app/services/plan.dart';
import 'package:kintaikei_app/services/plan_shift.dart';
import 'package:kintaikei_app/services/user.dart';
import 'package:kintaikei_app/widgets/custom_calendar_shift.dart';
import 'package:kintaikei_app/widgets/custom_footer.dart';
import 'package:kintaikei_app/widgets/group_dropdown.dart';
import 'package:multiple_stream_builder/multiple_stream_builder.dart';
import 'package:page_transition/page_transition.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class PlanShiftScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;

  const PlanShiftScreen({
    required this.loginProvider,
    required this.homeProvider,
    super.key,
  });

  @override
  State<PlanShiftScreen> createState() => _PlanShiftScreenState();
}

class _PlanShiftScreenState extends State<PlanShiftScreen> {
  PlanService planService = PlanService();
  PlanShiftService planShiftService = PlanShiftService();
  UserService userService = UserService();
  CalendarController calendarController = CalendarController();
  CompanyGroupModel? currentGroup;
  List<UserModel> users = [];
  List<CalendarResource> resourceColl = [];

  void _getUsers(CompanyGroupModel? group) async {
    users.clear();
    resourceColl.clear();
    if (group != null) {
      users = await userService.selectListToUserIds(
        userIds: group.userIds,
      );
    } else if (widget.loginProvider.user != null) {
      users.add(widget.loginProvider.user!);
    }
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
    _getUsers(currentGroup);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var planStream = planService.streamList(
      group: currentGroup,
      user: widget.loginProvider.user,
    );
    var planShiftStream = planShiftService.streamList(
      group: currentGroup,
      user: widget.loginProvider.user,
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
                  widget.loginProvider.groups.isNotEmpty
                      ? Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: GroupDropdown(
                              value: currentGroup?.id,
                              groups: widget.loginProvider.groups,
                              onChanged: (value) async {
                                await widget.homeProvider.changeGroup(value);
                                currentGroup = widget.homeProvider.currentGroup;
                                _getUsers(currentGroup);
                              },
                            ),
                          ),
                        )
                      : Container(),
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
                    group: currentGroup,
                    user: widget.loginProvider.user,
                    shiftView: true,
                  );
                  source.addAll(PlanShiftService().convertList(
                    snapshot.snapshot2,
                  ));
                  return SafeArea(
                    child: CustomCalendarShift(
                      dataSource: _ShiftDataSource(source, resourceColl),
                      controller: calendarController,
                      onLongPress: (CalendarLongPressDetails details) {
                        CalendarElement element = details.targetElement;
                        switch (element) {
                          case CalendarElement.appointment:
                          case CalendarElement.agenda:
                            Appointment appointmentDetails =
                                details.appointments![0];
                            Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.rightToLeft,
                                child: PlanShiftModScreen(
                                  loginProvider: widget.loginProvider,
                                  homeProvider: widget.homeProvider,
                                  id: '${appointmentDetails.id}',
                                ),
                              ),
                            );
                            break;
                          case CalendarElement.calendarCell:
                            final userId = details.resource?.id;
                            if (userId == null) return;
                            Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.rightToLeft,
                                child: PlanShiftAddScreen(
                                  loginProvider: widget.loginProvider,
                                  homeProvider: widget.homeProvider,
                                  users: users,
                                  userId: '$userId',
                                  selectedDate: details.date ?? DateTime.now(),
                                ),
                              ),
                            );
                            break;
                          default:
                            break;
                        }
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomFooter(
        loginProvider: widget.loginProvider,
        homeProvider: widget.homeProvider,
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
