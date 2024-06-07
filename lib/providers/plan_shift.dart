import 'package:flutter/material.dart';
import 'package:kintaikei_app/models/company_group.dart';
import 'package:kintaikei_app/models/user.dart';
import 'package:kintaikei_app/services/plan_shift.dart';

class PlanShiftProvider with ChangeNotifier {
  final PlanShiftService _planShiftService = PlanShiftService();

  Future<String?> create({
    required CompanyGroupModel? group,
    required List<UserModel> users,
    required DateTime startedAt,
    required DateTime endedAt,
    required bool allDay,
    required bool repeat,
    required String repeatInterval,
    required List<String> repeatWeeks,
    required int alertMinute,
  }) async {
    String? error;
    if (users.isEmpty) return '勤務予定の追加に失敗しました';
    if (startedAt.millisecondsSinceEpoch > endedAt.millisecondsSinceEpoch) {
      return '日時を正しく選択してください';
    }
    try {
      for (UserModel user in users) {
        String id = _planShiftService.id();
        _planShiftService.create({
          'id': id,
          'companyId': group?.companyId ?? '',
          'companyName': group?.companyName ?? '',
          'groupId': group?.id ?? '',
          'groupName': group?.name ?? '',
          'userId': user.id,
          'userName': user.name,
          'startedAt': startedAt,
          'endedAt': endedAt,
          'allDay': allDay,
          'repeat': repeat,
          'repeatInterval': repeatInterval,
          'repeatWeeks': repeatWeeks,
          'repeatUntil': null,
          'alertMinute': alertMinute,
          'alertedAt': startedAt.subtract(Duration(minutes: alertMinute)),
          'createdAt': DateTime.now(),
        });
      }
    } catch (e) {
      error = '勤務予定の追加に失敗しました';
    }
    return error;
  }
}
