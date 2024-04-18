import 'package:flutter/material.dart';
import 'package:kintaikei_app/models/company_group.dart';
import 'package:kintaikei_app/models/user.dart';
import 'package:kintaikei_app/services/user.dart';
import 'package:kintaikei_app/services/work.dart';

class WorkProvider with ChangeNotifier {
  final WorkService _workService = WorkService();
  final UserService _userService = UserService();

  Future<String?> start({
    required CompanyGroupModel? group,
    required UserModel? user,
  }) async {
    String? error;
    try {
      String id = _workService.id();
      List<Map> workBreaks = [];
      _workService.create({
        'id': id,
        'companyId': group?.companyId,
        'groupId': group?.id,
        'userId': user?.id,
        'startedAt': DateTime.now(),
        'endedAt': DateTime.now(),
        'workBreaks': workBreaks,
        'createdAt': DateTime.now(),
      });
      _userService.update({
        'id': user?.id,
        'lastWorkId': id,
      });
    } catch (e) {
      error = '出勤に失敗しました';
    }
    return error;
  }
}
