import 'package:flutter/material.dart';
import 'package:kintaikei_app/common/functions.dart';
import 'package:kintaikei_app/common/style.dart';
import 'package:kintaikei_app/models/company_group.dart';
import 'package:kintaikei_app/models/work.dart';
import 'package:kintaikei_app/providers/home.dart';
import 'package:kintaikei_app/providers/login.dart';
import 'package:kintaikei_app/providers/work.dart';
import 'package:kintaikei_app/screens/calendar.dart';
import 'package:kintaikei_app/screens/shift.dart';
import 'package:kintaikei_app/screens/user.dart';
import 'package:kintaikei_app/services/company_group.dart';
import 'package:kintaikei_app/services/work.dart';
import 'package:kintaikei_app/widgets/bottom_navi_bar.dart';
import 'package:kintaikei_app/widgets/custom_circle_avatar.dart';
import 'package:kintaikei_app/widgets/date_time_widget.dart';
import 'package:kintaikei_app/widgets/group_dropdown.dart';
import 'package:kintaikei_app/widgets/info_label.dart';
import 'package:kintaikei_app/widgets/info_value.dart';
import 'package:kintaikei_app/widgets/stamp_button.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;

  const HomeScreen({
    required this.loginProvider,
    required this.homeProvider,
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CompanyGroupService groupService = CompanyGroupService();
  WorkService workService = WorkService();
  CompanyGroupModel? currentGroup;
  WorkModel? currentWork;

  void _getStatus() async {
    await widget.homeProvider.reloadGroup();
    switch (widget.loginProvider.user?.getWorkStatus()) {
      case 1:
      case 2:
        currentWork = await workService.selectToId(
          id: widget.loginProvider.user?.lastWorkId,
        );
        if (currentWork != null) {
          currentGroup = await groupService.selectToId(
            id: currentWork?.groupId,
          );
        }
        break;
      default:
        currentGroup = widget.homeProvider.currentGroup;
        currentWork = null;
        break;
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    _getStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final workProvider = Provider.of<WorkProvider>(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 10,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(),
                  CustomCircleAvatar(
                    user: widget.loginProvider.user,
                    onTap: () => showBottomUpScreen(
                      context,
                      UserScreen(
                        loginProvider: widget.loginProvider,
                        homeProvider: widget.homeProvider,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const DateTimeWidget(),
                    Column(
                      children: [
                        currentWork == null
                            ? InfoLabel(
                                label: '出勤先を選んでください',
                                child: GroupDropdown(
                                  value: currentGroup,
                                  groups: widget.loginProvider.groups,
                                  onChanged: (value) async {
                                    await widget.homeProvider.changeGroup(
                                      value,
                                    );
                                    setState(() {
                                      currentGroup = value;
                                    });
                                  },
                                ),
                              )
                            : InfoLabel(
                                label: '勤務先',
                                child: currentGroup == null
                                    ? const InfoValue(kDefaultGroupText)
                                    : InfoValue(
                                        '${currentGroup?.companyName} ${currentGroup?.name}',
                                      ),
                              ),
                        const SizedBox(height: 8),
                        widget.loginProvider.user?.getWorkStatus() == 0
                            ? StampButton(
                                label: '出勤する',
                                labelColor: kWhiteColor,
                                backgroundColor: kBlueColor,
                                onPressed: () async {
                                  String? error = await workProvider.start(
                                    group: currentGroup,
                                    user: widget.loginProvider.user,
                                  );
                                  if (error != null) {
                                    if (!mounted) return;
                                    showMessage(context, error, false);
                                    return;
                                  }
                                  await widget.loginProvider.reloadData();
                                  if (!mounted) return;
                                  showMessage(context, '出勤しました', true);
                                  _getStatus();
                                },
                              )
                            : Container(),
                        widget.loginProvider.user?.getWorkStatus() == 1
                            ? StampButton(
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
                                  showMessage(context, '退勤しました', true);
                                  _getStatus();
                                },
                              )
                            : Container(),
                        widget.loginProvider.user?.getWorkStatus() == 1
                            ? Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: StampButton(
                                  label: '休憩する',
                                  labelColor: kBlackColor,
                                  backgroundColor: kYellowColor,
                                  onPressed: () async {
                                    String? error =
                                        await workProvider.breakStart(
                                      work: currentWork,
                                    );
                                    if (error != null) {
                                      if (!mounted) return;
                                      showMessage(context, error, false);
                                      return;
                                    }
                                    await widget.loginProvider.reloadData();
                                    if (!mounted) return;
                                    showMessage(context, '休憩を開始しました', true);
                                    _getStatus();
                                  },
                                ),
                              )
                            : Container(),
                        widget.loginProvider.user?.getWorkStatus() == 2
                            ? StampButton(
                                label: '休憩終了',
                                labelColor: kBlackColor,
                                backgroundColor: kYellowColor,
                                onPressed: () async {
                                  String? error = await workProvider.breakStop(
                                    work: currentWork,
                                    workBreakId: widget
                                        .loginProvider.user?.lastWorkBreakId,
                                  );
                                  if (error != null) {
                                    if (!mounted) return;
                                    showMessage(context, error, false);
                                    return;
                                  }
                                  await widget.loginProvider.reloadData();
                                  if (!mounted) return;
                                  showMessage(context, '休憩を終了しました', true);
                                  _getStatus();
                                },
                              )
                            : Container(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            BottomNaviBar(
              leftLabel: 'シフト',
              leftOnTap: () {
                Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.leftToRight,
                    child: ShiftScreen(
                      loginProvider: widget.loginProvider,
                      homeProvider: widget.homeProvider,
                    ),
                  ),
                );
              },
              rightLabel: 'カレンダー',
              rightOnTap: () {
                Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.rightToLeft,
                    child: CalendarScreen(
                      loginProvider: widget.loginProvider,
                      homeProvider: widget.homeProvider,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
