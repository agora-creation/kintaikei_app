import 'package:flutter/material.dart';
import 'package:kintaikei_app/common/functions.dart';
import 'package:kintaikei_app/common/style.dart';
import 'package:kintaikei_app/providers/home.dart';
import 'package:kintaikei_app/providers/login.dart';
import 'package:kintaikei_app/screens/group.dart';
import 'package:kintaikei_app/screens/intro.dart';
import 'package:kintaikei_app/screens/user_email_mod.dart';
import 'package:kintaikei_app/screens/user_name_mod.dart';
import 'package:kintaikei_app/screens/user_password_mod.dart';
import 'package:kintaikei_app/widgets/custom_alert_dialog.dart';
import 'package:kintaikei_app/widgets/dialog_button.dart';
import 'package:kintaikei_app/widgets/link_text.dart';
import 'package:kintaikei_app/widgets/setting_header.dart';
import 'package:kintaikei_app/widgets/setting_list.dart';
import 'package:url_launcher/url_launcher.dart';

class UserScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;

  const UserScreen({
    required this.loginProvider,
    required this.homeProvider,
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
            label: '現在の勤務先',
            onTap: () => pushScreen(
              context,
              GroupScreen(
                loginProvider: widget.loginProvider,
                homeProvider: widget.homeProvider,
              ),
            ),
          ),
          const SettingHeader('アプリについて'),
          SettingList(
            label: 'プライバシーポリシー',
            borderTop: false,
            onTap: () async {
              Uri url = Uri.parse(
                'https://agora-c.com/kintaikei/privacy-policy.html',
              );
              if (!await launchUrl(url)) {
                throw Exception('Could not launch $url');
              }
            },
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
