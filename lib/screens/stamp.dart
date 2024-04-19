import 'package:flutter/material.dart';
import 'package:kintaikei_app/common/style.dart';
import 'package:kintaikei_app/models/company_group.dart';
import 'package:kintaikei_app/models/work.dart';
import 'package:kintaikei_app/providers/home.dart';
import 'package:kintaikei_app/providers/login.dart';
import 'package:kintaikei_app/providers/work.dart';
import 'package:kintaikei_app/services/company_group.dart';
import 'package:kintaikei_app/services/work.dart';
import 'package:kintaikei_app/widgets/date_time_widget.dart';
import 'package:kintaikei_app/widgets/group_dropdown.dart';
import 'package:kintaikei_app/widgets/info_label.dart';
import 'package:kintaikei_app/widgets/stamp_button.dart';
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
                  'おはようございます！〇〇様',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  '出勤時間を打刻しましょう。',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 16),
                DateTimeWidget(),
                SizedBox(height: 16),
                InfoLabel(
                  label: '勤務先を選ぶ',
                  child: GroupDropdown(
                    value: selectedGroup,
                    groups: widget.loginProvider.groups,
                    onChanged: (value) {},
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    StampButton(
                      label: '出勤する',
                      labelColor: kWhiteColor,
                      backgroundColor: kBlueColor,
                      onPressed: () {},
                    ),
                    StampButton(
                      label: '退勤する',
                      labelColor: kWhiteColor,
                      backgroundColor: kRedColor,
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
          Text('打刻履歴'),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: kGreyColor)),
              ),
              child: ListView.builder(
                itemCount: 100,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('出勤'),
                  );
                },
              ),
            ),
          )
        ],
      ),
      // body: Padding(
      //   padding: const EdgeInsets.all(16),
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //     children: [
      //       StampHeader(
      //         user: widget.loginProvider.user,
      //         groups: widget.loginProvider.groups,
      //         currentWork: currentWork,
      //         selectedGroup: selectedGroup,
      //         onChanged: (value) {
      //           setState(() {
      //             selectedGroup = value;
      //           });
      //         },
      //       ),
      //       const DateTimeWidget(),
      //       Column(
      //         children: [
      //           widget.loginProvider.user?.getWorkStatus() == 0
      //               ? StampButton(
      //                   label: '出勤する',
      //                   labelColor: kWhiteColor,
      //                   backgroundColor: kBlueColor,
      //                   onPressed: () async {
      //                     String? error = await workProvider.start(
      //                       group: selectedGroup,
      //                       user: widget.loginProvider.user,
      //                     );
      //                     if (error != null) {
      //                       if (!mounted) return;
      //                       showMessage(context, error, false);
      //                       return;
      //                     }
      //                     widget.loginProvider.reloadData();
      //                     if (!mounted) return;
      //                     showMessage(context, '出勤時間を打刻しました', true);
      //                     Navigator.of(context, rootNavigator: true).pop();
      //                   },
      //                 )
      //               : Container(),
      //           widget.loginProvider.user?.getWorkStatus() == 1
      //               ? StampButton(
      //                   label: '休憩する',
      //                   labelColor: kBlackColor,
      //                   backgroundColor: kYellowColor,
      //                   onPressed: () async {
      //                     String? error = await workProvider.breakStart(
      //                       work: currentWork,
      //                     );
      //                     if (error != null) {
      //                       if (!mounted) return;
      //                       showMessage(context, error, false);
      //                       return;
      //                     }
      //                     widget.loginProvider.reloadData();
      //                     if (!mounted) return;
      //                     showMessage(context, '休憩時間を打刻しました', true);
      //                     Navigator.of(context, rootNavigator: true).pop();
      //                   },
      //                 )
      //               : Container(),
      //           widget.loginProvider.user?.getWorkStatus() == 1
      //               ? StampButton(
      //                   label: '退勤する',
      //                   labelColor: kWhiteColor,
      //                   backgroundColor: kRedColor,
      //                   onPressed: () async {
      //                     String? error = await workProvider.stop(
      //                       work: currentWork,
      //                     );
      //                     if (error != null) {
      //                       if (!mounted) return;
      //                       showMessage(context, error, false);
      //                       return;
      //                     }
      //                     widget.loginProvider.reloadData();
      //                     if (!mounted) return;
      //                     showMessage(context, '退勤時間を打刻しました', true);
      //                     Navigator.of(context, rootNavigator: true).pop();
      //                   },
      //                 )
      //               : Container(),
      //           widget.loginProvider.user?.getWorkStatus() == 2
      //               ? StampButton(
      //                   label: '休憩終了',
      //                   labelColor: kBlackColor,
      //                   backgroundColor: kYellowColor,
      //                   onPressed: () async {
      //                     String? error = await workProvider.breakStop(
      //                       work: currentWork,
      //                       workBreakId:
      //                           widget.loginProvider.user?.lastWorkBreakId,
      //                     );
      //                     if (error != null) {
      //                       if (!mounted) return;
      //                       showMessage(context, error, false);
      //                       return;
      //                     }
      //                     widget.loginProvider.reloadData();
      //                     if (!mounted) return;
      //                     showMessage(context, '休憩時間を打刻しました', true);
      //                     Navigator.of(context, rootNavigator: true).pop();
      //                   },
      //                 )
      //               : Container(),
      //         ],
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}
