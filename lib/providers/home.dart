import 'package:flutter/material.dart';
import 'package:kintaikei_app/models/company_group.dart';

class HomeProvider with ChangeNotifier {
  CompanyGroupModel? currentGroup;

  void changeGroup(CompanyGroupModel? value) {
    currentGroup = value;
    notifyListeners();
  }
}
