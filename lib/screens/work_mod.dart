import 'package:flutter/material.dart';
import 'package:kintaikei_app/common/functions.dart';
import 'package:kintaikei_app/common/style.dart';
import 'package:kintaikei_app/models/work.dart';
import 'package:kintaikei_app/models/work_break.dart';
import 'package:kintaikei_app/providers/home.dart';
import 'package:kintaikei_app/providers/login.dart';
import 'package:kintaikei_app/providers/work.dart';
import 'package:kintaikei_app/screens/work_breaks_mod.dart';
import 'package:kintaikei_app/services/picker.dart';
import 'package:kintaikei_app/widgets/custom_button.dart';
import 'package:kintaikei_app/widgets/date_time_range_field.dart';
import 'package:kintaikei_app/widgets/info_label.dart';
import 'package:kintaikei_app/widgets/info_value.dart';
import 'package:kintaikei_app/widgets/link_text.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class WorkModScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final WorkModel work;

  const WorkModScreen({
    required this.loginProvider,
    required this.homeProvider,
    required this.work,
    super.key,
  });

  @override
  State<WorkModScreen> createState() => _WorkModScreenState();
}

class _WorkModScreenState extends State<WorkModScreen> {
  PickerService pickerService = PickerService();
  DateTime startedAt = DateTime.now();
  DateTime endedAt = DateTime.now().add(const Duration(hours: 8));
  List<WorkBreakModel> workBreaks = [];

  void _init() {
    startedAt = widget.work.startedAt;
    endedAt = widget.work.endedAt;
    workBreaks = widget.work.workBreaks;
    setState(() {});
  }

  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final workProvider = Provider.of<WorkProvider>(context);
    String workBreaksTime = '00:00';
    if (workBreaks.isNotEmpty) {
      for (WorkBreakModel workBreak in workBreaks) {
        workBreaksTime = addTime(workBreaksTime, workBreak.totalTime());
      }
    }
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text('打刻情報の編集'),
        shape: const Border(bottom: BorderSide(color: kGrey300Color)),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            InfoLabel(
              label: '勤務時間',
              child: InfoValue(widget.work.totalTime()),
            ),
            const SizedBox(height: 8),
            InfoLabel(
              label: '出勤時間 ～ 退勤時間',
              child: DateTimeRangeField(
                startedAt: startedAt,
                startedOnTap: () async => await pickerService.dateTimePicker(
                  context: context,
                  init: startedAt,
                  title: '出勤時間を選択',
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
                  title: '退勤時間を選択',
                  onChanged: (value) {
                    if (startedAt.millisecondsSinceEpoch <
                        value.millisecondsSinceEpoch) {
                      endedAt = value;
                      setState(() {});
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 8),
            InfoLabel(
              label: '合計休憩時間',
              child: InfoValue(
                workBreaksTime,
                icon: Icons.edit,
                onTap: () => Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.rightToLeft,
                    child: WorkBreaksModScreen(
                      workBreaks: workBreaks,
                    ),
                  ),
                ).then((value) {
                  if (value == null) return;
                  setState(() {
                    workBreaks = value;
                  });
                }),
              ),
            ),
            const SizedBox(height: 16),
            CustomButton(
              label: '保存する',
              labelColor: kWhiteColor,
              backgroundColor: kBlueColor,
              onPressed: () async {
                String? error = await workProvider.update(
                  work: widget.work,
                  startedAt: startedAt,
                  endedAt: endedAt,
                  workBreaks: workBreaks,
                );
                if (error != null) {
                  if (!mounted) return;
                  showMessage(context, error, false);
                  return;
                }
                if (!mounted) return;
                showMessage(context, '打刻情報を編集しました', true);
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 24),
            Align(
              alignment: Alignment.bottomLeft,
              child: LinkText(
                label: 'この打刻情報を削除する',
                color: kRedColor,
                onTap: () async {
                  String? error = await workProvider.delete(
                    work: widget.work,
                  );
                  if (error != null) {
                    if (!mounted) return;
                    showMessage(context, error, false);
                    return;
                  }
                  if (!mounted) return;
                  showMessage(context, '打刻情報を削除しました', true);
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
