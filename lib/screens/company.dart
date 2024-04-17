import 'package:flutter/material.dart';
import 'package:kintaikei_app/common/style.dart';
import 'package:kintaikei_app/providers/login.dart';

class CompanyScreen extends StatefulWidget {
  final LoginProvider loginProvider;

  const CompanyScreen({
    required this.loginProvider,
    super.key,
  });

  @override
  State<CompanyScreen> createState() => _CompanyScreenState();
}

class _CompanyScreenState extends State<CompanyScreen> {
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
        title: const Text('現在の勤務先一覧'),
        shape: const Border(bottom: BorderSide(color: kGrey300Color)),
      ),
    );
  }
}
