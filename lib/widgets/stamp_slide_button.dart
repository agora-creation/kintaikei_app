import 'package:flutter/material.dart';
import 'package:kintaikei_app/common/style.dart';
import 'package:slide_to_act/slide_to_act.dart';

class StampSlideButton extends StatelessWidget {
  final GlobalKey<SlideActionState> slideKey;
  final String label;
  final Color backgroundColor;
  final bool reversed;
  final Future<dynamic>? Function()? onSubmit;

  const StampSlideButton({
    required this.slideKey,
    required this.label,
    required this.backgroundColor,
    this.reversed = false,
    this.onSubmit,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SlideAction(
      key: slideKey,
      sliderButtonIconSize: 24,
      sliderButtonIconPadding: 16,
      height: 70,
      text: label,
      textColor: kWhiteColor,
      textStyle: const TextStyle(
        color: kWhiteColor,
        fontSize: 24,
        fontWeight: FontWeight.bold,
        fontFamily: 'SourceHanSansJP-Bold',
      ),
      innerColor: kWhiteColor,
      outerColor: backgroundColor,
      elevation: 0,
      onSubmit: onSubmit,
      reversed: reversed,
    );
  }
}
