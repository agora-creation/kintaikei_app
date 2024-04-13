import 'package:flutter/material.dart';
import 'package:kintaikei_app/common/style.dart';

class CustomDropdown extends StatelessWidget {
  final dynamic value;
  final Function(Object?)? onChanged;

  const CustomDropdown({
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
      child: DropdownButton(
        underline: Container(),
        isExpanded: true,
        value: value,
        onChanged: onChanged,
        items: const [
          DropdownMenuItem(
            value: '(有)アゴラ・クリエーション',
            child: Text(
              '(有)アゴラ・クリエーション',
              style: TextStyle(fontSize: 14),
              softWrap: false,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}
