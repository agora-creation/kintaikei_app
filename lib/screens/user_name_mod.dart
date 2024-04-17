import 'package:flutter/material.dart';
import 'package:kintaikei_app/common/style.dart';
import 'package:kintaikei_app/providers/login.dart';

class UserNameModScreen extends StatefulWidget {
  final LoginProvider loginProvider;

  const UserNameModScreen({
    required this.loginProvider,
    super.key,
  });

  @override
  State<UserNameModScreen> createState() => _UserNameModScreenState();
}

class _UserNameModScreenState extends State<UserNameModScreen> {
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
        title: const Text('名前の変更'),
        shape: const Border(bottom: BorderSide(color: kGrey300Color)),
      ),
    );
  }
}
