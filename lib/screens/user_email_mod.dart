import 'package:flutter/material.dart';
import 'package:kintaikei_app/common/functions.dart';
import 'package:kintaikei_app/common/style.dart';
import 'package:kintaikei_app/providers/login.dart';
import 'package:kintaikei_app/widgets/custom_button.dart';
import 'package:kintaikei_app/widgets/custom_text_form_field.dart';

class UserEmailModScreen extends StatefulWidget {
  final LoginProvider loginProvider;

  const UserEmailModScreen({
    required this.loginProvider,
    super.key,
  });

  @override
  State<UserEmailModScreen> createState() => _UserEmailModScreenState();
}

class _UserEmailModScreenState extends State<UserEmailModScreen> {
  TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    emailController.text = widget.loginProvider.user?.email ?? '';
    super.initState();
  }

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
        title: const Text('メールアドレスの変更'),
        shape: const Border(bottom: BorderSide(color: kGrey300Color)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
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
            const SizedBox(height: 16),
            emailController.text != ''
                ? CustomButton(
                    label: '変更する',
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
