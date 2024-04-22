import 'package:flutter/material.dart';
import 'package:kintaikei_app/common/style.dart';
import 'package:kintaikei_app/models/company_group.dart';
import 'package:kintaikei_app/providers/home.dart';
import 'package:kintaikei_app/providers/login.dart';
import 'package:kintaikei_app/widgets/custom_button.dart';
import 'package:kintaikei_app/widgets/custom_text_form_field.dart';
import 'package:kintaikei_app/widgets/group_dropdown.dart';
import 'package:kintaikei_app/widgets/info_label.dart';

class PlanAddScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final DateTime date;

  const PlanAddScreen({
    required this.loginProvider,
    required this.homeProvider,
    required this.date,
    super.key,
  });

  @override
  State<PlanAddScreen> createState() => _PlanAddScreenState();
}

class _PlanAddScreenState extends State<PlanAddScreen> {
  CompanyGroupModel? selectedGroup;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        backgroundColor: kWhiteColor,
        automaticallyImplyLeading: false,
        title: const Text('予定の追加'),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.close,
              color: kBlackColor,
            ),
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
          ),
        ],
        shape: const Border(bottom: BorderSide(color: kGrey300Color)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          InfoLabel(
            label: '勤務先',
            child: GroupDropdown(
              value: selectedGroup,
              groups: widget.loginProvider.groups,
              onChanged: (value) {
                setState(() {
                  selectedGroup = value;
                });
              },
            ),
          ),
          const SizedBox(height: 8),
          CustomTextFormField(
            controller: TextEditingController(),
            textInputType: TextInputType.name,
            maxLines: 1,
            label: '件名',
            color: kBlackColor,
            prefix: Icons.short_text,
          ),
          const SizedBox(height: 8),
          InfoLabel(
            label: '予定時間帯',
            child: Container(),
          ),
          const SizedBox(height: 8),
          InfoLabel(
            label: '事前アラート通知',
            child: Container(),
          ),
          const SizedBox(height: 16),
          CustomButton(
            label: '追加する',
            labelColor: kWhiteColor,
            backgroundColor: kBlueColor,
            onPressed: () async {},
          ),
        ],
      ),
    );
  }
}
