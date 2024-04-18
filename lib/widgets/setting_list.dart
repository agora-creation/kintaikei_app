import 'package:flutter/material.dart';
import 'package:kintaikei_app/common/style.dart';

class SettingList extends StatelessWidget {
  final String label;
  final String? value;
  final bool borderTop;
  final bool borderBottom;
  final Function()? onTap;

  const SettingList({
    required this.label,
    this.value,
    this.borderTop = true,
    this.borderBottom = true,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            top: borderTop
                ? const BorderSide(color: kGreyColor)
                : BorderSide.none,
            bottom: borderBottom
                ? const BorderSide(color: kGreyColor)
                : BorderSide.none,
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: kGrey600Color,
              ),
            ),
            value != null
                ? Text(
                    value ?? '',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'SourceHanSansJP-Bold',
                    ),
                  )
                : const Icon(
                    Icons.chevron_right,
                    color: kGrey600Color,
                  ),
          ],
        ),
      ),
    );
  }
}
