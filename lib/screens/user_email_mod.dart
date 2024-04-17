import 'package:flutter/material.dart';
import 'package:kintaikei_app/common/style.dart';
import 'package:kintaikei_app/providers/login.dart';

class UserEmailModScreen extends StatefulWidget {
  final LoginProvider loginProvider;

  const UserEmailModScreen({
    required this.loginProvider,
    super.key,
  });

  @override
  State<UserEmailModScreen> createState() => _UserEmailModScreenState();
}

class _UserEmailModScreenState extends State<UserEmailModScreen> {
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
        title: const Text('メールアドレスの変更'),
        shape: const Border(bottom: BorderSide(color: kGrey300Color)),
      ),
    );
  }
}
