import 'package:flutter/material.dart';
import 'package:kintaikei_app/common/style.dart';
import 'package:kintaikei_app/models/company_group.dart';

class GroupDropdown extends StatelessWidget {
  final CompanyGroupModel? value;
  final List<CompanyGroupModel> groups;
  final Function(CompanyGroupModel?)? onChanged;

  const GroupDropdown({
    required this.value,
    required this.groups,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    List<DropdownMenuItem<CompanyGroupModel?>> items = [
      const DropdownMenuItem<CompanyGroupModel?>(
        value: null,
        child: Text(
          '勤務先の指定なし',
          style: TextStyle(
            color: kGrey600Color,
            fontSize: 16,
          ),
          softWrap: false,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ),
    ];
    if (groups.isNotEmpty) {
      for (CompanyGroupModel group in groups) {
        items.add(DropdownMenuItem<CompanyGroupModel?>(
          value: group,
          child: Text(
            '${group.companyName} ${group.name}',
            style: const TextStyle(fontSize: 16),
            softWrap: false,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ));
      }
    }
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: kGrey300Color),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: DropdownButton<CompanyGroupModel?>(
        underline: Container(),
        isExpanded: true,
        value: value,
        onChanged: onChanged,
        items: items,
      ),
    );
  }
}
