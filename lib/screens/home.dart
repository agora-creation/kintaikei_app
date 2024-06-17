import 'package:flutter/material.dart';
import 'package:kintaikei_app/common/functions.dart';
import 'package:kintaikei_app/common/style.dart';
import 'package:kintaikei_app/models/company_group.dart';
import 'package:kintaikei_app/models/work.dart';
import 'package:kintaikei_app/providers/home.dart';
import 'package:kintaikei_app/providers/login.dart';
import 'package:kintaikei_app/providers/work.dart';
import 'package:kintaikei_app/screens/plan.dart';
import 'package:kintaikei_app/screens/plan_shift.dart';
import 'package:kintaikei_app/screens/user.dart';
import 'package:kintaikei_app/screens/work.dart';
import 'package:kintaikei_app/services/company_group.dart';
import 'package:kintaikei_app/services/work.dart';
import 'package:kintaikei_app/widgets/custom_footer.dart';
import 'package:kintaikei_app/widgets/date_time_widget.dart';
import 'package:kintaikei_app/widgets/group_select_widget.dart';
import 'package:kintaikei_app/widgets/home_header.dart';
import 'package:kintaikei_app/widgets/now_plan_widget.dart';
import 'package:kintaikei_app/widgets/stamp_slide_button.dart';
import 'package:provider/provider.dart';
import 'package:slide_to_act/slide_to_act.dart';

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
  GlobalKey<SlideActionState> workStartKey = GlobalKey();
  GlobalKey<SlideActionState> workStopKey = GlobalKey();
  GlobalKey<SlideActionState> workBreakStartKey = GlobalKey();
  GlobalKey<SlideActionState> workBreakStopKey = GlobalKey();

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
            HomeHeader(
              user: widget.loginProvider.user,
              userOnTap: () => showBottomUpScreen(
                context,
                UserScreen(
                  loginProvider: widget.loginProvider,
                  homeProvider: widget.homeProvider,
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () => showBottomUpScreen(
                    context,
                    WorkScreen(
                      loginProvider: widget.loginProvider,
                      homeProvider: widget.homeProvider,
                    ),
                  ),
                  icon: const Icon(Icons.list_rounded),
                ),
                IconButton(
                  onPressed: () => showBottomUpScreen(
                    context,
                    PlanShiftScreen(
                      loginProvider: widget.loginProvider,
                      homeProvider: widget.homeProvider,
                    ),
                  ),
                  icon: const Icon(Icons.view_timeline),
                ),
                IconButton(
                  onPressed: () => showBottomUpScreen(
                    context,
                    PlanScreen(
                      loginProvider: widget.loginProvider,
                      homeProvider: widget.homeProvider,
                    ),
                  ),
                  icon: const Icon(Icons.calendar_month),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    const DateTimeWidget(),
                    NowPlanWidget(
                      loginProvider: widget.loginProvider,
                      homeProvider: widget.homeProvider,
                    ),
                    Column(
                      children: [
                        GroupSelectWidget(
                          groups: widget.loginProvider.groups,
                          currentGroup: currentGroup,
                          currentWork: currentWork,
                          onChanged: (value) async {
                            await widget.homeProvider.changeGroup(value);
                            setState(() {
                              currentGroup = widget.homeProvider.currentGroup;
                            });
                          },
                        ),
                        widget.loginProvider.user?.getWorkStatus() == 0
                            ? StampSlideButton(
                                slideKey: workStartKey,
                                label: '出勤する',
                                backgroundColor: kBlueColor,
                                onSubmit: () async {
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
                                  Future.delayed(
                                    const Duration(seconds: 1),
                                    () => workStartKey.currentState?.reset(),
                                  );
                                },
                              )
                            : Container(),
                        widget.loginProvider.user?.getWorkStatus() == 1
                            ? StampSlideButton(
                                slideKey: workStopKey,
                                label: '退勤する',
                                backgroundColor: kRedColor,
                                reversed: true,
                                onSubmit: () async {
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
                                  Future.delayed(
                                    const Duration(seconds: 1),
                                    () => workStartKey.currentState?.reset(),
                                  );
                                },
                              )
                            : Container(),
                        widget.loginProvider.user?.getWorkStatus() == 1
                            ? Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: StampSlideButton(
                                  slideKey: workBreakStartKey,
                                  label: '休憩する',
                                  backgroundColor: kAmberColor,
                                  onSubmit: () async {
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
                                    Future.delayed(
                                      const Duration(seconds: 1),
                                      () => workStartKey.currentState?.reset(),
                                    );
                                  },
                                ),
                              )
                            : Container(),
                        widget.loginProvider.user?.getWorkStatus() == 2
                            ? StampSlideButton(
                                slideKey: workBreakStopKey,
                                label: '休憩終了',
                                backgroundColor: kAmberColor,
                                reversed: true,
                                onSubmit: () async {
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
                                  Future.delayed(
                                    const Duration(seconds: 1),
                                    () => workStartKey.currentState?.reset(),
                                  );
                                },
                              )
                            : Container(),
                      ],
                    ),
                  ],
                ),
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
