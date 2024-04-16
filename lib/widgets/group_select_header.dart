import 'package:flutter/material.dart';
import 'package:kintaikei_app/common/style.dart';

class GroupSelectHeader extends StatelessWidget {
  final String label;
  final Function() onTap;

  const GroupSelectHeader({
    required this.label,
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
            Text(
              label,
              style: const TextStyle(fontSize: 16),
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