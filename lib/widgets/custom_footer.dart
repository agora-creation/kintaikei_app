import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:kintaikei_app/common/style.dart';
import 'package:kintaikei_app/providers/home.dart';
import 'package:kintaikei_app/providers/login.dart';
import 'package:kintaikei_app/services/config.dart';
import 'package:kintaikei_app/widgets/custom_alert_dialog.dart';
import 'package:kintaikei_app/widgets/dialog_button.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomFooter extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;

  const CustomFooter({
    required this.loginProvider,
    required this.homeProvider,
    super.key,
  });

  @override
  State<CustomFooter> createState() => _CustomFooterState();
}

class _CustomFooterState extends State<CustomFooter>
    with WidgetsBindingObserver {
  void _versionCheck() async {
    if (await ConfigService().checkVersion()) {
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (context) => const VersionUpDialog(),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {});
    FlutterAppBadger.removeBadge();
    // _versionCheck();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      FlutterAppBadger.removeBadge();
    } else if (state == AppLifecycleState.paused) {
    } else if (state == AppLifecycleState.detached) {}
  }

  @override
  Widget build(BuildContext context) {
    return Container(height: 0);
  }
}

class VersionUpDialog extends StatelessWidget {
  const VersionUpDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomAlertDialog(
      children: [
        const Text(
          'バージョンアップのお知らせ',
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 8),
        const Text('新しいバージョンのアプリが利用可能になりました。アプリストアより更新を行ってから、ご利用ください。'),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            DialogButton(
              label: '閉じる',
              labelColor: kWhiteColor,
              backgroundColor: kGreyColor,
              onPressed: () => Navigator.pop(context),
            ),
            DialogButton(
              label: '更新する',
              labelColor: kWhiteColor,
              backgroundColor: kBlueColor,
              onPressed: () async {
                String urlText = '';
                if (Platform.isIOS) {
                  urlText = ConfigService().APP_STORE_URL;
                } else {
                  urlText = ConfigService().PLAY_STORE_URL;
                }
                Uri url = Uri.parse(urlText);
                if (!await launchUrl(url)) {
                  throw Exception('Could not launch $url');
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}
