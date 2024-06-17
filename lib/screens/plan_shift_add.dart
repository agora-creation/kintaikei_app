import 'package:flutter/material.dart';
import 'package:kintaikei_app/common/functions.dart';
import 'package:kintaikei_app/common/style.dart';
import 'package:kintaikei_app/models/user.dart';
import 'package:kintaikei_app/providers/home.dart';
import 'package:kintaikei_app/providers/login.dart';
import 'package:kintaikei_app/providers/plan_shift.dart';
import 'package:kintaikei_app/services/picker.dart';
import 'package:kintaikei_app/widgets/alert_dropdown.dart';
import 'package:kintaikei_app/widgets/custom_button.dart';
import 'package:kintaikei_app/widgets/custom_expansion_tile.dart';
import 'package:kintaikei_app/widgets/date_time_range_field.dart';
import 'package:kintaikei_app/widgets/info_label.dart';
import 'package:kintaikei_app/widgets/repeat_select_form.dart';
import 'package:provider/provider.dart';

class PlanShiftAddScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final List<UserModel> users;
  final String userId;
  final DateTime selectedDate;

  const PlanShiftAddScreen({
    required this.loginProvider,
    required this.homeProvider,
    required this.users,
    required this.userId,
    required this.selectedDate,
    super.key,
  });

  @override
  State<PlanShiftAddScreen> createState() => _PlanShiftAddScreenState();
}

class _PlanShiftAddScreenState extends State<PlanShiftAddScreen> {
  PickerService pickerService = PickerService();
  List<UserModel> selectedUsers = [];
  DateTime startedAt = DateTime.now();
  DateTime endedAt = DateTime.now().add(const Duration(hours: 8));
  bool allDay = false;
  bool repeat = false;
  String repeatInterval = kRepeatIntervals.first;
  List<String> repeatWeeks = [];
  int alertMinute = kAlertMinutes[1];

  void _init() async {
    selectedUsers = [widget.users.singleWhere((e) => e.id == widget.userId)];
    startedAt = DateTime(
      widget.selectedDate.year,
      widget.selectedDate.month,
      widget.selectedDate.day,
      8,
      0,
      0,
    );
    endedAt = startedAt.add(const Duration(hours: 8));
    setState(() {});
  }

  void _allDayChange(bool? value) {
    allDay = value ?? false;
    if (allDay) {
      startedAt = DateTime(
        startedAt.year,
        startedAt.month,
        startedAt.day,
        0,
        0,
        0,
      );
      endedAt = DateTime(
        endedAt.year,
        endedAt.month,
        endedAt.day,
        23,
        59,
        59,
      );
    }
    setState(() {});
  }

  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final planShiftProvider = Provider.of<PlanShiftProvider>(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text('勤務予定の追加'),
        shape: const Border(bottom: BorderSide(color: kGrey300Color)),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            InfoLabel(
              label: '勤務予定のスタッフを選択',
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: kGrey300Color),
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 200),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: widget.users.length,
                    itemBuilder: (context, index) {
                      UserModel user = widget.users[index];
                      return Container(
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: kGrey300Color),
                          ),
                        ),
                        child: CheckboxListTile(
                          title: Text(user.name),
                          value: selectedUsers.contains(user),
                          onChanged: (value) {
                            if (selectedUsers.contains(user)) {
                              selectedUsers.remove(user);
                            } else {
                              selectedUsers.add(user);
                            }
                            setState(() {});
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            InfoLabel(
              label: '勤務予定時間帯',
              child: DateTimeRangeField(
                startedAt: startedAt,
                startedOnTap: () async => await pickerService.dateTimePicker(
                  context: context,
                  init: startedAt,
                  title: '勤務予定開始時間を選択',
                  onChanged: (value) {
                    if (value.millisecondsSinceEpoch <
                        endedAt.millisecondsSinceEpoch) {
                      startedAt = value;
                      setState(() {});
                    }
                  },
                ),
                endedAt: endedAt,
                endedOnTap: () async => await pickerService.dateTimePicker(
                  context: context,
                  init: endedAt,
                  title: '勤務予定終了時間を選択',
                  onChanged: (value) {
                    if (startedAt.millisecondsSinceEpoch <
                        value.millisecondsSinceEpoch) {
                      endedAt = value;
                      setState(() {});
                    }
                  },
                ),
                allDay: allDay,
                allDayOnChanged: _allDayChange,
              ),
            ),
            const SizedBox(height: 8),
            CustomExpansionTile(
              label: '詳細設定',
              children: [
                InfoLabel(
                  label: '繰り返し設定',
                  child: RepeatSelectForm(
                    repeat: repeat,
                    repeatOnChanged: (value) {
                      setState(() {
                        repeat = value!;
                      });
                    },
                    interval: repeatInterval,
                    intervalOnChanged: (value) {
                      setState(() {
                        repeatInterval = value;
                      });
                    },
                    weeks: repeatWeeks,
                    weeksOnChanged: (value) {
                      if (repeatWeeks.contains(value)) {
                        repeatWeeks.remove(value);
                      } else {
                        repeatWeeks.add(value);
                      }
                      setState(() {});
                    },
                  ),
                ),
                const SizedBox(height: 8),
                InfoLabel(
                  label: '事前アラート通知',
                  child: AlertDropdown(
                    value: alertMinute,
                    onChanged: (value) {
                      setState(() {
                        alertMinute = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            CustomButton(
              label: '追加する',
              labelColor: kWhiteColor,
              backgroundColor: kBlueColor,
              onPressed: () async {
                String? error = await planShiftProvider.create(
                  group: widget.homeProvider.currentGroup,
                  users: selectedUsers,
                  startedAt: startedAt,
                  endedAt: endedAt,
                  allDay: allDay,
                  repeat: repeat,
                  repeatInterval: repeatInterval,
                  repeatWeeks: repeatWeeks,
                  alertMinute: alertMinute,
                );
                if (error != null) {
                  if (!mounted) return;
                  showMessage(context, error, false);
                  return;
                }
                if (!mounted) return;
                showMessage(context, '勤務予定を追加しました', true);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
