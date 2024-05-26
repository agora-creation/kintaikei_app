import 'package:flutter/material.dart';
import 'package:kintaikei_app/common/functions.dart';
import 'package:kintaikei_app/common/style.dart';
import 'package:kintaikei_app/providers/login.dart';
import 'package:kintaikei_app/screens/home.dart';
import 'package:kintaikei_app/widgets/custom_button.dart';
import 'package:kintaikei_app/widgets/custom_text_form_field.dart';
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
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Center(
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
                      letterSpacing: 12,
                    ),
                  ),
                  Text(
                    'スタッフ用アプリ',
                    style: TextStyle(fontSize: 16),
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
                      color: kBlackColor,
                      prefix: Icons.email,
                    ),
                    const SizedBox(height: 8),
                    CustomTextFormField(
                      controller: passwordController,
                      obscureText: obscureText,
                      textInputType: TextInputType.visiblePassword,
                      maxLines: 1,
                      label: 'パスワード',
                      color: kBlackColor,
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
                    CustomButton(
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
                        await loginProvider.reloadData();
                        if (!mounted) return;
                        pushReplacementScreen(
                          context,
                          const HomeScreen(),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
