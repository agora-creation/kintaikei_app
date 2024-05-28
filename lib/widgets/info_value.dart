import 'package:flutter/material.dart';
import 'package:kintaikei_app/common/style.dart';

class InfoValue extends StatelessWidget {
  final String value;
  final IconData? icon;
  final Function()? onTap;

  const InfoValue(
    this.value, {
    this.icon,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 10,
        ),
        decoration: BoxDecoration(
          color: kGrey300Color,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              value,
              style: const TextStyle(fontSize: 20),
            ),
            icon != null
                ? Icon(
                    icon,
                    color: kGrey600Color,
                    size: 20,
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
