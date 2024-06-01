import 'package:flutter/material.dart';
import 'package:kintaikei_app/common/style.dart';
import 'package:kintaikei_app/models/company_group.dart';

class GroupDropdown extends StatelessWidget {
  final String? value;
  final List<CompanyGroupModel> groups;
  final Function(String?)? onChanged;

  const GroupDropdown({
    required this.value,
    required this.groups,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    List<DropdownMenuItem<String?>> items = [
      const DropdownMenuItem<String?>(
        value: null,
        child: Text(
          kDefaultGroupText,
          style: TextStyle(
            color: kGrey600Color,
            fontSize: 18,
          ),
          softWrap: false,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ),
    ];
    if (groups.isNotEmpty) {
      for (CompanyGroupModel group in groups) {
        items.add(DropdownMenuItem<String?>(
          value: group.id,
          child: Text(
            '${group.companyName} ${group.name}',
            style: const TextStyle(
              color: kBlackColor,
              fontSize: 18,
            ),
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
      child: DropdownButton<String?>(
        underline: Container(),
        isExpanded: true,
        value: value,
        onChanged: onChanged,
        items: items,
      ),
    );
  }
}
