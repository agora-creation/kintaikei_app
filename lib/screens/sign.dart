import 'package:flutter/material.dart';
import 'package:kintaikei_app/common/style.dart';
import 'package:signature/signature.dart';

class SignScreen extends StatefulWidget {
  const SignScreen({super.key});

  @override
  State<SignScreen> createState() => _SignScreenState();
}

class _SignScreenState extends State<SignScreen> {
  SignatureController controller = SignatureController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('手書き'),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
          ),
        ],
      ),
      body: Signature(
        controller: controller,
        backgroundColor: kWhiteColor,
      ),
    );
  }
}
