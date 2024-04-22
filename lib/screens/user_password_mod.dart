import 'package:flutter/material.dart';
import 'package:kintaikei_app/common/functions.dart';
import 'package:kintaikei_app/common/style.dart';
import 'package:kintaikei_app/providers/login.dart';
import 'package:kintaikei_app/widgets/custom_button.dart';
import 'package:kintaikei_app/widgets/custom_text_form_field.dart';

class UserPasswordModScreen extends StatefulWidget {
  final LoginProvider loginProvider;

  const UserPasswordModScreen({
    required this.loginProvider,
    super.key,
  });

  @override
  State<UserPasswordModScreen> createState() => _UserPasswordModScreenState();
}

class _UserPasswordModScreenState extends State<UserPasswordModScreen> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController newRePasswordController = TextEditingController();
  bool obscureText = true;
  bool newObscureText = true;
  bool newReObscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        backgroundColor: kWhiteColor,
        leading: IconButton(
          icon: const Icon(
            Icons.chevron_left,
            color: kBlackColor,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text('パスワードの変更'),
        shape: const Border(bottom: BorderSide(color: kGrey300Color)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CustomTextFormField(
              controller: passwordController,
              obscureText: obscureText,
              textInputType: TextInputType.visiblePassword,
              maxLines: 1,
              label: '現在のパスワード',
              color: kBlackColor,
              prefix: Icons.password,
              suffix: obscureText ? Icons.visibility_off : Icons.visibility,
              onTap: () {
                setState(() {
                  obscureText = !obscureText;
                });
              },
            ),
            const SizedBox(height: 8),
            CustomTextFormField(
              controller: newPasswordController,
              obscureText: newObscureText,
              textInputType: TextInputType.visiblePassword,
              maxLines: 1,
              label: '新しいパスワード',
              color: kBlackColor,
              prefix: Icons.password,
              suffix: newObscureText ? Icons.visibility_off : Icons.visibility,
              onTap: () {
                setState(() {
                  newObscureText = !newObscureText;
                });
              },
            ),
            const SizedBox(height: 8),
            CustomTextFormField(
              controller: newRePasswordController,
              obscureText: newReObscureText,
              textInputType: TextInputType.visiblePassword,
              maxLines: 1,
              label: '新しいパスワードの確認',
              color: kBlackColor,
              prefix: Icons.password,
              suffix:
                  newReObscureText ? Icons.visibility_off : Icons.visibility,
              onTap: () {
                setState(() {
                  newReObscureText = !newReObscureText;
                });
              },
            ),
            const SizedBox(height: 16),
            passwordController.text != '' &&
                    newPasswordController.text != '' &&
                    newPasswordController.text ==
                        newRePasswordController.text &&
                    passwordController.text != newPasswordController.text
                ? CustomButton(
                    label: '変更する',
                    labelColor: kWhiteColor,
                    backgroundColor: kBlueColor,
                    onPressed: () async {
                      String? error = await widget.loginProvider.updatePassword(
                        password: passwordController.text,
                        newPassword: newPasswordController.text,
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
                  )
                : const CustomButton(
                    label: '変更する',
                    labelColor: kWhiteColor,
                    backgroundColor: kGreyColor,
                  ),
          ],
        ),
      ),
    );
  }
}
