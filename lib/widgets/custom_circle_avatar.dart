import 'package:flutter/material.dart';
import 'package:kintaikei_app/common/style.dart';
import 'package:kintaikei_app/models/user.dart';

class CustomCircleAvatar extends StatelessWidget {
  final UserModel? user;
  final Function()? onTap;

  const CustomCircleAvatar({
    this.user,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    String userName = user?.name ?? '';
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        backgroundColor: kGrey300Color,
        child: Text(
          userName.substring(0, 1),
          style: const TextStyle(color: kBlackColor),
        ),
      ),
    );
  }
}
