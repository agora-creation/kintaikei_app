import 'package:flutter/material.dart';
import 'package:kintaikei_app/common/functions.dart';
import 'package:kintaikei_app/common/style.dart';
import 'package:kintaikei_app/screens/history.dart';
import 'package:kintaikei_app/screens/stamp.dart';
import 'package:kintaikei_app/screens/user.dart';
import 'package:kintaikei_app/widgets/group_select_header.dart';
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
            GroupSelectHeader(
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
                showBottomUpScreen(context, const HistoryScreen());
                break;
              case 1:
                showBottomUpScreen(context, const StampScreen());
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
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () => showBottomUpScreen(context, const StampScreen()),
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
