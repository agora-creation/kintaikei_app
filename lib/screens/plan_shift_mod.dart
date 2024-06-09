import 'package:flutter/material.dart';
import 'package:kintaikei_app/common/functions.dart';
import 'package:kintaikei_app/common/style.dart';
import 'package:kintaikei_app/models/plan_shift.dart';
import 'package:kintaikei_app/providers/home.dart';
import 'package:kintaikei_app/providers/login.dart';
import 'package:kintaikei_app/providers/plan_shift.dart';
import 'package:kintaikei_app/services/date_time_picker.dart';
import 'package:kintaikei_app/services/plan_shift.dart';
import 'package:kintaikei_app/widgets/alert_dropdown.dart';
import 'package:kintaikei_app/widgets/custom_button.dart';
import 'package:kintaikei_app/widgets/custom_expansion_tile.dart';
import 'package:kintaikei_app/widgets/date_time_range_field.dart';
import 'package:kintaikei_app/widgets/info_label.dart';
import 'package:kintaikei_app/widgets/info_value.dart';
import 'package:kintaikei_app/widgets/link_text.dart';
import 'package:kintaikei_app/widgets/repeat_select_form.dart';
import 'package:provider/provider.dart';

class PlanShiftModScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final String id;

  const PlanShiftModScreen({
    required this.loginProvider,
    required this.homeProvider,
    required this.id,
    super.key,
  });

  @override
  State<PlanShiftModScreen> createState() => _PlanShiftModScreenState();
}

class _PlanShiftModScreenState extends State<PlanShiftModScreen> {
  PlanShiftService planShiftService = PlanShiftService();
  DateTimePickerService pickerService = DateTimePickerService();
  PlanShiftModel? planShift;
  DateTime startedAt = DateTime.now();
  DateTime endedAt = DateTime.now().add(const Duration(hours: 8));
  bool allDay = false;
  bool repeat = false;
  String repeatInterval = kRepeatIntervals.first;
  List<String> repeatWeeks = [];
  int alertMinute = kAlertMinutes[1];

  void _init() async {
    PlanShiftModel? tmpPlanShift =
        await planShiftService.selectToId(id: widget.id);
    if (tmpPlanShift == null) {
      if (!mounted) return;
      showMessage(context, '勤務予定データの取得に失敗しました', false);
      Navigator.pop(context);
      return;
    }
    planShift = tmpPlanShift;
    startedAt = tmpPlanShift.startedAt;
    endedAt = tmpPlanShift.endedAt;
    allDay = tmpPlanShift.allDay;
    repeat = tmpPlanShift.repeat;
    repeatInterval = tmpPlanShift.repeatInterval;
    repeatWeeks = tmpPlanShift.repeatWeeks;
    alertMinute = tmpPlanShift.alertMinute;
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
        title: const Text('勤務予定の編集'),
        shape: const Border(bottom: BorderSide(color: kGrey300Color)),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            InfoLabel(
              label: '勤務予定のスタッフ',
              child: InfoValue(planShift?.userName ?? ''),
            ),
            const SizedBox(height: 8),
            InfoLabel(
              label: '勤務予定時間帯',
              child: DateTimeRangeField(
                startedAt: startedAt,
                startedOnTap: () async => await pickerService.picker(
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
                endedOnTap: () async => await pickerService.picker(
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
              label: '保存する',
              labelColor: kWhiteColor,
              backgroundColor: kBlueColor,
              onPressed: () async {
                String? error = await planShiftProvider.update(
                  id: widget.id,
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
                showMessage(context, '勤務予定を編集しました', true);
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 24),
            Align(
              alignment: Alignment.bottomLeft,
              child: LinkText(
                label: 'この勤務予定を削除する',
                color: kRedColor,
                onTap: () async {
                  String? error = await planShiftProvider.delete(
                    id: widget.id,
                  );
                  if (error != null) {
                    if (!mounted) return;
                    showMessage(context, error, false);
                    return;
                  }
                  if (!mounted) return;
                  showMessage(context, '勤務予定を削除しました', true);
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
