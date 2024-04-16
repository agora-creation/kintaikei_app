import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:kintaikei_app/common/functions.dart';
import 'package:kintaikei_app/common/style.dart';
import 'package:kintaikei_app/providers/login.dart';
import 'package:kintaikei_app/screens/home.dart';
import 'package:kintaikei_app/services/ldb.dart';
import 'package:kintaikei_app/widgets/custom_alert_dialog.dart';
import 'package:kintaikei_app/widgets/custom_dialog_button.dart';
import 'package:kintaikei_app/widgets/custom_intro_screen.dart';
import 'package:kintaikei_app/widgets/custom_text_form_field.dart';
import 'package:kintaikei_app/widgets/intro_button.dart';
import 'package:kintaikei_app/widgets/link_text.dart';
import 'package:provider/provider.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  LDBService ldbService = LDBService();
  final introKey = GlobalKey<IntroductionScreenState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LoginProvider>(context);
    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: CustomIntroScreen(
          introKey: introKey,
          pages: [
            PageViewModel(
              image: Center(
                child: Image.network(
                  kWatchImageUrl,
                  height: 150,
                ),
              ),
              titleWidget: Column(
                children: [
                  const Text(
                    'はじめまして！',
                    style: kIntroStyle,
                  ),
                  const Text(
                    'わたしは『勤怠計』といいます。',
                    style: kIntroStyle,
                  ),
                  const SizedBox(height: 32),
                  IntroButton(
                    label: 'よろしく！',
                    labelColor: kWhiteColor,
                    backgroundColor: kBlueColor,
                    onPressed: () => introKey.currentState?.next(),
                  ),
                ],
              ),
              bodyWidget: Container(),
            ),
            PageViewModel(
              image: Center(
                child: Image.network(
                  kWatchImageUrl,
                  height: 150,
                ),
              ),
              titleWidget: Column(
                children: [
                  const Text(
                    'あなたの働いた時間を記録することができます。『勤怠用のストップウォッチ』のようなものです。',
                    style: kIntroStyle,
                  ),
                  const SizedBox(height: 32),
                  IntroButton(
                    label: 'わかりました！',
                    labelColor: kWhiteColor,
                    backgroundColor: kBlueColor,
                    onPressed: () => introKey.currentState?.next(),
                  ),
                  const SizedBox(height: 16),
                  LinkText(
                    label: '前に戻る',
                    color: kBlueColor,
                    onTap: () => introKey.currentState?.previous(),
                  ),
                ],
              ),
              bodyWidget: Container(),
            ),
            PageViewModel(
              image: Center(
                child: Image.network(
                  kWatchImageUrl,
                  height: 150,
                ),
              ),
              titleWidget: Column(
                children: [
                  const Text(
                    '記録したデータは、クラウド上に保存されます。スマートフォンが壊れても、記録したデータが無くなることはありません。',
                    style: kIntroStyle,
                  ),
                  const SizedBox(height: 32),
                  IntroButton(
                    label: 'わかりました！',
                    labelColor: kWhiteColor,
                    backgroundColor: kBlueColor,
                    onPressed: () => introKey.currentState?.next(),
                  ),
                  const SizedBox(height: 16),
                  LinkText(
                    label: '前に戻る',
                    color: kBlueColor,
                    onTap: () => introKey.currentState?.previous(),
                  ),
                ],
              ),
              bodyWidget: Container(),
            ),
            PageViewModel(
              image: Center(
                child: Image.network(
                  kWatchImageUrl,
                  height: 150,
                ),
              ),
              titleWidget: Column(
                children: [
                  const Text(
                    '次はあなたのことを教えてください。',
                    style: kIntroStyle,
                  ),
                  const Text(
                    'まずは、あなたのお名前を教えてください。',
                    style: kIntroStyle,
                  ),
                  const SizedBox(height: 32),
                  CustomTextFormField(
                    controller: nameController,
                    textInputType: TextInputType.name,
                    maxLines: 1,
                    label: '名前',
                    color: kMainColor,
                    prefix: Icons.person,
                  ),
                  const SizedBox(height: 8),
                  IntroButton(
                    label: '決定！',
                    labelColor: kWhiteColor,
                    backgroundColor: kBlueColor,
                    onPressed: () => introKey.currentState?.next(),
                  ),
                  const SizedBox(height: 16),
                  LinkText(
                    label: '前に戻る',
                    color: kBlueColor,
                    onTap: () => introKey.currentState?.previous(),
                  ),
                ],
              ),
              bodyWidget: Container(),
            ),
            PageViewModel(
              image: Center(
                child: Image.network(
                  kWatchImageUrl,
                  height: 150,
                ),
              ),
              titleWidget: Column(
                children: [
                  Text(
                    '${nameController.text}様、ご入力ありがとうございます。',
                    style: kIntroStyle,
                  ),
                  const Text(
                    '次に、お電話番号を教えてください。',
                    style: kIntroStyle,
                  ),
                  const Text(
                    'ご本人確認のため、SMSに認証コードをお送りさせていただきます。',
                    style: kIntroStyle,
                  ),
                  const SizedBox(height: 32),
                  CustomTextFormField(
                    controller: phoneNumberController,
                    textInputType: TextInputType.phone,
                    maxLines: 1,
                    label: '電話番号',
                    color: kMainColor,
                    prefix: Icons.phone,
                  ),
                  const SizedBox(height: 8),
                  IntroButton(
                    label: '認証コードを送信',
                    labelColor: kWhiteColor,
                    backgroundColor: kBlueColor,
                    onPressed: () async {
                      String? error = await loginProvider.sendCode(
                        phoneNumber: phoneNumberController.text,
                      );
                      if (error != null) {
                        if (!mounted) return;
                        showMessage(context, error, false);
                        return;
                      }
                      if (!mounted) return;
                      showMessage(context, '認証コードを送信しました', true);
                      showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (context) => AuthDialog(
                          introKey: introKey,
                          loginProvider: loginProvider,
                          phoneNumber: phoneNumberController.text,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  LinkText(
                    label: '前に戻る',
                    color: kBlueColor,
                    onTap: () => introKey.currentState?.previous(),
                  ),
                ],
              ),
              bodyWidget: Container(),
            ),
            PageViewModel(
              image: Center(
                child: Image.network(
                  kWatchImageUrl,
                  height: 150,
                ),
              ),
              titleWidget: Column(
                children: [
                  const Text(
                    'あなたのことを教えてくれてありがとう！',
                    style: kIntroStyle,
                  ),
                  const Text(
                    '早速、はじめてみましょう！',
                    style: kIntroStyle,
                  ),
                  const SizedBox(height: 32),
                  IntroButton(
                    label: 'はじめる',
                    labelColor: kWhiteColor,
                    backgroundColor: kBlueColor,
                    onPressed: () async {
                      if (!mounted) return;
                      pushReplacementScreen(context, const HomeScreen());
                    },
                  ),
                ],
              ),
              bodyWidget: Container(),
            ),
          ],
        ),
      ),
    );
  }
}

