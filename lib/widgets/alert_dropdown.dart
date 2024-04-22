import 'package:flutter/material.dart';
import 'package:kintaikei_app/common/style.dart';

class AlertDropdown extends StatelessWidget {
  final int? value;
  final Function(int?)? onChanged;

  const AlertDropdown({
    required this.value,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: kGrey300Color),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: DropdownButton<int?>(
        underline: Container(),
        isExpanded: true,
        value: value,
        onChanged: onChanged,
        items: kAlertMinutes.map((minute) {
          return DropdownMenuItem<int?>(
            value: minute,
            child: minute == 0 ? const Text('通知しない') : Text('$minute分後に通知'),
          );
        }).toList(),
      ),
    );
  }
}
