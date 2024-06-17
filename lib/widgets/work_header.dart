import 'package:flutter/material.dart';
import 'package:kintaikei_app/common/style.dart';

class WorkHeader extends StatelessWidget {
  const WorkHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: kGrey300Color),
        ),
      ),
      padding: const EdgeInsets.all(8),
      child: const Row(
        children: [
          CircleAvatar(
            backgroundColor: kWhiteColor,
            radius: 24,
            child: Text(
              '日付',
              style: TextStyle(fontSize: 18),
            ),
          ),
          Expanded(
            child: ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text('出勤時間'),
                  Text('退勤時間'),
                  Text('勤務時間'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
