import 'package:flutter/material.dart';
import 'package:kintaikei_app/common/style.dart';

class HistoryHeader extends StatelessWidget {
  const HistoryHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kGrey300Color,
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      child: const Text('打刻履歴'),
    );
  }
}
