import 'package:flutter/material.dart';
import 'package:kintaikei_app/common/style.dart';
import 'package:kintaikei_app/models/work.dart';
import 'package:kintaikei_app/providers/login.dart';
import 'package:kintaikei_app/providers/work.dart';
import 'package:kintaikei_app/widgets/info_label.dart';
import 'package:kintaikei_app/widgets/info_value.dart';

class StampModBreakScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final WorkProvider workProvider;
  final WorkModel work;

  const StampModBreakScreen({
    required this.loginProvider,
    required this.workProvider,
    required this.work,
    super.key,
  });

  @override
  State<StampModBreakScreen> createState() => _StampModBreakScreenState();
}

class _StampModBreakScreenState extends State<StampModBreakScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        backgroundColor: kWhiteColor,
        leading: IconButton(
          icon: const Icon(
            Icons.chevron_left,
            color: kBlackColor,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text('休憩時間の編集'),
        shape: const Border(bottom: BorderSide(color: kGrey300Color)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          InfoLabel(
            label: '合計休憩時間',
            child: InfoValue(widget.work.breakTime()),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
