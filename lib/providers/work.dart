import 'package:flutter/material.dart';
import 'package:kintaikei_app/common/functions.dart';
import 'package:kintaikei_app/models/company_group.dart';
import 'package:kintaikei_app/models/user.dart';
import 'package:kintaikei_app/models/work.dart';
import 'package:kintaikei_app/models/work_break.dart';
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
    if (user == null) return '出勤時間の打刻に失敗しました';
    try {
      String id = _workService.id();
      List<Map> workBreaks = [];
      _workService.create({
        'id': id,
        'companyId': group?.companyId ?? '',
        'companyName': group?.companyName ?? '',
        'groupId': group?.id ?? '',
        'groupName': group?.name ?? '',
        'userId': user.id,
        'userName': user.name,
        'startedAt': DateTime.now(),
        'endedAt': DateTime.now(),
        'workBreaks': workBreaks,
        'createdAt': DateTime.now(),
      });
      _userService.update({
        'id': user.id,
        'lastWorkId': id,
        'lastWorkBreakId': '',
      });
    } catch (e) {
      error = '出勤時間の打刻に失敗しました';
    }
    return error;
  }

  Future<String?> stop({
    required WorkModel? work,
  }) async {
    String? error;
    if (work == null) return '退勤時間の打刻に失敗しました';
    try {
      List<Map> workBreaks = [];
      for (WorkBreakModel workBreak in work.workBreaks) {
        workBreaks.add(workBreak.toMap());
      }
      _workService.update({
        'id': work.id,
        'endedAt': DateTime.now(),
        'workBreaks': workBreaks,
      });
      _userService.update({
        'id': work.userId,
        'lastWorkId': '',
        'lastWorkBreakId': '',
      });
    } catch (e) {
      error = '退勤時間の打刻に失敗しました';
    }
    return error;
  }

  Future<String?> breakStart({
    required WorkModel? work,
  }) async {
    String? error;
    if (work == null) return '休憩時間の打刻に失敗しました';
    try {
      List<Map> workBreaks = [];
      for (WorkBreakModel workBreak in work.workBreaks) {
        workBreaks.add(workBreak.toMap());
      }
      String workBreakId = generatePassword(16);
      workBreaks.add({
        'id': workBreakId,
        'startedAt': DateTime.now(),
        'endedAt': DateTime.now(),
      });
      _workService.update({
        'id': work.id,
        'workBreaks': workBreaks,
      });
      _userService.update({
        'id': work.userId,
        'lastWorkId': work.id,
        'lastWorkBreakId': workBreakId,
      });
    } catch (e) {
      error = '休憩時間の打刻に失敗しました';
    }
    return error;
  }

  Future<String?> breakStop({
    required WorkModel? work,
    required String? workBreakId,
  }) async {
    String? error;
    if (work == null) return '休憩時間の打刻に失敗しました';
    if (workBreakId == null) return '休憩時間の打刻に失敗しました';
    try {
      List<Map> workBreaks = [];
      for (WorkBreakModel workBreak in work.workBreaks) {
        if (workBreak.id == workBreakId) {
          workBreak.endedAt = DateTime.now();
        }
        workBreaks.add(workBreak.toMap());
      }
      _workService.update({
        'id': work.id,
        'workBreaks': workBreaks,
      });
      _userService.update({
        'id': work.userId,
        'lastWorkId': work.id,
        'lastWorkBreakId': '',
      });
    } catch (e) {
      error = '休憩時間の打刻に失敗しました';
    }
    return error;
  }

  Future<String?> update({
    required WorkModel? work,
  }) async {
    String? error;
    if (work == null) return '打刻情報の編集に失敗しました';
    try {
      List<Map> workBreaks = [];
      for (WorkBreakModel workBreak in work.workBreaks) {
        workBreaks.add(workBreak.toMap());
      }
      _workService.update({
        'id': work.id,
        'startedAt': work.startedAt,
        'endedAt': work.endedAt,
        'workBreaks': workBreaks,
      });
    } catch (e) {
      error = '打刻情報の編集に失敗しました';
    }
    return error;
  }

  Future<String?> delete({
    required WorkModel? work,
  }) async {
    String? error;
    if (work == null) return '打刻情報の削除に失敗しました';
    try {
      _workService.delete({
        'id': work.id,
      });
    } catch (e) {
      error = '打刻情報の削除に失敗しました';
    }
    return error;
  }
}
