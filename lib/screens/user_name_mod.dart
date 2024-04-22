import 'package:flutter/material.dart';
import 'package:kintaikei_app/common/functions.dart';
import 'package:kintaikei_app/common/style.dart';
import 'package:kintaikei_app/providers/login.dart';
import 'package:kintaikei_app/widgets/custom_button.dart';
import 'package:kintaikei_app/widgets/custom_text_form_field.dart';

class UserNameModScreen extends StatefulWidget {
  final LoginProvider loginProvider;

  const UserNameModScreen({
    required this.loginProvider,
    super.key,
  });

  @override
  State<UserNameModScreen> createState() => _UserNameModScreenState();
}

class _UserNameModScreenState extends State<UserNameModScreen> {
  TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    nameController.text = widget.loginProvider.user?.name ?? '';
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
        title: const Text('名前の変更'),
        shape: const Border(bottom: BorderSide(color: kGrey300Color)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
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
            const SizedBox(height: 16),
            nameController.text != ''
                ? CustomButton(
                    label: '変更する',
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
