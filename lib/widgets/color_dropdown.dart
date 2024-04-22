import 'package:flutter/material.dart';
import 'package:kintaikei_app/common/style.dart';

class ColorDropdown extends StatelessWidget {
  final Color? value;
  final Function(Color?)? onChanged;

  const ColorDropdown({
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
      child: DropdownButton<Color?>(
        underline: Container(),
        isExpanded: true,
        value: value,
        onChanged: onChanged,
        items: kColors.map((color) {
          return DropdownMenuItem<Color?>(
            value: color,
            child: Container(
              color: color,
              height: 25,
            ),
          );
        }).toList(),
      ),
    );
  }
}
