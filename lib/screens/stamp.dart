import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kintaikei_app/common/functions.dart';
import 'package:kintaikei_app/common/style.dart';
import 'package:kintaikei_app/models/company_group.dart';
import 'package:kintaikei_app/models/work.dart';
import 'package:kintaikei_app/providers/home.dart';
import 'package:kintaikei_app/providers/login.dart';
import 'package:kintaikei_app/providers/work.dart';
import 'package:kintaikei_app/screens/stamp_mod.dart';
import 'package:kintaikei_app/services/company_group.dart';
import 'package:kintaikei_app/services/work.dart';
import 'package:kintaikei_app/widgets/date_time_widget.dart';
import 'package:kintaikei_app/widgets/group_dropdown.dart';
import 'package:kintaikei_app/widgets/history_header.dart';
import 'package:kintaikei_app/widgets/info_label.dart';
import 'package:kintaikei_app/widgets/info_value.dart';
import 'package:kintaikei_app/widgets/stamp_button.dart';
import 'package:kintaikei_app/widgets/work_list.dart';
import 'package:provider/provider.dart';

class StampScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;

  const StampScreen({
    required this.loginProvider,
    required this.homeProvider,
    super.key,
  });

  @override
  State<StampScreen> createState() => _StampScreenState();
}

class _StampScreenState extends State<StampScreen> {
  CompanyGroupService groupService = CompanyGroupService();
  WorkService workService = WorkService();
  WorkModel? currentWork;
  CompanyGroupModel? selectedGroup;

  void _init() async {
    if (widget.loginProvider.user?.getWorkStatus() == 1 ||
        widget.loginProvider.user?.getWorkStatus() == 2) {
      WorkModel? work = await workService.selectToId(
        id: widget.loginProvider.user?.lastWorkId,
      );
      currentWork = work;
      CompanyGroupModel? group = await groupService.selectToId(
        id: work?.groupId,
      );
      selectedGroup = group;
    } else {
      selectedGroup = widget.homeProvider.currentGroup;
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    final workProvider = Provider.of<WorkProvider>(context);
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        backgroundColor: kWhiteColor,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.close,
              color: kBlackColor,
            ),
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  widget.loginProvider.user?.getGreetText() ?? '',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                const DateTimeWidget(),
                const SizedBox(height: 8),
                currentWork == null
                    ? InfoLabel(
                        label: '勤務先を選ぶ',
                        child: GroupDropdown(
                          value: selectedGroup,
                          groups: widget.loginProvider.groups,
                          onChanged: (value) {
                            setState(() {
                              selectedGroup = value;
                            });
                          },
                        ),
                      )
                    : InfoLabel(
                        label: '勤務先',
                        child: selectedGroup == null
                            ? const InfoValue('勤務先の指定なし')
                            : InfoValue(
                                '${selectedGroup?.companyName} ${selectedGroup?.name}',
                              ),
                      ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: widget.loginProvider.user?.getWorkStatus() == 0
                      ? [
                          StampButton(
                            label: '出勤する',
                            labelColor: kWhiteColor,
                            backgroundColor: kBlueColor,
                            onPressed: () async {
                              String? error = await workProvider.start(
                                group: selectedGroup,
                                user: widget.loginProvider.user,
                              );
                              if (error != null) {
                                if (!mounted) return;
                                showMessage(context, error, false);
                                return;
                              }
                              await widget.loginProvider.reloadData();
                              if (!mounted) return;
                              showMessage(context, '出勤時間を打刻しました', true);
                              Navigator.of(context, rootNavigator: true).pop();
                            },
                          ),
                        ]
                      : widget.loginProvider.user?.getWorkStatus() == 1
                          ? [
                              StampButton(
                                label: '休憩する',
                                labelColor: kBlackColor,
                                backgroundColor: kYellowColor,
                                onPressed: () async {
                                  String? error = await workProvider.breakStart(
                                    work: currentWork,
                                  );
                                  if (error != null) {
                                    if (!mounted) return;
                                    showMessage(context, error, false);
                                    return;
                                  }
                                  await widget.loginProvider.reloadData();
                                  if (!mounted) return;
                                  showMessage(context, '休憩時間を打刻しました', true);
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();
                                },
                              ),
                              StampButton(
                                label: '退勤する',
                                labelColor: kWhiteColor,
                                backgroundColor: kRedColor,
                                onPressed: () async {
                                  String? error = await workProvider.stop(
                                    work: currentWork,
                                  );
                                  if (error != null) {
                                    if (!mounted) return;
                                    showMessage(context, error, false);
                                    return;
                                  }
                                  await widget.loginProvider.reloadData();
                                  if (!mounted) return;
                                  showMessage(context, '退勤時間を打刻しました', true);
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();
                                },
                              ),
                            ]
                          : widget.loginProvider.user?.getWorkStatus() == 2
                              ? [
                                  StampButton(
                                    label: '休憩終了',
                                    labelColor: kBlackColor,
                                    backgroundColor: kYellowColor,
                                    onPressed: () async {
                                      String? error =
                                          await workProvider.breakStop(
                                        work: currentWork,
                                        workBreakId: widget.loginProvider.user
                                            ?.lastWorkBreakId,
                                      );
                                      if (error != null) {
                                        if (!mounted) return;
                                        showMessage(context, error, false);
                                        return;
                                      }
                                      await widget.loginProvider.reloadData();
                                      if (!mounted) return;
                                      showMessage(context, '休憩時間を打刻しました', true);
                                      Navigator.of(context, rootNavigator: true)
                                          .pop();
                                    },
                                  ),
                                ]
                              : [],
                ),
              ],
            ),
          ),
          const HistoryHeader(),
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: workService.streamList(
                userId: widget.loginProvider.user?.id,
              ),
              builder: (context, snapshot) {
                List<WorkModel> works = workService.convertList(snapshot);
                return ListView.builder(
                  itemCount: works.length,
                  itemBuilder: (context, index) {
                    WorkModel work = works[index];
                    return WorkList(
                      work: work,
                      onTap: () => pushScreen(
                        context,
                        StampModScreen(
                          loginProvider: widget.loginProvider,
                          workProvider: workProvider,
                          work: work,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
