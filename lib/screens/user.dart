import 'package:flutter/material.dart';
import 'package:kintaikei_app/common/functions.dart';
import 'package:kintaikei_app/common/style.dart';
import 'package:kintaikei_app/providers/home.dart';
import 'package:kintaikei_app/providers/login.dart';
import 'package:kintaikei_app/screens/login.dart';
import 'package:kintaikei_app/widgets/custom_alert_dialog.dart';
import 'package:kintaikei_app/widgets/dialog_button.dart';
import 'package:kintaikei_app/widgets/link_text.dart';
import 'package:kintaikei_app/widgets/setting_header.dart';
import 'package:kintaikei_app/widgets/setting_list.dart';
import 'package:page_transition/page_transition.dart';
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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(widget.loginProvider.user?.name ?? ''),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
          ),
        ],
      ),
      body: ListView(
        children: [
          const SizedBox(height: 16),
          const SettingHeader('あなたの情報を変更する'),
          const SizedBox(height: 8),
          SettingList(
            label: '名前',
            value: widget.loginProvider.user?.name ?? '',
            onTap: () => showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) => ModNameDialog(
                loginProvider: widget.loginProvider,
                homeProvider: widget.homeProvider,
              ),
            ),
          ),
          SettingList(
            label: 'メールアドレス',
            value: widget.loginProvider.user?.email ?? '',
            borderTop: false,
            onTap: () {},
          ),
          SettingList(
            label: 'パスワード',
            value: '********',
            borderTop: false,
            onTap: () {},
          ),
          const SizedBox(height: 16),
          const SettingHeader('勤務先を設定する'),
          const SizedBox(height: 8),
          SettingList(
            label: '現在の勤務先',
            onTap: () {},
          ),
          const SizedBox(height: 16),
          const SettingHeader('アプリについて'),
          const SizedBox(height: 8),
          SettingList(
            label: 'プライバシーポリシー',
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
                  homeProvider: widget.homeProvider,
                ),
              ),
            ),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}

class ModNameDialog extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;

  const ModNameDialog({
    required this.loginProvider,
    required this.homeProvider,
    super.key,
  });

  @override
  State<ModNameDialog> createState() => _ModNameDialogState();
}

class _ModNameDialogState extends State<ModNameDialog> {
  @override
  Widget build(BuildContext context) {
    return CustomAlertDialog(
      children: [
        const Text('本当にログアウトしますか？'),
        const SizedBox(height: 24),
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
                Navigator.pushReplacement(
                  context,
                  PageTransition(
                    type: PageTransitionType.bottomToTop,
                    child: LoginScreen(
                      loginProvider: widget.loginProvider,
                      homeProvider: widget.homeProvider,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}

class LogoutDialog extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;

  const LogoutDialog({
    required this.loginProvider,
    required this.homeProvider,
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
        const SizedBox(height: 24),
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
                Navigator.pushReplacement(
                  context,
                  PageTransition(
                    type: PageTransitionType.bottomToTop,
                    child: LoginScreen(
                      loginProvider: widget.loginProvider,
                      homeProvider: widget.homeProvider,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
