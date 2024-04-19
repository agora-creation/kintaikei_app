import 'package:flutter/material.dart';
import 'package:kintaikei_app/models/company_group.dart';
import 'package:kintaikei_app/models/user.dart';
import 'package:kintaikei_app/services/company_group.dart';

class CompanyProvider with ChangeNotifier {
  final CompanyGroupService _groupService = CompanyGroupService();

  Future<String?> updateExitUser({
    required CompanyGroupModel? group,
    required UserModel? user,
  }) async {
    String? error;
    if (group == null) return '退職に失敗しました';
    if (user == null) return '退職に失敗しました';
    try {
      List<String> userIds = group.userIds;
      if (userIds.contains(user.id)) {
        userIds.remove(user.id);
      }
      _groupService.update({
        'id': group.id,
        'userIds': userIds,
      });
    } catch (e) {
      error = '退職に失敗しました';
    }
    return error;
  }
}
