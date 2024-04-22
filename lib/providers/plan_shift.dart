import 'package:flutter/material.dart';
import 'package:kintaikei_app/models/company_group.dart';
import 'package:kintaikei_app/models/user.dart';
import 'package:kintaikei_app/services/plan_shift.dart';

class PlanShiftProvider with ChangeNotifier {
  final PlanShiftService _planShiftService = PlanShiftService();

  Future<String?> create({
    required CompanyGroupModel? group,
    required UserModel? user,
    required DateTime startedAt,
    required DateTime endedAt,
    required bool allDay,
    required int alertMinute,
  }) async {
    String? error;
    if (group == null) return 'シフトの追加に失敗しました';
    if (user == null) return 'シフトの追加に失敗しました';
    if (startedAt.millisecondsSinceEpoch > endedAt.millisecondsSinceEpoch) {
      return '日時を正しく選択してください';
    }
    try {
      String id = _planShiftService.id();
      _planShiftService.create({
        'id': id,
        'companyId ': group.companyId,
        'companyName': group.companyName,
        'groupId ': group.id,
        'groupName': group.name,
        'userId': user.id,
        'userName': user.name,
        'startedAt': startedAt,
        'endedAt': endedAt,
        'allDay': allDay,
        'repeat': false,
        'repeatInterval': '',
        'repeatEvery': 0,
        'repeatWeeks': [],
        'alertMinute': alertMinute,
        'alertedAt': startedAt.subtract(Duration(minutes: alertMinute)),
        'createdAt': DateTime.now(),
      });
    } catch (e) {
      error = 'シフトの追加に失敗しました';
    }
    return error;
  }
}
