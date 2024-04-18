import 'package:flutter/material.dart';
import 'package:kintaikei_app/models/user.dart';
import 'package:kintaikei_app/services/company.dart';
import 'package:kintaikei_app/services/company_group.dart';

class CompanyProvider with ChangeNotifier {
  final CompanyService _companyService = CompanyService();
  final CompanyGroupService _groupService = CompanyGroupService();

  Future<String?> create({
    required UserModel? user,
    required String name,
  }) async {
    String? error;
    try {
      String companyId = _companyService.id();
      _companyService.create({
        'id': companyId,
        'name': name,
        'loginId': '',
        'password': '',
        'createdAt': DateTime.now(),
      });
      String groupId = _groupService.id();
      _groupService.create({
        'id': groupId,
        'companyId': companyId,
        'companyName': name,
        'name': '本部',
        'loginId': '',
        'password': '',
        'userIds': [user?.id],
        'createdAt': DateTime.now(),
      });
    } catch (e) {
      error = '会社の追加に失敗しました';
    }
    return error;
  }
}
