import 'package:flutter/material.dart';
import 'package:kintaikei_app/common/style.dart';
import 'package:kintaikei_app/models/company_group.dart';

class GroupSelectHeader extends StatelessWidget {
  final CompanyGroupModel? currentGroup;
  final Function() onTap;

  const GroupSelectHeader({
    required this.currentGroup,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: kGrey300Color)),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            currentGroup != null
                ? Text(
                    '${currentGroup?.companyName} ${currentGroup?.name}',
                    style: const TextStyle(fontSize: 16),
                  )
                : const Text(
                    '勤務先の指定なし',
                    style: TextStyle(
                      color: kGrey600Color,
                      fontSize: 16,
                    ),
                  ),
            const Icon(
              Icons.arrow_drop_down,
              color: kGreyColor,
            ),
          ],
        ),
      ),
    );
  }
}
