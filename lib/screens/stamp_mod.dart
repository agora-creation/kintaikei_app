import 'package:flutter/material.dart';
import 'package:kintaikei_app/common/functions.dart';
import 'package:kintaikei_app/common/style.dart';
import 'package:kintaikei_app/models/work.dart';
import 'package:kintaikei_app/providers/login.dart';
import 'package:kintaikei_app/providers/work.dart';
import 'package:kintaikei_app/services/date_time_picker.dart';
import 'package:kintaikei_app/widgets/custom_alert_dialog.dart';
import 'package:kintaikei_app/widgets/custom_button.dart';
import 'package:kintaikei_app/widgets/dialog_button.dart';
import 'package:kintaikei_app/widgets/info_label.dart';
import 'package:kintaikei_app/widgets/info_value.dart';
import 'package:kintaikei_app/widgets/link_text.dart';

class StampModScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final WorkProvider workProvider;
  final WorkModel work;

  const StampModScreen({
    required this.loginProvider,
    required this.workProvider,
    required this.work,
    super.key,
  });

  @override
  State<StampModScreen> createState() => _StampModScreenState();
}

class _StampModScreenState extends State<StampModScreen> {
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
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text('打刻情報の編集'),
        shape: const Border(bottom: BorderSide(color: kGrey300Color)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          InfoLabel(
            label: '勤務先',
            child: InfoValue(
              '${widget.work.companyName} ${widget.work.groupName}',
            ),
          ),
          const SizedBox(height: 8),
          InfoLabel(
            label: '出勤時間',
            child: InfoValue(
              convertDateText('yyyy/MM/dd HH:mm', widget.work.startedAt),
              onTap: () async {
                await DateTimePickerService().picker(
                  context: context,
                  init: widget.work.startedAt,
                  title: '出勤時間を選択',
                  onChanged: (value) {
                    if (value.millisecondsSinceEpoch <
                        widget.work.endedAt.millisecondsSinceEpoch) {
                      widget.work.startedAt = value;
                      setState(() {});
                    }
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          InfoLabel(
            label: '退勤時間',
            child: InfoValue(
              convertDateText('yyyy/MM/dd HH:mm', widget.work.endedAt),
              onTap: () async {
                await DateTimePickerService().picker(
                  context: context,
                  init: widget.work.endedAt,
                  title: '退勤時間を選択',
                  onChanged: (value) {
                    if (widget.work.startedAt.millisecondsSinceEpoch <
                        value.millisecondsSinceEpoch) {
                      widget.work.startedAt = value;
                      setState(() {});
                    }
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          InfoLabel(
            label: '合計休憩時間',
            child: InfoValue(
              widget.work.breakTime(),
              onTap: () {},
            ),
          ),
          const SizedBox(height: 8),
          InfoLabel(
            label: '勤務時間',
            child: InfoValue(widget.work.totalTime()),
          ),
          const SizedBox(height: 16),
          CustomButton(
            label: '変更する',
            labelColor: kWhiteColor,
            backgroundColor: kBlueColor,
            onPressed: () async {
              Navigator.pop(context);
            },
          ),
          const SizedBox(height: 24),
          Center(
            child: LinkText(
              label: 'この打刻情報を削除する',
              color: kRedColor,
              onTap: () => showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) => DelWorkDialog(
                  workProvider: widget.workProvider,
                  work: widget.work,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DelWorkDialog extends StatefulWidget {
  final WorkProvider workProvider;
  final WorkModel work;

  const DelWorkDialog({
    required this.workProvider,
    required this.work,
    super.key,
  });

  @override
  State<DelWorkDialog> createState() => _DelWorkDialogState();
}

class _DelWorkDialogState extends State<DelWorkDialog> {
  @override
  Widget build(BuildContext context) {
    return CustomAlertDialog(
      children: [
        const Text('この打刻情報を削除しますか？'),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            DialogButton(
              label: 'キャンセル',
              labelColor: kWhiteColor,
              backgroundColor: kGreyColor,
              onPressed: () => Navigator.pop(context),
            ),
            DialogButton(
              label: '削除する',
              labelColor: kWhiteColor,
              backgroundColor: kRedColor,
              onPressed: () async {
                String? error = await widget.workProvider.delete(
                  work: widget.work,
                );
                if (error != null) {
                  if (!mounted) return;
                  showMessage(context, error, false);
                  return;
                }
                if (!mounted) return;
                showMessage(context, '該当の打刻情報を削除しました', true);
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ],
    );
  }
}
