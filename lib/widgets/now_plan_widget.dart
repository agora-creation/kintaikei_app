import 'package:flutter/material.dart';
import 'package:kintaikei_app/common/style.dart';
import 'package:kintaikei_app/widgets/plan_list.dart';

class NowPlanWidget extends StatelessWidget {
  const NowPlanWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '今日の予定',
          style: TextStyle(
            color: kGrey600Color,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 2),
        SizedBox(
          height: 150,
          child: ShaderMask(
            shaderCallback: (Rect rect) {
              return const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  kMainColor,
                  Colors.transparent,
                  Colors.transparent,
                  kMainColor,
                ],
                stops: [0.0, 0.1, 0.9, 1.0],
              ).createShader(rect);
            },
            blendMode: BlendMode.dstOut,
            child: ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) {
                return const PlanList();
              },
            ),
          ),
        ),
      ],
    );
  }
}
