import 'package:flutter/material.dart';
import 'package:kintaikei_app/models/company_group.dart';
import 'package:kintaikei_app/services/local_db.dart';

class HomeProvider with ChangeNotifier {
  final LocalDBService _localDBService = LocalDBService();
  CompanyGroupModel? currentGroup;

  Future initGroup(List<CompanyGroupModel> groups) async {
    String? groupId = await _localDBService.getString('groupId');
    if (groupId != null) {
      CompanyGroupModel? group = groups.singleWhere((e) => e.id == groupId);
      currentGroup = group;
    }
    notifyListeners();
  }

  void changeGroup(CompanyGroupModel? value) async {
    currentGroup = value;
    if (value != null) {
      await _localDBService.setString('groupId', value.id);
    } else {
      await _localDBService.remove('groupId');
    }
    notifyListeners();
  }
}
