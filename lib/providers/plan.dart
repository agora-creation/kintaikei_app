import 'package:flutter/material.dart';
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
    required Color color,
    required int alertMinute,
  }) async {
    String? error;
    if (subject == '') return '件名を入力してください';
    if (startedAt.millisecondsSinceEpoch > endedAt.millisecondsSinceEpoch) {
      return '日時を正しく選択してください';
    }
    try {
      String id = _planService.id();
      String companyId = '';
      String companyName = '';
      String groupId = '';
      String groupName = '';
      String userId = '';
      String userName = '';
      if (group != null) {
        companyId = group.companyId;
        companyName = group.companyName;
        groupId = group.id;
        groupName = group.name;
      } else {
        userId = user?.id ?? '';
        userName = user?.name ?? '';
      }
      _planService.create({
        'id': id,
        'companyId ': companyId,
        'companyName': companyName,
        'groupId ': groupId,
        'groupName': groupName,
        'userId': userId,
        'userName': userName,
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

  Future<String?> update({
    required String id,
    required String subject,
    required DateTime startedAt,
    required DateTime endedAt,
    required bool allDay,
    required Color color,
    required int alertMinute,
  }) async {
    String? error;
    if (id == '') return '予定の編集に失敗しました';
    if (subject == '') return '件名を入力してください';
    if (startedAt.millisecondsSinceEpoch > endedAt.millisecondsSinceEpoch) {
      return '日時を正しく選択してください';
    }
    try {
      _planService.update({
        'id': id,
        'subject': subject,
        'startedAt': startedAt,
        'endedAt': endedAt,
        'allDay': allDay,
        'color': color.value.toRadixString(16),
        'alertMinute': alertMinute,
        'alertedAt': startedAt.subtract(Duration(minutes: alertMinute)),
      });
    } catch (e) {
      error = '予定の編集に失敗しました';
    }
    return error;
  }

  Future<String?> delete({
    required String id,
  }) async {
    String? error;
    if (id == '') return '予定の削除に失敗しました';
    try {
      _planService.delete({
        'id': id,
      });
    } catch (e) {
      error = '予定の削除に失敗しました';
    }
    return error;
  }
}
