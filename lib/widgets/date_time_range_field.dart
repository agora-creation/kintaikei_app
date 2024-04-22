import 'package:flutter/material.dart';
import 'package:kintaikei_app/common/functions.dart';
import 'package:kintaikei_app/common/style.dart';

class DateTimeRangeField extends StatelessWidget {
  final DateTime startedAt;
  final Function()? startedOnTap;
  final DateTime endedAt;
  final Function()? endedOnTap;
  final bool allDay;
  final Function(bool?)? allDayOnChanged;

  const DateTimeRangeField({
    required this.startedAt,
    this.startedOnTap,
    required this.endedAt,
    this.endedOnTap,
    required this.allDay,
    this.allDayOnChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: kGrey300Color),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: startedOnTap,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        convertDateText('yyyy年MM月dd日(E)', startedAt),
                        style: const TextStyle(fontSize: 14),
                      ),
                      Text(
                        convertDateText('HH:mm', startedAt),
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'SourceHanSansJP-Bold',
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: kGrey600Color,
                  size: 16,
                ),
                GestureDetector(
                  onTap: endedOnTap,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        convertDateText('yyyy年MM月dd日(E)', endedAt),
                        style: const TextStyle(fontSize: 14),
                      ),
                      Text(
                        convertDateText('HH:mm', endedAt),
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'SourceHanSansJP-Bold',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: kGrey300Color)),
            ),
            child: CheckboxListTile(
              value: allDay,
              onChanged: allDayOnChanged,
              title: const Text('終日'),
            ),
          ),
        ],
      ),
    );
  }
}
