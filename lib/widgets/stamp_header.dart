import 'package:flutter/material.dart';
import 'package:kintaikei_app/models/company_group.dart';
import 'package:kintaikei_app/models/user.dart';
import 'package:kintaikei_app/models/work.dart';
import 'package:kintaikei_app/widgets/group_dropdown.dart';
import 'package:kintaikei_app/widgets/info_label.dart';
import 'package:kintaikei_app/widgets/info_value.dart';

class StampHeader extends StatelessWidget {
  final UserModel? user;
  final List<CompanyGroupModel> groups;
  final WorkModel? currentWork;
  final CompanyGroupModel? selectedGroup;
  final Function(CompanyGroupModel?)? onChanged;

  const StampHeader({
    required this.user,
    required this.groups,
    required this.currentWork,
    required this.selectedGroup,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'おはようございます！${user?.name}様',
          style: const TextStyle(fontSize: 18),
        ),
        currentWork == null
            ? const Text(
                '出勤時間を打刻しましょう',
                style: TextStyle(fontSize: 18),
              )
            : const Text(
                '退勤時間を打刻しましょう',
                style: TextStyle(fontSize: 18),
              ),
        const SizedBox(height: 16),
        currentWork == null
            ? InfoLabel(
                label: '勤務先を選ぶ',
                child: GroupDropdown(
                  value: selectedGroup,
                  groups: groups,
                  onChanged: onChanged,
                ),
              )
            : InfoLabel(
                label: '勤務先',
                child: InfoValue(
                  '${selectedGroup?.companyName} ${selectedGroup?.name}',
                ),
              ),
      ],
    );
  }
}
