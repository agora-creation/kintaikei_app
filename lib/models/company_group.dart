import 'package:cloud_firestore/cloud_firestore.dart';

class CompanyGroupModel {
  String _id = '';
  String _companyId = '';
  String _name = '';
  String _loginId = '';
  String _password = '';
  DateTime _createdAt = DateTime.now();

  String get id => _id;
  String get companyId => _companyId;
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
    _name = data['name'] ?? '';
    _loginId = data['loginId'] ?? '';
    _password = data['password'] ?? '';
    _createdAt = data['createdAt'].toDate() ?? DateTime.now();
  }
}
