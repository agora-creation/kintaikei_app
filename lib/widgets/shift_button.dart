import 'package:flutter/material.dart';
import 'package:kintaikei_app/common/style.dart';

class ShiftButton extends StatelessWidget {
  final Function()? onTap;

  const ShiftButton({
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: kGrey300Color),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(8),
          child: const Icon(
            Icons.view_list,
            color: kMainColor,
            size: 32,
          ),
        ),
      ),
    );
  }
}
