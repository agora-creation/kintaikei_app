import 'package:flutter/material.dart';
import 'package:kintaikei_app/common/functions.dart';
import 'package:kintaikei_app/common/style.dart';
import 'package:kintaikei_app/models/work.dart';

class WorkList extends StatelessWidget {
  final WorkModel work;
  final Function()? onTap;

  const WorkList({
    required this.work,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: kGrey300Color)),
      ),
      child: ListTile(
        title: Text(
          convertDateText('MM月dd日 (E)', work.startedAt),
          style: const TextStyle(color: kGrey600Color),
        ),
        subtitle: Text(
          work.companyName != '' && work.groupName != ''
              ? '${work.companyName} ${work.groupName}'
              : kDefaultGroupText,
          style: const TextStyle(color: kGrey600Color),
        ),
        trailing: Text(
          convertTimeText(work.totalTime()),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'SourceHanSansJP-Bold',
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
