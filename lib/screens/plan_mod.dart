import 'package:flutter/material.dart';
import 'package:kintaikei_app/common/functions.dart';
import 'package:kintaikei_app/common/style.dart';
import 'package:kintaikei_app/models/plan.dart';
import 'package:kintaikei_app/providers/home.dart';
import 'package:kintaikei_app/providers/login.dart';
import 'package:kintaikei_app/providers/plan.dart';
import 'package:kintaikei_app/services/picker.dart';
import 'package:kintaikei_app/services/plan.dart';
import 'package:kintaikei_app/widgets/alert_dropdown.dart';
import 'package:kintaikei_app/widgets/color_dropdown.dart';
import 'package:kintaikei_app/widgets/custom_button.dart';
import 'package:kintaikei_app/widgets/custom_expansion_tile.dart';
import 'package:kintaikei_app/widgets/custom_text_field.dart';
import 'package:kintaikei_app/widgets/date_time_range_field.dart';
import 'package:kintaikei_app/widgets/info_label.dart';
import 'package:kintaikei_app/widgets/link_text.dart';
import 'package:provider/provider.dart';

class PlanModScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final String id;

  const PlanModScreen({
    required this.loginProvider,
    required this.homeProvider,
    required this.id,
    super.key,
  });

  @override
  State<PlanModScreen> createState() => _PlanModScreenState();
}

class _PlanModScreenState extends State<PlanModScreen> {
  PlanService planService = PlanService();
  PickerService pickerService = PickerService();
  TextEditingController subjectController = TextEditingController();
  DateTime startedAt = DateTime.now();
  DateTime endedAt = DateTime.now().add(const Duration(hours: 1));
  bool allDay = false;
  Color color = kColors.first;
  int alertMinute = kAlertMinutes[1];

  void _init() async {
    PlanModel? plan = await planService.selectToId(id: widget.id);
    if (plan == null) {
      if (!mounted) return;
      showMessage(context, '予定データの取得に失敗しました', false);
      Navigator.pop(context);
      return;
    }
    subjectController.text = plan.subject;
    startedAt = plan.startedAt;
    endedAt = plan.endedAt;
    allDay = plan.allDay;
    color = plan.color;
    alertMinute = plan.alertMinute;
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
    final planProvider = Provider.of<PlanProvider>(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text('予定の編集'),
        shape: const Border(bottom: BorderSide(color: kGrey300Color)),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            InfoLabel(
              label: '件名',
              child: CustomTextField(
                controller: subjectController,
                textInputType: TextInputType.name,
                maxLines: 1,
              ),
            ),
            const SizedBox(height: 8),
            InfoLabel(
              label: '予定時間帯',
              child: DateTimeRangeField(
                startedAt: startedAt,
                startedOnTap: () async => await pickerService.dateTimePicker(
                  context: context,
                  init: startedAt,
                  title: '予定開始時間を選択',
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
                  title: '予定終了時間を選択',
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
                  label: '色',
                  child: ColorDropdown(
                    value: color,
                    onChanged: (value) {
                      setState(() {
                        color = value!;
                      });
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
                String? error = await planProvider.update(
                  id: widget.id,
                  subject: subjectController.text,
                  startedAt: startedAt,
                  endedAt: endedAt,
                  allDay: allDay,
                  color: color,
                  alertMinute: alertMinute,
                );
                if (error != null) {
                  if (!mounted) return;
                  showMessage(context, error, false);
                  return;
                }
                if (!mounted) return;
                showMessage(context, '予定を編集しました', true);
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 24),
            Align(
              alignment: Alignment.bottomLeft,
              child: LinkText(
                label: 'この予定を削除する',
                color: kRedColor,
                onTap: () async {
                  String? error = await planProvider.delete(
                    id: widget.id,
                  );
                  if (error != null) {
                    if (!mounted) return;
                    showMessage(context, error, false);
                    return;
                  }
                  if (!mounted) return;
                  showMessage(context, '予定を削除しました', true);
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
