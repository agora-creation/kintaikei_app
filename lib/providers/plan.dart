import 'package:flutter/material.dart';
import 'package:kintaikei_app/models/user.dart';
import 'package:kintaikei_app/services/plan.dart';

class PlanProvider with ChangeNotifier {
  final PlanService _planService = PlanService();

  Future<String?> create({
    required UserModel? user,
    required String subject,
    required DateTime startedAt,
    required DateTime endedAt,
    required bool allDay,
    required Color color,
    required int alertMinute,
  }) async {
    String? error;
    if (user == null) return '予定の追加に失敗しました';
    if (subject == '') return '件名を入力してください';
    if (startedAt.millisecondsSinceEpoch > endedAt.millisecondsSinceEpoch) {
      return '日時を正しく選択してください';
    }
    try {
      String id = _planService.id();
      _planService.create({
        'id': id,
        'companyId ': '',
        'companyName': '',
        'groupId ': '',
        'groupName': '',
        'userId': user.id,
        'userName': user.name,
        'subject': subject,
        'startedAt': startedAt,
        'endedAt': endedAt,
        'allDay': allDay,
        'color': color.value.toRadixString(16),
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