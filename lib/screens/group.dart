import 'package:flutter/material.dart';
import 'package:kintaikei_app/common/functions.dart';
import 'package:kintaikei_app/common/style.dart';
import 'package:kintaikei_app/models/company_group.dart';
import 'package:kintaikei_app/providers/company.dart';
import 'package:kintaikei_app/providers/home.dart';
import 'package:kintaikei_app/providers/login.dart';
import 'package:kintaikei_app/widgets/custom_alert_dialog.dart';
import 'package:kintaikei_app/widgets/dialog_button.dart';
import 'package:kintaikei_app/widgets/group_list.dart';
import 'package:kintaikei_app/widgets/info_label.dart';
import 'package:kintaikei_app/widgets/info_value.dart';
import 'package:provider/provider.dart';

class GroupScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;

  const GroupScreen({
    required this.loginProvider,
    required this.homeProvider,
    super.key,
  });

  @override
  State<GroupScreen> createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
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
        title: const Text('現在の勤務先一覧'),
        shape: const Border(bottom: BorderSide(color: kGrey300Color)),
      ),
      body: widget.loginProvider.groups.isNotEmpty
          ? ListView.builder(
              itemCount: widget.loginProvider.groups.length,
              itemBuilder: (context, index) {
                CompanyGroupModel group = widget.loginProvider.groups[index];
                return GroupList(
                  group: group,
                  onTap: () => showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) => ExitGroupDialog(
                      loginProvider: widget.loginProvider,
                      group: group,
                    ),
                  ),
                );
              },
            )
          : const Center(child: Text('勤務先はありません')),
    );
  }
}

class ExitGroupDialog extends StatefulWidget {
  final LoginProvider loginProvider;
  final CompanyGroupModel group;

  const ExitGroupDialog({
    required this.loginProvider,
    required this.group,
    super.key,
  });

  @override
  State<ExitGroupDialog> createState() => _ExitGroupDialogState();
}

class _ExitGroupDialogState extends State<ExitGroupDialog> {
  @override
  Widget build(BuildContext context) {
    final companyProvider = Provider.of<CompanyProvider>(context);
    return CustomAlertDialog(
      children: [
        const Text('以下の勤務先を退職しますか？'),
        const SizedBox(height: 8),
        InfoLabel(
          label: '勤務先',
          child: InfoValue('${widget.group.companyName} ${widget.group.name}'),
        ),
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
              label: '退職する',
              labelColor: kWhiteColor,
              backgroundColor: kRedColor,
              onPressed: () async {
                String? error = await companyProvider.updateExitUser(
                  group: widget.group,
                  user: widget.loginProvider.user,
                );
                if (error != null) {
                  if (!mounted) return;
                  showMessage(context, error, false);
                  return;
                }
                await widget.loginProvider.reloadData();
                if (!mounted) return;
                showMessage(context, '該当の勤務先を退職しました', true);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ],
    );
  }
}
