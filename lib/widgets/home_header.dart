import 'package:flutter/material.dart';
import 'package:kintaikei_app/models/user.dart';

class HomeHeader extends StatelessWidget {
  final UserModel? user;
  final Function()? userOnTap;
  final List<Widget> actions;

  const HomeHeader({
    required this.user,
    required this.userOnTap,
    required this.actions,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: userOnTap,
            child: Row(
              children: [
                const SizedBox(width: 8),
                Text(
                  user?.name ?? '',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'SourceHanSansJP-Bold',
                  ),
                ),
                const SizedBox(width: 2),
                const Icon(Icons.keyboard_arrow_down),
              ],
            ),
          ),
          Row(children: actions),
        ],
      ),
    );
  }
}
