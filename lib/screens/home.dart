import 'package:flutter/material.dart';
import 'package:kintaikei_app/common/functions.dart';
import 'package:kintaikei_app/common/style.dart';
import 'package:kintaikei_app/models/company_group.dart';
import 'package:kintaikei_app/providers/home.dart';
import 'package:kintaikei_app/providers/login.dart';
import 'package:kintaikei_app/screens/shift.dart';
import 'package:kintaikei_app/screens/stamp.dart';
import 'package:kintaikei_app/screens/time.dart';
import 'package:kintaikei_app/screens/user.dart';
import 'package:kintaikei_app/widgets/custom_alert_dialog.dart';
import 'package:kintaikei_app/widgets/group_radio_list_tile.dart';
import 'package:kintaikei_app/widgets/group_select_header.dart';
import 'package:kintaikei_app/widgets/home_calendar.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CalendarController calendarController = CalendarController();
  List<Appointment> appointments = [];

  @override
  void initState() {
    super.initState();
    calendarController.selectedDate = DateTime.now();
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
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GroupSelectHeader(
              currentGroup: homeProvider.currentGroup,
              onTap: () => showDialog(
                context: context,
                builder: (context) => GroupSelectDialog(
                  loginProvider: loginProvider,
                  homeProvider: homeProvider,
                ),
              ),
            ),
            HomeCalendar(
              dataSource: _DataSource(appointments),
              controller: calendarController,
              onLongPress: (CalendarLongPressDetails details) {
                showBottomUpScreen(
                  context,
                  TimeScreen(
                    loginProvider: loginProvider,
                    date: details.date ?? DateTime.now(),
                  ),
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
                showBottomUpScreen(context, const ShiftScreen());
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
              label: 'シフト表',
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
  }
}

class _DataSource extends CalendarDataSource {
  _DataSource(List<Appointment> source) {
    appointments = source;
  }
}

class GroupSelectDialog extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;

  const GroupSelectDialog({
    required this.loginProvider,
    required this.homeProvider,
    super.key,
  });

  @override
  State<GroupSelectDialog> createState() => _GroupSelectDialogState();
}

class _GroupSelectDialogState extends State<GroupSelectDialog> {
  @override
  Widget build(BuildContext context) {
    List<Widget> children = [
      GroupRadioListTile(
        group: null,
        value: widget.homeProvider.currentGroup,
        onChanged: (value) {
          widget.homeProvider.changeGroup(value);
          Navigator.pop(context);
        },
      ),
    ];
    if (widget.loginProvider.groups.isNotEmpty) {
      for (CompanyGroupModel group in widget.loginProvider.groups) {
        children.add(GroupRadioListTile(
          group: group,
          value: widget.homeProvider.currentGroup,
          onChanged: (value) {
            widget.homeProvider.changeGroup(value);
            Navigator.pop(context);
          },
        ));
      }
    }
    return CustomAlertDialog(
      children: [
        const Text('選択した勤務先の予定が、カレンダーに表示されます。'),
        const SizedBox(height: 8),
        Container(
          decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: kGreyColor)),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }
}
