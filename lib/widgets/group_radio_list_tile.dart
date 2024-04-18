import 'package:flutter/material.dart';
import 'package:kintaikei_app/common/style.dart';
import 'package:kintaikei_app/models/company_group.dart';

class GroupRadioListTile extends StatelessWidget {
  final CompanyGroupModel? group;
  final CompanyGroupModel? value;
  final void Function(CompanyGroupModel?)? onChanged;

  const GroupRadioListTile({
    required this.group,
    required this.value,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: kGreyColor)),
      ),
      child: RadioListTile<CompanyGroupModel?>(
        title: group != null
            ? Text('${group?.companyName} ${group?.name}')
            : const Text(
                '勤務先の指定なし',
                style: TextStyle(color: kGreyColor),
              ),
        value: group,
        groupValue: value,
        onChanged: onChanged,
      ),
    );
  }
}
