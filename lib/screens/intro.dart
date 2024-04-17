import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:kintaikei_app/common/functions.dart';
import 'package:kintaikei_app/common/style.dart';
import 'package:kintaikei_app/providers/login.dart';
import 'package:kintaikei_app/screens/home.dart';
import 'package:kintaikei_app/screens/login.dart';
import 'package:kintaikei_app/services/local_db.dart';
import 'package:kintaikei_app/widgets/custom_intro_screen.dart';
import 'package:kintaikei_app/widgets/custom_text_form_field.dart';
import 'package:kintaikei_app/widgets/info_label.dart';
import 'package:kintaikei_app/widgets/info_value.dart';
import 'package:kintaikei_app/widgets/intro_button.dart';
import 'package:kintaikei_app/widgets/link_text.dart';
import 'package:provider/provider.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  LocalDBService ldbService = LocalDBService();
  final introKey = GlobalKey<IntroductionScreenState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController rePasswordController = TextEditingController();
  bool obscureText = true;
  bool reObscureText = true;

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
                  const SizedBox(height: 32),
                  LinkText(
                    label: '以前、使ったことがある方はコチラ！',
                    color: kBlueColor,
                    onTap: () => pushReplacementScreen(
                      context,
                      const LoginScreen(),
                    ),
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
                    '記録したデータは、クラウド上に保存されます。スマートフォンが壊れても、記録したデータが消えてしまうことはありません。',
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
                    'まずは、あなたの情報を登録します。',
                    style: kIntroStyle,
                  ),
                  const Text(
                    'あなたのお名前を教えてください。',
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
                  const SizedBox(height: 16),
                  nameController.text != ''
                      ? IntroButton(
                          label: '決定！',
                          labelColor: kWhiteColor,
                          backgroundColor: kBlueColor,
                          onPressed: () => introKey.currentState?.next(),
                        )
                      : const IntroButton(
                          label: '決定！',
                          labelColor: kWhiteColor,
                          backgroundColor: kGreyColor,
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
                    '次に、あなたのメールアドレスを入力してください。',
                    style: kIntroStyle,
                  ),
                  const Text(
                    '次回、ログインする場合に必要な情報になります。',
                    style: kIntroStyle,
                  ),
                  const SizedBox(height: 32),
                  CustomTextFormField(
                    controller: emailController,
                    textInputType: TextInputType.emailAddress,
                    maxLines: 1,
                    label: 'メールアドレス',
                    color: kMainColor,
                    prefix: Icons.email,
                  ),
                  const SizedBox(height: 16),
                  emailController.text != ''
                      ? IntroButton(
                          label: '決定！',
                          labelColor: kWhiteColor,
                          backgroundColor: kBlueColor,
                          onPressed: () => introKey.currentState?.next(),
                        )
                      : const IntroButton(
                          label: '決定！',
                          labelColor: kWhiteColor,
                          backgroundColor: kGreyColor,
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
                    '次に、パスワードを入力してください。',
                    style: kIntroStyle,
                  ),
                  const Text(
                    '次回、ログインする場合に必要な情報になります。',
                    style: kIntroStyle,
                  ),
                  const SizedBox(height: 32),
                  CustomTextFormField(
                    controller: passwordController,
                    obscureText: obscureText,
                    textInputType: TextInputType.visiblePassword,
                    maxLines: 1,
                    label: 'パスワード',
                    color: kMainColor,
                    prefix: Icons.password,
                    suffix:
                        obscureText ? Icons.visibility_off : Icons.visibility,
                    onTap: () {
                      setState(() {
                        obscureText = !obscureText;
                      });
                    },
                  ),
                  const SizedBox(height: 8),
                  CustomTextFormField(
                    controller: rePasswordController,
                    obscureText: reObscureText,
                    textInputType: TextInputType.visiblePassword,
                    maxLines: 1,
                    label: 'パスワードの確認',
                    color: kMainColor,
                    prefix: Icons.password,
                    suffix:
                        reObscureText ? Icons.visibility_off : Icons.visibility,
                    onTap: () {
                      setState(() {
                        reObscureText = !reObscureText;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  passwordController.text != '' &&
                          passwordController.text == rePasswordController.text
                      ? IntroButton(
                          label: '決定！',
                          labelColor: kWhiteColor,
                          backgroundColor: kBlueColor,
                          onPressed: () => introKey.currentState?.next(),
                        )
                      : const IntroButton(
                          label: '決定！',
                          labelColor: kWhiteColor,
                          backgroundColor: kGreyColor,
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
              titleWidget: Column(
                children: [
                  const Text(
                    '以下の内容でよろしいですか？',
                    style: kIntroStyle,
                  ),
                  const SizedBox(height: 8),
                  InfoLabel(
                    label: '名前',
                    child: InfoValue(nameController.text),
                  ),
                  const SizedBox(height: 8),
                  InfoLabel(
                    label: 'メールアドレス',
                    child: InfoValue(emailController.text),
                  ),
                  const SizedBox(height: 8),
                  const InfoLabel(
                    label: 'パスワード',
                    child: InfoValue('********'),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    '問題なければ、以下のボタンをタップして、はじめてみましょう！',
                    style: kIntroStyle,
                  ),
                  const SizedBox(height: 16),
                  IntroButton(
                    label: 'はじめる',
                    labelColor: kWhiteColor,
                    backgroundColor: kBlueColor,
                    onPressed: () async {
                      String? error = await loginProvider.register(
                        name: nameController.text,
                        email: emailController.text,
                        password: passwordController.text,
                      );
                      if (error != null) {
                        if (!mounted) return;
                        showMessage(context, error, false);
                        return;
                      }
                      if (!mounted) return;
                      pushReplacementScreen(context, const HomeScreen());
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
          ],
        ),
      ),
    );
  }
}
