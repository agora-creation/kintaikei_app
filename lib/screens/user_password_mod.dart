import 'package:flutter/material.dart';
import 'package:kintaikei_app/common/style.dart';
import 'package:kintaikei_app/providers/login.dart';

class UserPasswordModScreen extends StatefulWidget {
  final LoginProvider loginProvider;

  const UserPasswordModScreen({
    required this.loginProvider,
    super.key,
  });

  @override
  State<UserPasswordModScreen> createState() => _UserPasswordModScreenState();
}

class _UserPasswordModScreenState extends State<UserPasswordModScreen> {
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
        title: const Text('パスワードの変更'),
        shape: const Border(bottom: BorderSide(color: kGrey300Color)),
      ),
    );
  }
}
