import 'package:flutter/material.dart';
import 'package:kintaikei_app/common/functions.dart';
import 'package:kintaikei_app/common/style.dart';
import 'package:kintaikei_app/models/company_group.dart';
import 'package:kintaikei_app/providers/company.dart';
import 'package:kintaikei_app/providers/home.dart';
import 'package:kintaikei_app/providers/login.dart';
import 'package:kintaikei_app/widgets/custom_alert_dialog.dart';
import 'package:kintaikei_app/widgets/custom_text_form_field.dart';
import 'package:kintaikei_app/widgets/dialog_button.dart';
import 'package:kintaikei_app/widgets/group_list.dart';
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
      body: ListView.builder(
        itemCount: widget.loginProvider.groups.length,
        itemBuilder: (context, index) {
          CompanyGroupModel group = widget.loginProvider.groups[index];
          return GroupList(
            group: group,
            onTap: () {},
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => AddCompanyDialog(
            loginProvider: widget.loginProvider,
          ),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class AddCompanyDialog extends StatefulWidget {
  final LoginProvider loginProvider;

  const AddCompanyDialog({
    required this.loginProvider,
    super.key,
  });

  @override
  State<AddCompanyDialog> createState() => _AddCompanyDialogState();
}

class _AddCompanyDialogState extends State<AddCompanyDialog> {
  TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final companyProvider = Provider.of<CompanyProvider>(context);
    return CustomAlertDialog(
      children: [
        CustomTextFormField(
          controller: nameController,
          textInputType: TextInputType.name,
          maxLines: 1,
          label: '会社名',
          color: kMainColor,
          prefix: Icons.business,
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            DialogButton(
              label: 'やめる',
              labelColor: kWhiteColor,
              backgroundColor: kGreyColor,
              onPressed: () => Navigator.pop(context),
            ),
            DialogButton(
              label: '追加する',
              labelColor: kWhiteColor,
              backgroundColor: kBlueColor,
              onPressed: () async {
                String? error = await companyProvider.create(
                  user: widget.loginProvider.user,
                  name: nameController.text,
                );
                if (error != null) {
                  if (!mounted) return;
                  showMessage(context, error, false);
                  return;
                }
                if (!mounted) return;
                showMessage(context, '会社を追加しました', true);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ],
    );
  }
}
