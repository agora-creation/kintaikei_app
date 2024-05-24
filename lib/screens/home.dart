import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kintaikei_app/common/functions.dart';
import 'package:kintaikei_app/common/style.dart';
import 'package:kintaikei_app/providers/home.dart';
import 'package:kintaikei_app/providers/login.dart';

import 'package:kintaikei_app/screens/plan_add.dart';
import 'package:kintaikei_app/screens/shift.dart';
import 'package:kintaikei_app/screens/stamp.dart';
import 'package:kintaikei_app/screens/user.dart';
import 'package:kintaikei_app/services/plan.dart';
import 'package:kintaikei_app/widgets/group_dropdown.dart';
import 'package:kintaikei_app/widgets/home_calendar.dart';
import 'package:kintaikei_app/widgets/shift_button.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PlanService planService = PlanService();
  CalendarController calendarController = CalendarController();

  @override
  void initState() {
    calendarController.selectedDate = DateTime.now();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LoginProvider>(context);
    final homeProvider = Provider.of<HomeProvider>(context);
    Color buttonBackColor = kBlueColor;
    Color buttonLabelColor = kWhiteColor;
    if (loginProvider.user?.getWorkStatus() == 0) {
      buttonBackColor = kBlueColor;
      buttonLabelColor = kWhiteColor;
    } else if (loginProvider.user?.getWorkStatus() == 1) {
      buttonBackColor = kRedColor;
      buttonLabelColor = kWhiteColor;
    } else if (loginProvider.user?.getWorkStatus() == 2) {
      buttonBackColor = kYellowColor;
      buttonLabelColor = kBlackColor;
    }
    return FutureBuilder(
      future: homeProvider.initGroup(loginProvider.groups),
      builder: (context, snapshot) {
        return Scaffold(
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: GroupDropdown(
                          value: homeProvider.currentGroup,
                          groups: loginProvider.groups,
                          onChanged: (value) => homeProvider.changeGroup(value),
                        ),
                      ),
                      homeProvider.currentGroup != null
                          ? ShiftButton(
                              onTap: () => showBottomUpScreen(
                                context,
                                ShiftScreen(
                                  loginProvider: loginProvider,
                                  group: homeProvider.currentGroup,
                                ),
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ),
                StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: planService.streamList(
                    group: homeProvider.currentGroup,
                    userId: loginProvider.user?.id,
                  ),
                  builder: (context, snapshot) {
                    List<Appointment> appointments =
                        planService.convertList(snapshot);
                    return HomeCalendar(
                      dataSource: _DataSource(appointments),
                      controller: calendarController,
                      onLongPress: (CalendarLongPressDetails details) {
                        if (homeProvider.currentGroup != null) return;
                        showBottomUpScreen(
                          context,
                          PlanAddScreen(
                            loginProvider: loginProvider,
                            homeProvider: homeProvider,
                            date: details.date ?? DateTime.now(),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          bottomNavigationBar: Container(
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: kGrey300Color),
              ),
            ),
            child: BottomNavigationBar(
              onTap: (value) {
                switch (value) {
                  case 0:
                    break;
                  case 1:
                    showBottomUpScreen(
                      context,
                      StampScreen(
                        loginProvider: loginProvider,
                        homeProvider: homeProvider,
                      ),
                    );
                    break;
                  case 2:
                    showBottomUpScreen(
                      context,
                      UserScreen(
                        loginProvider: loginProvider,
                        homeProvider: homeProvider,
                      ),
                    );
                    break;
                }
              },
              items: [
                const BottomNavigationBarItem(
                  icon: Icon(Icons.list),
                  label: '申請',
                ),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.add),
                  label: '打刻',
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.person),
                  label: loginProvider.user?.name ?? '',
                ),
              ],
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: FloatingActionButton(
            backgroundColor: buttonBackColor,
            onPressed: () => showBottomUpScreen(
              context,
              StampScreen(
                loginProvider: loginProvider,
                homeProvider: homeProvider,
              ),
            ),
            child: Icon(
              Icons.add,
              color: buttonLabelColor,
            ),
          ),
        );
      },
    );
  }
}

class _DataSource extends CalendarDataSource {
  _DataSource(List<Appointment> source) {
    appointments = source;
  }
}
