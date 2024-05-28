import 'package:flutter/material.dart';
import 'package:kintaikei_app/common/style.dart';

class BottomNaviBar extends StatelessWidget {
  final String? leftLabel;
  final Function()? leftOnTap;
  final String? rightLabel;
  final Function()? rightOnTap;

  const BottomNaviBar({
    this.leftLabel,
    this.leftOnTap,
    this.rightLabel,
    this.rightOnTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: kGrey300Color),
        ),
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 12,
        horizontal: 8,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          leftLabel != null
              ? GestureDetector(
                  onTap: leftOnTap,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.chevron_left,
                        size: 24,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        leftLabel ?? '',
                        style: const TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                )
              : Container(),
          rightLabel != null
              ? GestureDetector(
                  onTap: rightOnTap,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        rightLabel ?? '',
                        style: const TextStyle(fontSize: 20),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.chevron_right,
                        size: 24,
                      ),
                    ],
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
