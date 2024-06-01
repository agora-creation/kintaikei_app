import 'package:flutter/material.dart';
import 'package:kintaikei_app/common/style.dart';

class PlanList extends StatelessWidget {
  const PlanList({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: kMainColor,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 12,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '00:00',
                  style: const TextStyle(
                    color: kWhiteColor,
                    fontSize: 14,
                  ),
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                Text(
                  'ひろめ',
                  style: const TextStyle(
                    color: kWhiteColor,
                    fontSize: 14,
                  ),
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ],
            ),
            Text(
              'あああああ',
              style: const TextStyle(
                color: kWhiteColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              softWrap: false,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }
}
