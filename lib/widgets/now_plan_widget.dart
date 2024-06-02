import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kintaikei_app/common/style.dart';
import 'package:kintaikei_app/models/plan.dart';
import 'package:kintaikei_app/providers/home.dart';
import 'package:kintaikei_app/providers/login.dart';
import 'package:kintaikei_app/services/plan.dart';
import 'package:kintaikei_app/widgets/now_plan_list.dart';

class NowPlanWidget extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;

  const NowPlanWidget({
    required this.loginProvider,
    required this.homeProvider,
    super.key,
  });

  @override
  State<NowPlanWidget> createState() => _NowPlanWidgetState();
}

class _NowPlanWidgetState extends State<NowPlanWidget> {
  PlanService planService = PlanService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: planService.streamListNow(
        group: widget.homeProvider.currentGroup,
      ),
      builder: (context, snapshot) {
        List<PlanModel> plans = planService.convertList(snapshot);
        if (plans.isEmpty) return Container();
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
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: ListView.builder(
                    itemCount: plans.length,
                    itemBuilder: (context, index) {
                      PlanModel plan = plans[index];
                      return NowPlanList(plan: plan);
                    },
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
