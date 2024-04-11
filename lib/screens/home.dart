import 'package:flutter/material.dart';
import 'package:kintaikei_app/common/style.dart';
import 'package:kintaikei_app/widgets/custom_alert_dialog.dart';
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
        onTap: (value) {},
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.check),
            label: '申請',
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
        Text(
          '出勤時間を打刻しましょう',
          style: TextStyle(fontSize: 14),
        ),
        SizedBox(height: 8),
        Text(
          '16:00',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            letterSpacing: 4,
          ),
        ),
        Text(
          '2024/04/11 (木)',
          style: TextStyle(fontSize: 14),
        ),
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                backgroundColor: kButtonBackColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 16,
                ),
              ),
              child: Text(
                '出勤する',
                style: TextStyle(
                  color: kButtonFontColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