class AuthDialog extends StatefulWidget {
  final GlobalKey<IntroductionScreenState> introKey;
  final LoginProvider loginProvider;
  final String phoneNumber;

  const AuthDialog({
    required this.introKey,
    required this.loginProvider,
    required this.phoneNumber,
    super.key,
  });

  @override
  State<AuthDialog> createState() => _AuthDialogState();
}

class _AuthDialogState extends State<AuthDialog> {
  @override
  Widget build(BuildContext context) {
    return CustomAlertDialog(
      children: [
        const Text('SMSに届いた認証コードを入力してください。'),
        const SizedBox(height: 8),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //   children: [
        //     const SizedBox(width: 2),
        //     ...List.generate(pinCount, _buildTextField),
        //     const SizedBox(width: 2),
        //   ],
        // ),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerLeft,
          child: LinkText(
            label: '認証コードを再送する',
            color: kBlueColor,
            onTap: () async {
              String? error = await widget.loginProvider.sendCode(
                phoneNumber: widget.phoneNumber,
                reSend: true,
              );
              if (error != null) {
                if (!mounted) return;
                showMessage(context, error, false);
                return;
              }
              if (!mounted) return;
              showMessage(context, '認証コードを送信しました', true);
            },
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomDialogButton(
              label: 'キャンセル',
              labelColor: kWhiteColor,
              backgroundColor: kGreyColor,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            CustomDialogButton(
              label: '認証する',
              labelColor: kWhiteColor,
              backgroundColor: kBlueColor,
              onPressed: () {
                Navigator.pop(context);
                widget.introKey.currentState?.next();
              },
            ),
          ],
        ),
      ],
    );
  }
}
