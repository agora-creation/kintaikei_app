import 'package:flutter/material.dart';
import 'package:kintaikei_app/common/style.dart';
import 'package:kintaikei_app/models/company_group.dart';
import 'package:kintaikei_app/models/work.dart';
import 'package:kintaikei_app/widgets/group_dropdown.dart';
import 'package:kintaikei_app/widgets/info_label.dart';
import 'package:kintaikei_app/widgets/info_value.dart';

class GroupSelectWidget extends StatelessWidget {
  final List<CompanyGroupModel> groups;
  final CompanyGroupModel? currentGroup;
  final WorkModel? currentWork;
  final Function(String?)? onChanged;

  const GroupSelectWidget({
    required this.groups,
    required this.currentGroup,
    required this.currentWork,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (groups.isEmpty) return Container();
    if (currentWork == null) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: InfoLabel(
          label: '出勤先を選んでください',
          child: GroupDropdown(
            value: currentGroup?.id,
            groups: groups,
            onChanged: onChanged,
          ),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: InfoLabel(
          label: '現在の勤務先',
          child: currentGroup == null
              ? const InfoValue(kDefaultGroupText)
              : InfoValue('${currentGroup?.companyName} ${currentGroup?.name}'),
        ),
      );
    }
  }
}
