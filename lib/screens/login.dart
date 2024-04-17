import 'package:flutter/material.dart';
import 'package:kintaikei_app/common/functions.dart';
import 'package:kintaikei_app/common/style.dart';
import 'package:kintaikei_app/providers/login.dart';
import 'package:kintaikei_app/screens/home.dart';
import 'package:kintaikei_app/screens/intro.dart';
import 'package:kintaikei_app/widgets/custom_button.dart';
import 'package:kintaikei_app/widgets/custom_text_form_field.dart';
import 'package:kintaikei_app/widgets/link_text.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LoginProvider>(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Column(
              children: [
                Text(
                  '勤怠計',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'SourceHanSansJP-Bold',
                    letterSpacing: 10,
                  ),
                ),
                Text(
                  '勤怠サービス',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  CustomTextFormField(
                    controller: emailController,
                    textInputType: TextInputType.emailAddress,
                    maxLines: 1,
                    label: 'メールアドレス',
                    color: kMainColor,
                    prefix: Icons.email,
                  ),
                  const SizedBox(height: 8),
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
                  const SizedBox(height: 16),
                  emailController.text != '' && passwordController.text != ''
                      ? CustomButton(
                          label: 'ログイン',
                          labelColor: kWhiteColor,
                          backgroundColor: kBlueColor,
                          onPressed: () async {
                            String? error = await loginProvider.login(
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
                        )
                      : const CustomButton(
                          label: 'ログイン',
                          labelColor: kWhiteColor,
                          backgroundColor: kGreyColor,
                        ),
                  const SizedBox(height: 32),
                  LinkText(
                    label: 'はじめて利用する方はコチラ！',
                    color: kBlueColor,
                    onTap: () => pushReplacementScreen(
                      context,
                      const IntroScreen(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
