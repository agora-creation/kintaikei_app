import 'package:flutter/material.dart';
import 'package:kintaikei_app/common/style.dart';

class MonthPickerButton extends StatelessWidget {
  const MonthPickerButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
      ),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: kGrey300Color),
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
        child: const Padding(
          padding: EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 8,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('2022年4月'),
              Icon(Icons.calendar_month, color: kGrey600Color),
            ],
          ),
        ),
      ),
    );
  }
}
