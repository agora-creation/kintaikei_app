import 'package:flutter/material.dart';
import 'package:kintaikei_app/common/style.dart';
import 'package:kintaikei_app/widgets/date_time_widget.dart';
import 'package:kintaikei_app/widgets/group_dropdown.dart';
import 'package:kintaikei_app/widgets/info_label.dart';
import 'package:kintaikei_app/widgets/stamp_button.dart';

class StampScreen extends StatefulWidget {
  const StampScreen({super.key});

  @override
  State<StampScreen> createState() => _StampScreenState();
}

class _StampScreenState extends State<StampScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        backgroundColor: kWhiteColor,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.close,
              color: kBlackColor,
            ),
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  const Text(
                    'おはようございます！〇〇様',
                    style: TextStyle(fontSize: 18),
                  ),
                  const Text(
                    '出勤時間を打刻しましょう',
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 16),
                  InfoLabel(
                    label: '出勤先の会社を選ぶ',
                    child: GroupDropdown(
                      value: '(有)アゴラ・クリエーション',
                      onChanged: (value) {},
                    ),
                  ),
                ],
              ),
              const DateTimeWidget(),
              Column(
                children: [
                  StampButton(
                    label: '出勤する',
                    labelColor: kWhiteColor,
                    backgroundColor: kBlueColor,
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                  ),
                  StampButton(
                    label: '退勤する',
                    labelColor: kWhiteColor,
                    backgroundColor: kRedColor,
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
