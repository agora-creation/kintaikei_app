import 'package:flutter/material.dart';
import 'package:kintaikei_app/common/functions.dart';
import 'package:kintaikei_app/common/style.dart';
import 'package:kintaikei_app/models/work_break.dart';
import 'package:kintaikei_app/services/picker.dart';
import 'package:kintaikei_app/widgets/custom_button.dart';
import 'package:kintaikei_app/widgets/custom_button_mini.dart';
import 'package:kintaikei_app/widgets/date_time_range_field.dart';
import 'package:kintaikei_app/widgets/info_label.dart';
import 'package:kintaikei_app/widgets/info_value.dart';

class WorkBreaksModScreen extends StatefulWidget {
  final List<WorkBreakModel> workBreaks;

  const WorkBreaksModScreen({
    required this.workBreaks,
    super.key,
  });

  @override
  State<WorkBreaksModScreen> createState() => _WorkBreaksModScreenState();
}

class _WorkBreaksModScreenState extends State<WorkBreaksModScreen> {
  PickerService pickerService = PickerService();
  List<WorkBreakModel> workBreaks = [];

  void _init() {
    workBreaks = widget.workBreaks;
    setState(() {});
  }

  void _add() {
    DateTime startedAt = DateTime.now();
    DateTime endedAt = DateTime.now().add(const Duration(hours: 1));
    workBreaks.add(WorkBreakModel.addMap({
      'id': '',
      'startedAt': startedAt,
      'endedAt': endedAt,
    }));
    setState(() {});
  }

  void _remove() {
    workBreaks.removeLast();
    setState(() {});
  }

  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
        title: const Text('合計休憩時間の編集'),
        shape: const Border(bottom: BorderSide(color: kGrey300Color)),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            InfoLabel(
              label: '合計休憩時間',
              child: InfoValue(workBreaksTime),
            ),
            const SizedBox(height: 8),
            Column(
              children: workBreaks.map((workBreak) {
                return InfoLabel(
                  label: '休憩開始時間 ～ 休憩終了時間',
                  child: DateTimeRangeField(
                    startedAt: workBreak.startedAt,
                    startedOnTap: () async =>
                        await pickerService.dateTimePicker(
                      context: context,
                      init: workBreak.startedAt,
                      title: '休憩開始時間を選択',
                      onChanged: (value) {
                        if (value.millisecondsSinceEpoch <
                            workBreak.endedAt.millisecondsSinceEpoch) {
                          workBreak.startedAt = value;
                          setState(() {});
                        }
                      },
                    ),
                    endedAt: workBreak.endedAt,
                    endedOnTap: () async => await pickerService.dateTimePicker(
                      context: context,
                      init: workBreak.endedAt,
                      title: '休憩終了時間を選択',
                      onChanged: (value) {
                        if (workBreak.startedAt.millisecondsSinceEpoch <
                            value.millisecondsSinceEpoch) {
                          workBreak.endedAt = value;
                          setState(() {});
                        }
                      },
                    ),
                  ),
                );
              }).toList(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomButtonMini(
                  label: '休憩削除',
                  labelColor: kWhiteColor,
                  backgroundColor: kRedColor,
                  onPressed: () => _remove(),
                ),
                CustomButtonMini(
                  label: '休憩追加',
                  labelColor: kWhiteColor,
                  backgroundColor: kBlueColor,
                  onPressed: () => _add(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            CustomButton(
              label: '保存する',
              labelColor: kWhiteColor,
              backgroundColor: kBlueColor,
              onPressed: () => Navigator.pop(context, workBreaks),
            ),
          ],
        ),
      ),
    );
  }
}
