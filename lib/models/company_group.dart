import 'package:cloud_firestore/cloud_firestore.dart';

class CompanyGroupModel {
  String _id = '';
  String _companyId = '';
  String _companyName = '';
  int _index = 0;
  String _name = '';
  String _loginId = '';
  String _password = '';
  List<String> userIds = [];
  DateTime _createdAt = DateTime.now();

  String get id => _id;
  String get companyId => _companyId;
  String get companyName => _companyName;
  int get index => _index;
  String get name => _name;
  String get loginId => _loginId;
  String get password => _password;
  DateTime get createdAt => _createdAt;

  CompanyGroupModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    Map<String, dynamic>? data = snapshot.data();
    if (data == null) return;
    _id = data['id'] ?? '';
    _companyId = data['companyId'] ?? '';
    _companyName = data['companyName'] ?? '';
    _index = data['index'] ?? 0;
    _name = data['name'] ?? '';
    _loginId = data['loginId'] ?? '';
    _password = data['password'] ?? '';
    userIds = _convertUserIds(data['userIds']);
    _createdAt = data['createdAt'].toDate() ?? DateTime.now();
  }

  List<String> _convertUserIds(List list) {
    List<String> ret = [];
    for (dynamic id in list) {
      ret.add('$id');
    }
    return ret;
  }
}
