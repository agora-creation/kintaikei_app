import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kintaikei_app/common/functions.dart';
import 'package:kintaikei_app/common/style.dart';
import 'package:kintaikei_app/models/company_group.dart';
import 'package:kintaikei_app/models/work.dart';
import 'package:kintaikei_app/providers/home.dart';
import 'package:kintaikei_app/providers/login.dart';
import 'package:kintaikei_app/screens/work_mod.dart';
import 'package:kintaikei_app/services/picker.dart';
import 'package:kintaikei_app/services/work.dart';
import 'package:kintaikei_app/widgets/custom_footer.dart';
import 'package:kintaikei_app/widgets/group_dropdown.dart';
import 'package:kintaikei_app/widgets/month_picker_button.dart';
import 'package:kintaikei_app/widgets/work_header.dart';
import 'package:page_transition/page_transition.dart';

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
  PickerService pickerService = PickerService();
  WorkService workService = WorkService();
  CompanyGroupModel? currentGroup;
  DateTime searchMonth = DateTime.now();
  List<DateTime> days = [];

  void _changeMonth(DateTime value) {
    searchMonth = value;
    days = generateDays(value);
    setState(() {});
  }

  void _init() {
    currentGroup = widget.homeProvider.currentGroup;
    days = generateDays(searchMonth);
    setState(() {});
  }

  @override
  void initState() {
    _init();
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
                  MonthPickerButton(
                    value: searchMonth,
                    onTap: () async {
                      DateTime? selected = await pickerService.monthPicker(
                        context: context,
                        init: searchMonth,
                      );
                      if (selected == null) return;
                      _changeMonth(selected);
                    },
                  ),
                  const WorkHeader(),
                  StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: workService.streamList(
                      group: widget.homeProvider.currentGroup,
                      user: widget.loginProvider.user,
                      searchMonth: searchMonth,
                    ),
                    builder: (context, snapshot) {
                      List<WorkModel> works = workService.convertList(snapshot);
                      return Expanded(
                        child: ListView.builder(
                          itemCount: days.length,
                          itemBuilder: (context, index) {
                            DateTime day = days[index];
                            List<WorkModel> dayWorks = [];
                            if (works.isNotEmpty) {
                              for (WorkModel work in works) {
                                String dayKey = convertDateText(
                                  'yyyy-MM-dd',
                                  work.startedAt,
                                );
                                if (day == DateTime.parse(dayKey)) {
                                  dayWorks.add(work);
                                }
                              }
                            }
                            return Container(
                              decoration: BoxDecoration(
                                border: const Border(
                                  bottom: BorderSide(color: kGrey300Color),
                                ),
                                color: dayWorks.isNotEmpty
                                    ? kWhiteColor
                                    : kGrey300Color.withOpacity(0.6),
                              ),
                              padding: const EdgeInsets.all(8),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: convertDateText(
                                                'E', day) ==
                                            '土'
                                        ? kLightBlueColor.withOpacity(0.3)
                                        : convertDateText('E', day) == '日'
                                            ? kDeepOrangeColor.withOpacity(0.3)
                                            : Colors.transparent,
                                    radius: 24,
                                    child: Text(
                                      convertDateText('dd(E)', day),
                                      style: const TextStyle(
                                        color: kBlackColor,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: dayWorks.map((dayWork) {
                                        return ListTile(
                                          title: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Text(dayWork.startedTime()),
                                              Text(dayWork.endedTime()),
                                              Text(dayWork.totalTime()),
                                            ],
                                          ),
                                          onTap: () => Navigator.push(
                                            context,
                                            PageTransition(
                                              type: PageTransitionType
                                                  .rightToLeft,
                                              child: WorkModScreen(
                                                loginProvider:
                                                    widget.loginProvider,
                                                homeProvider:
                                                    widget.homeProvider,
                                                work: dayWork,
                                              ),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      );
                    },
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
