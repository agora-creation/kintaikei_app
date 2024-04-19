import 'package:flutter/material.dart';
import 'package:kintaikei_app/common/functions.dart';
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
    String greetText = 'おはようございます！';
    if (user?.getWorkStatus() == 1 || user?.getWorkStatus() == 2) {
      greetText = 'おつかれさまです！';
    }
    String operationText = '出勤時間を打刻しましょう。';
    if (user?.getWorkStatus() == 1) {
      operationText = '休憩もしくは退勤時間を打刻しましょう。';
    } else if (user?.getWorkStatus() == 2) {
      operationText = '休憩終了時間を打刻しましょう。';
    }
    return Column(
      children: [
        Text(
          '$greetText ${user?.name}様',
          style: const TextStyle(fontSize: 18),
        ),
        Text(
          operationText,
          style: const TextStyle(fontSize: 18),
        ),
        const SizedBox(height: 16),
        user?.getWorkStatus() == 1 || user?.getWorkStatus() == 2
            ? InfoLabel(
                label: '勤務先',
                child: InfoValue(
                  '${selectedGroup?.companyName} ${selectedGroup?.name}',
                ),
              )
            : InfoLabel(
                label: '勤務先を選ぶ',
                child: GroupDropdown(
                  value: selectedGroup,
                  groups: groups,
                  onChanged: onChanged,
                ),
              ),
        currentWork != null ? const SizedBox(height: 8) : Container(),
        currentWork != null
            ? InfoLabel(
                label: '出勤時間',
                child: InfoValue(convertDateText(
                  'yyyy/MM/dd (E) HH:mm:ss',
                  currentWork?.startedAt,
                )),
              )
            : Container(),
      ],
    );
  }
}
