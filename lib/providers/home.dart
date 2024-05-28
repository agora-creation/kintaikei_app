import 'package:flutter/material.dart';
import 'package:kintaikei_app/models/company_group.dart';
import 'package:kintaikei_app/services/company_group.dart';
import 'package:kintaikei_app/services/local_db.dart';

class HomeProvider with ChangeNotifier {
  final LocalDBService _localDBService = LocalDBService();
  final CompanyGroupService _groupService = CompanyGroupService();
  CompanyGroupModel? currentGroup;

  Future initGroup(List<CompanyGroupModel> groups) async {
    if (groups.isNotEmpty) {
      currentGroup = groups.first;
      String currentGroupId = groups.first.id;
      await _localDBService.setString('currentGroupId', currentGroupId);
    }
    notifyListeners();
  }

  Future changeGroup(CompanyGroupModel? value) async {
    currentGroup = value;
    if (value != null) {
      String currentGroupId = value.id;
      await _localDBService.setString('currentGroupId', currentGroupId);
    } else {
      await _localDBService.remove('currentGroupId');
    }
    notifyListeners();
  }

  Future reloadGroup() async {
    String? groupId = await _localDBService.getString('currentGroupId');
    if (groupId != null) {
      currentGroup = await _groupService.selectToId(id: groupId);
    }
    notifyListeners();
  }
}
