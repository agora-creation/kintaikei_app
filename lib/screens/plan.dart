import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kintaikei_app/models/company_group.dart';
import 'package:kintaikei_app/providers/home.dart';
import 'package:kintaikei_app/providers/login.dart';
import 'package:kintaikei_app/services/plan.dart';
import 'package:kintaikei_app/widgets/custom_calendar.dart';
import 'package:kintaikei_app/widgets/group_dropdown.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class PlanScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;

  const PlanScreen({
    required this.loginProvider,
    required this.homeProvider,
    super.key,
  });

  @override
  State<PlanScreen> createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
  PlanService planService = PlanService();
  CalendarController calendarController = CalendarController();
  CompanyGroupModel? currentGroup;

  @override
  void initState() {
    calendarController.selectedDate = DateTime.now();
    currentGroup = widget.homeProvider.currentGroup;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: planService.streamList(
                  group: currentGroup,
                  user: widget.loginProvider.user,
                ),
                builder: (context, snapshot) {
                  List<Appointment> appointments =
                      planService.convertListCalendar(
                    snapshot,
                    group: currentGroup,
                    user: widget.loginProvider.user,
                  );
                  return CustomCalendar(
                    dataSource: _DataSource(appointments),
                    controller: calendarController,
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

class _DataSource extends CalendarDataSource {
  _DataSource(List<Appointment> source) {
    appointments = source;
  }
}
