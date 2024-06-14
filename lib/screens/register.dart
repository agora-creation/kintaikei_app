import 'package:flutter/material.dart';
import 'package:kintaikei_app/common/functions.dart';
import 'package:kintaikei_app/common/style.dart';
import 'package:kintaikei_app/providers/home.dart';
import 'package:kintaikei_app/providers/login.dart';
import 'package:kintaikei_app/screens/home.dart';
import 'package:kintaikei_app/screens/login.dart';
import 'package:kintaikei_app/widgets/custom_button.dart';
import 'package:kintaikei_app/widgets/custom_text_form_field.dart';
import 'package:kintaikei_app/widgets/link_text.dart';
import 'package:page_transition/page_transition.dart';

class RegisterScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;

  const RegisterScreen({
    required this.loginProvider,
    required this.homeProvider,
    super.key,
  });

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
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
                      controller: nameController,
                      textInputType: TextInputType.name,
                      maxLines: 1,
                      label: '名前',
                      color: kBlackColor,
                      prefix: Icons.person,
                    ),
                    const SizedBox(height: 8),
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
                      label: 'アカウント登録',
                      labelColor: kWhiteColor,
                      backgroundColor: kBlueColor,
                      onPressed: () async {
                        String? error = await widget.loginProvider.register(
                          name: nameController.text,
                          email: emailController.text,
                          password: passwordController.text,
                        );
                        if (error != null) {
                          if (!mounted) return;
                          showMessage(context, error, false);
                          return;
                        }
                        await widget.loginProvider.reloadData();
                        await widget.homeProvider.initGroup(
                          widget.loginProvider.groups,
                        );
                        if (!mounted) return;
                        Navigator.pushReplacement(
                          context,
                          PageTransition(
                            type: PageTransitionType.topToBottom,
                            child: HomeScreen(
                              loginProvider: widget.loginProvider,
                              homeProvider: widget.homeProvider,
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    LinkText(
                      label: 'ログイン',
                      color: kBlueColor,
                      onTap: () => Navigator.pushReplacement(
                        context,
                        PageTransition(
                          type: PageTransitionType.leftToRight,
                          child: LoginScreen(
                            loginProvider: widget.loginProvider,
                            homeProvider: widget.homeProvider,
                          ),
                        ),
                      ),
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
