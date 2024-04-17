import 'package:flutter/material.dart';
import 'package:kintaikei_app/common/functions.dart';
import 'package:kintaikei_app/common/style.dart';
import 'package:kintaikei_app/providers/login.dart';
import 'package:kintaikei_app/screens/company.dart';
import 'package:kintaikei_app/screens/intro.dart';
import 'package:kintaikei_app/screens/user_email_mod.dart';
import 'package:kintaikei_app/screens/user_name_mod.dart';
import 'package:kintaikei_app/screens/user_password_mod.dart';
import 'package:kintaikei_app/widgets/custom_alert_dialog.dart';
import 'package:kintaikei_app/widgets/dialog_button.dart';
import 'package:kintaikei_app/widgets/link_text.dart';
import 'package:kintaikei_app/widgets/setting_header.dart';
import 'package:kintaikei_app/widgets/setting_list.dart';

class UserScreen extends StatefulWidget {
  final LoginProvider loginProvider;

  const UserScreen({
    required this.loginProvider,
    super.key,
  });

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        backgroundColor: kWhiteColor,
        automaticallyImplyLeading: false,
        title: const Text('マイページ'),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.close,
              color: kBlackColor,
            ),
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
          ),
        ],
        shape: const Border(bottom: BorderSide(color: kGrey300Color)),
      ),
      body: ListView(
        children: [
          const SettingHeader('ユーザー設定'),
          SettingList(
            label: '名前',
            value: widget.loginProvider.user?.name ?? '',
            onTap: () => pushScreen(
              context,
              UserNameModScreen(loginProvider: widget.loginProvider),
            ),
          ),
          SettingList(
            label: 'メールアドレス',
            value: widget.loginProvider.user?.email ?? '',
            borderTop: false,
            onTap: () => pushScreen(
              context,
              UserEmailModScreen(loginProvider: widget.loginProvider),
            ),
          ),
          SettingList(
            label: 'パスワード',
            value: '********',
            borderTop: false,
            onTap: () => pushScreen(
              context,
              UserPasswordModScreen(loginProvider: widget.loginProvider),
            ),
          ),
          const SettingHeader('勤務先設定'),
          SettingList(
            label: '現在の勤務先を確認する',
            onTap: () => pushScreen(
              context,
              CompanyScreen(loginProvider: widget.loginProvider),
            ),
          ),
          const SettingHeader('アプリについて'),
          SettingList(
            label: '使い方を確認する',
            onTap: () {},
          ),
          SettingList(
            label: 'レビューを書く',
            borderTop: false,
            onTap: () {},
          ),
          SettingList(
            label: '友達に教える',
            borderTop: false,
            onTap: () {},
          ),
          SettingList(
            label: 'プライバシーポリシー',
            borderTop: false,
            onTap: () {},
          ),
          FutureBuilder<String>(
            future: getVersionInfo(),
            builder: (context, snapshot) {
              return SettingList(
                label: 'バージョン',
                value: snapshot.hasData ? snapshot.data : '',
                borderTop: false,
              );
            },
          ),
          const SizedBox(height: 24),
          Center(
            child: LinkText(
              label: 'ログアウト',
              color: kRedColor,
              onTap: () => showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) => LogoutDialog(
                  loginProvider: widget.loginProvider,
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class LogoutDialog extends StatefulWidget {
  final LoginProvider loginProvider;

  const LogoutDialog({
    required this.loginProvider,
    super.key,
  });

  @override
  State<LogoutDialog> createState() => _LogoutDialogState();
}

class _LogoutDialogState extends State<LogoutDialog> {
  @override
  Widget build(BuildContext context) {
    return CustomAlertDialog(
      children: [
        const Text('本当にログアウトしますか？'),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            DialogButton(
              label: 'キャンセル',
              labelColor: kWhiteColor,
              backgroundColor: kGreyColor,
              onPressed: () => Navigator.pop(context),
            ),
            DialogButton(
              label: 'ログアウト',
              labelColor: kWhiteColor,
              backgroundColor: kRedColor,
              onPressed: () async {
                await widget.loginProvider.logout();
                if (!mounted) return;
                pushReplacementScreen(context, const IntroScreen());
              },
            ),
          ],
        ),
      ],
    );
  }
}
