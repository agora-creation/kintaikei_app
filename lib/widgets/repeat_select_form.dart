import 'package:flutter/material.dart';
import 'package:kintaikei_app/common/style.dart';
import 'package:toggle_switch/toggle_switch.dart';

class RepeatSelectForm extends StatelessWidget {
  final bool repeat;
  final Function(bool?) repeatOnChanged;
  final String interval;
  final Function(String) intervalOnChanged;
  final List<String> weeks;
  final Function(String) weeksOnChanged;

  const RepeatSelectForm({
    required this.repeat,
    required this.repeatOnChanged,
    required this.interval,
    required this.intervalOnChanged,
    required this.weeks,
    required this.weeksOnChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: kGrey300Color),
            borderRadius: const BorderRadius.all(Radius.circular(8)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: DropdownButton<bool>(
            underline: Container(),
            isExpanded: true,
            value: repeat,
            onChanged: repeatOnChanged,
            items: const [
              DropdownMenuItem<bool>(
                value: false,
                child: Text(
                  '繰り返さない',
                  style: TextStyle(
                    color: kBlackColor,
                    fontSize: 18,
                  ),
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              DropdownMenuItem<bool>(
                value: true,
                child: Text(
                  '繰り返す',
                  style: TextStyle(
                    color: kBlackColor,
                    fontSize: 18,
                  ),
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        repeat
            ? Container(
                decoration: BoxDecoration(
                  border: Border.all(color: kGrey300Color),
                ),
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ToggleSwitch(
                      initialLabelIndex: kRepeatIntervals.indexOf(interval),
                      totalSwitches: kRepeatIntervals.length,
                      labels: kRepeatIntervals,
                      onToggle: (index) {
                        if (index == null) return;
                        intervalOnChanged(kRepeatIntervals[index]);
                      },
                    ),
                    interval == kRepeatIntervals[1]
                        ? Column(
                            children: kWeeks.map((e) {
                              return CheckboxListTile(
                                title: Text(e),
                                value: weeks.contains(e),
                                onChanged: (value) {
                                  weeksOnChanged(e);
                                },
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                              );
                            }).toList(),
                          )
                        : Container(),
                  ],
                ),
              )
            : Container(),
      ],
    );
  }
}
