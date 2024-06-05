import 'package:flutter/material.dart';
import 'package:kintaikei_app/common/functions.dart';
import 'package:kintaikei_app/common/style.dart';
import 'package:kintaikei_app/models/company_group.dart';
import 'package:kintaikei_app/providers/home.dart';
import 'package:kintaikei_app/providers/login.dart';
import 'package:kintaikei_app/screens/login.dart';
import 'package:kintaikei_app/widgets/custom_alert_dialog.dart';
import 'package:kintaikei_app/widgets/custom_footer.dart';
import 'package:kintaikei_app/widgets/custom_text_field.dart';
import 'package:kintaikei_app/widgets/dialog_button.dart';
import 'package:kintaikei_app/widgets/info_label.dart';
import 'package:kintaikei_app/widgets/info_value.dart';
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
          const SettingHeader('あなたの情報'),
          const SizedBox(height: 8),
          SettingList(
            label: '名前',
            value: widget.loginProvider.user?.name ?? '',
            onTap: () => showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) => ModNameDialog(
                loginProvider: widget.loginProvider,
              ),
            ),
          ),
          SettingList(
            label: 'メールアドレス',
            value: widget.loginProvider.user?.email ?? '',
            borderTop: false,
            onTap: () => showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) => ModEmailDialog(
                loginProvider: widget.loginProvider,
              ),
            ),
          ),
          SettingList(
            label: 'パスワード',
            value: '********',
            borderTop: false,
            onTap: () => showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) => ModPasswordDialog(
                loginProvider: widget.loginProvider,
              ),
            ),
          ),
          const SizedBox(height: 16),
          widget.loginProvider.groups.isNotEmpty
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SettingHeader('現在の勤務先'),
                    const SizedBox(height: 8),
                    const Divider(height: 1, color: kGrey600Color),
                    Column(
                      children: widget.loginProvider.groups.map((group) {
                        return SettingList(
                          label: '${group.companyName} ${group.name}',
                          borderTop: false,
                          onTap: () => showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) => GroupDialog(
                              loginProvider: widget.loginProvider,
                              homeProvider: widget.homeProvider,
                              group: group,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                  ],
                )
              : Container(),
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
      bottomNavigationBar: CustomFooter(
        loginProvider: widget.loginProvider,
        homeProvider: widget.homeProvider,
      ),
    );
  }
}

class ModNameDialog extends StatefulWidget {
  final LoginProvider loginProvider;

  const ModNameDialog({
    required this.loginProvider,
    super.key,
  });

  @override
  State<ModNameDialog> createState() => _ModNameDialogState();
}

class _ModNameDialogState extends State<ModNameDialog> {
  TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    nameController.text = widget.loginProvider.user?.name ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomAlertDialog(
      children: [
        InfoLabel(
          label: '名前',
          child: CustomTextField(
            controller: nameController,
            textInputType: TextInputType.name,
            maxLines: 1,
          ),
        ),
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
              label: '保存する',
              labelColor: kWhiteColor,
              backgroundColor: kBlueColor,
              onPressed: () async {
                String? error = await widget.loginProvider.updateName(
                  name: nameController.text,
                );
                if (error != null) {
                  if (!mounted) return;
                  showMessage(context, error, false);
                  return;
                }
                await widget.loginProvider.reloadData();
                if (!mounted) return;
                showMessage(context, '名前を変更しました', true);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ],
    );
  }
}

class ModEmailDialog extends StatefulWidget {
  final LoginProvider loginProvider;

  const ModEmailDialog({
    required this.loginProvider,
    super.key,
  });

  @override
  State<ModEmailDialog> createState() => _ModEmailDialogState();
}

class _ModEmailDialogState extends State<ModEmailDialog> {
  TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    emailController.text = widget.loginProvider.user?.email ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomAlertDialog(
      children: [
        InfoLabel(
          label: 'メールアドレス',
          child: CustomTextField(
            controller: emailController,
            textInputType: TextInputType.emailAddress,
            maxLines: 1,
          ),
        ),
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
              label: '保存する',
              labelColor: kWhiteColor,
              backgroundColor: kBlueColor,
              onPressed: () async {
                String? error = await widget.loginProvider.updateEmail(
                  email: emailController.text,
                );
                if (error != null) {
                  if (!mounted) return;
                  showMessage(context, error, false);
                  return;
                }
                await widget.loginProvider.reloadData();
                if (!mounted) return;
                showMessage(context, 'メールアドレスを変更しました', true);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ],
    );
  }
}

class ModPasswordDialog extends StatefulWidget {
  final LoginProvider loginProvider;

  const ModPasswordDialog({
    required this.loginProvider,
    super.key,
  });

  @override
  State<ModPasswordDialog> createState() => _ModPasswordDialogState();
}

class _ModPasswordDialogState extends State<ModPasswordDialog> {
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return CustomAlertDialog(
      children: [
        InfoLabel(
          label: 'パスワード',
          child: CustomTextField(
            controller: passwordController,
            textInputType: TextInputType.visiblePassword,
            maxLines: 1,
            obscureText: true,
          ),
        ),
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
              label: '保存する',
              labelColor: kWhiteColor,
              backgroundColor: kBlueColor,
              onPressed: () async {
                String? error = await widget.loginProvider.updatePassword(
                  password: passwordController.text,
                );
                if (error != null) {
                  if (!mounted) return;
                  showMessage(context, error, false);
                  return;
                }
                await widget.loginProvider.reloadData();
                if (!mounted) return;
                showMessage(context, 'パスワードを変更しました', true);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ],
    );
  }
}

class GroupDialog extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final CompanyGroupModel group;

  const GroupDialog({
    required this.loginProvider,
    required this.homeProvider,
    required this.group,
    super.key,
  });

  @override
  State<GroupDialog> createState() => _GroupDialogState();
}

class _GroupDialogState extends State<GroupDialog> {
  @override
  Widget build(BuildContext context) {
    return CustomAlertDialog(
      children: [
        InfoLabel(
          label: '勤務先',
          child: InfoValue('${widget.group.companyName} ${widget.group.name}'),
        ),
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
              label: '退職する',
              labelColor: kWhiteColor,
              backgroundColor: kRedColor,
              onPressed: () async {
                String? error = await widget.loginProvider.updateExit(
                  group: widget.group,
                );
                if (error != null) {
                  if (!mounted) return;
                  showMessage(context, error, false);
                  return;
                }
                await widget.loginProvider.reloadData();
                await Future.delayed(const Duration(seconds: 2));
                await widget.homeProvider.initGroup(
                  widget.loginProvider.groups,
                );
                if (!mounted) return;
                showMessage(context, '退職しました', true);
                Navigator.pop(context);
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
