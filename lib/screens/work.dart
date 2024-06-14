import 'package:flutter/material.dart';
import 'package:kintaikei_app/common/style.dart';
import 'package:kintaikei_app/models/company_group.dart';
import 'package:kintaikei_app/providers/home.dart';
import 'package:kintaikei_app/providers/login.dart';
import 'package:kintaikei_app/widgets/custom_footer.dart';
import 'package:kintaikei_app/widgets/group_dropdown.dart';
import 'package:kintaikei_app/widgets/month_picker_button.dart';

class WorkScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;

  const WorkScreen({
    required this.loginProvider,
    required this.homeProvider,
    super.key,
  });

  @override
  State<WorkScreen> createState() => _WorkScreenState();
}

class _WorkScreenState extends State<WorkScreen> {
  CompanyGroupModel? currentGroup;
  DateTime searchMonth = DateTime.now();
  List<DateTime> days = [];

  @override
  void initState() {
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
                  const Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Text(
                      '打刻履歴',
                      style: TextStyle(fontWeight: FontWeight.bold),
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
            widget.loginProvider.groups.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
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
                  )
                : Container(),
            Expanded(
              child: Column(
                children: [
                  const MonthPickerButton(),
                  Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: kGrey300Color),
                      ),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: const Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: kWhiteColor,
                          radius: 24,
                          child: Text(
                            '日付',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        Expanded(
                          child: ListTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text('出勤時間'),
                                Text('退勤時間'),
                                Text('勤務時間'),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: 0,
                      itemBuilder: (context, index) {
                        return Container();
                      },
                    ),
                  ),
                ],
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
