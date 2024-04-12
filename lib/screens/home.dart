import 'package:flutter/material.dart';
import 'package:kintaikei_app/common/functions.dart';
import 'package:kintaikei_app/common/style.dart';
import 'package:kintaikei_app/screens/history.dart';
import 'package:kintaikei_app/screens/user.dart';
import 'package:kintaikei_app/widgets/custom_alert_dialog.dart';
import 'package:kintaikei_app/widgets/custom_dropdown.dart';
import 'package:kintaikei_app/widgets/date_time_widget.dart';
import 'package:kintaikei_app/widgets/dialog_action_button.dart';
import 'package:kintaikei_app/widgets/group_select.dart';
import 'package:kintaikei_app/widgets/home_calendar.dart';
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
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GroupSelect(
              label: '(有)アゴラ・クリエーション',
              onTap: () {},
            ),
            HomeCalendar(
              dataSource: _DataSource(appointments),
              controller: calendarController,
              onTap: (CalendarTapDetails details) {},
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) {
          switch (value) {
            case 0:
              showBottomUpScreen(context, const HistoryScreen());
              break;
            case 1:
              showDialog(
                context: context,
                builder: (context) => const StampDialog(),
              );
              break;
            case 2:
              showBottomUpScreen(context, const UserScreen());
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: '履歴',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: '打刻',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '島村裕太',
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => const StampDialog(),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _DataSource extends CalendarDataSource {
  _DataSource(List<Appointment> source) {
    appointments = source;
  }
}

class StampDialog extends StatelessWidget {
  const StampDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomAlertDialog(
      children: [
        const Text(
          '出勤時間を打刻しましょう',
          style: TextStyle(fontSize: 12),
        ),
        const SizedBox(height: 8),
        const CustomDropdown(),
        const SizedBox(height: 8),
        const DateTimeWidget(),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            DialogActionButton(
              label: '出勤する',
              labelColor: kWhiteColor,
              backgroundColor: kBlueColor,
              onPressed: () {},
            ),
            DialogActionButton(
              label: '退勤する',
              labelColor: kWhiteColor,
              backgroundColor: kRedColor,
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }
}
