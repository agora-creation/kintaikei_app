import 'package:flutter/material.dart';
import 'package:kintaikei_app/common/functions.dart';
import 'package:kintaikei_app/common/style.dart';
import 'package:kintaikei_app/models/work.dart';
import 'package:kintaikei_app/models/work_break.dart';
import 'package:kintaikei_app/services/date_time_picker.dart';
import 'package:kintaikei_app/widgets/custom_button.dart';
import 'package:kintaikei_app/widgets/info_label.dart';
import 'package:kintaikei_app/widgets/info_value.dart';
import 'package:kintaikei_app/widgets/link_text.dart';

class StampModBreakScreen extends StatefulWidget {
  final WorkModel work;

  const StampModBreakScreen({
    required this.work,
    super.key,
  });

  @override
  State<StampModBreakScreen> createState() => _StampModBreakScreenState();
}

class _StampModBreakScreenState extends State<StampModBreakScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        backgroundColor: kWhiteColor,
        leading: IconButton(
          icon: const Icon(
            Icons.chevron_left,
            color: kBlackColor,
          ),
          onPressed: () => Navigator.pop(
            context,
            widget.work.workBreaks,
          ),
        ),
        centerTitle: true,
        title: const Text('休憩時間の編集'),
        shape: const Border(bottom: BorderSide(color: kGrey300Color)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          InfoLabel(
            label: '合計休憩時間',
            child: InfoValue(convertTimeText(widget.work.breakTime())),
          ),
          const SizedBox(height: 8),
          const Divider(color: kGreyColor, height: 1),
          Column(
            children: widget.work.workBreaks.map((workBreak) {
              return Container(
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: kGreyColor)),
                ),
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  children: [
                    InfoLabel(
                      label: '休憩開始時間',
                      child: InfoValue(
                        convertDateText(
                          'yyyy/MM/dd HH:mm',
                          workBreak.startedAt,
                        ),
                        icon: Icons.edit,
                        onTap: () async => await DateTimePickerService().picker(
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
                      ),
                    ),
                    const SizedBox(height: 4),
                    InfoLabel(
                      label: '休憩終了時間',
                      child: InfoValue(
                        convertDateText(
                          'yyyy/MM/dd HH:mm',
                          workBreak.endedAt,
                        ),
                        icon: Icons.edit,
                        onTap: () async => await DateTimePickerService().picker(
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
                    ),
                    const SizedBox(height: 4),
                    Align(
                      alignment: Alignment.centerRight,
                      child: LinkText(
                        label: 'この休憩を削除する',
                        color: kRedColor,
                        onTap: () {
                          widget.work.workBreaks.remove(workBreak);
                          setState(() {});
                        },
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          CustomButton(
            label: '休憩時間を追加する',
            labelColor: kWhiteColor,
            backgroundColor: kBlueColor,
            onPressed: () {
              String workBreakId = generatePassword(16);
              widget.work.workBreaks.add(WorkBreakModel.addMap({
                'id': workBreakId,
                'startedAt': widget.work.startedAt,
                'endedAt': widget.work.startedAt.add(const Duration(hours: 1)),
              }));
              setState(() {});
            },
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
