import 'package:flutter/material.dart';
import 'package:kintaikei_app/common/style.dart';
import 'package:kintaikei_app/models/company_group.dart';
import 'package:kintaikei_app/models/user.dart';
import 'package:kintaikei_app/services/plan.dart';

class PlanProvider with ChangeNotifier {
  final PlanService _planService = PlanService();

  Future<String?> create({
    required CompanyGroupModel? group,
    required UserModel? user,
    required String subject,
    required DateTime startedAt,
    required DateTime endedAt,
    required bool allDay,
    required int alertMinute,
  }) async {
    String? error;
    if (group == null) return '予定の追加に失敗しました';
    if (user == null) return '予定の追加に失敗しました';
    if (subject == '') return '件名を入力してください';
    if (startedAt.millisecondsSinceEpoch > endedAt.millisecondsSinceEpoch) {
      return '日時を正しく選択してください';
    }
    try {
      String id = _planService.id();
      _planService.create({
        'id': id,
        'companyId ': group.companyId,
        'companyName': group.companyName,
        'groupId ': group.id,
        'groupName': group.name,
        'userId': user.id,
        'userName': user.name,
        'color': kBlueColor.value.toRadixString(16),
        'subject': subject,
        'startedAt': startedAt,
        'endedAt': endedAt,
        'allDay': allDay,
        'alertMinute': alertMinute,
        'alertedAt': startedAt.subtract(Duration(minutes: alertMinute)),
        'createdAt': DateTime.now(),
      });
    } catch (e) {
      error = '予定の追加に失敗しました';
    }
    return error;
  }
}
