import 'package:flutter/material.dart';
import 'package:kintaikei_app/common/style.dart';

class CustomDropdown extends StatelessWidget {
  const CustomDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: kGrey300Color),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: DropdownButton<String>(
        underline: Container(),
        isExpanded: true,
        value: '(有)アゴラ・クリエーション',
        onChanged: (value) {},
        items: const [
          DropdownMenuItem(
            value: '(有)アゴラ・クリエーション',
            child: Text(
              '(有)アゴラ・クリエーション',
              style: TextStyle(fontSize: 12),
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
