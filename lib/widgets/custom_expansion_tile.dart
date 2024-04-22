import 'package:flutter/material.dart';
import 'package:kintaikei_app/common/style.dart';

class CustomExpansionTile extends StatelessWidget {
  final String label;
  final List<Widget> children;

  const CustomExpansionTile({
    required this.label,
    required this.children,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border.symmetric(
          horizontal: BorderSide(color: kGrey300Color),
        ),
      ),
      child: ExpansionTile(
        title: Text(label),
        children: [
          Container(
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: kGrey300Color),
              ),
            ),
            padding: const EdgeInsets.all(8.0),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }
}
