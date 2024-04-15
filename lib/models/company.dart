import 'package:cloud_firestore/cloud_firestore.dart';

class CompanyModel {
  String _id = '';
  String _name = '';
  String _loginId = '';
  String _password = '';
  DateTime _createdAt = DateTime.now();

  String get id => _id;
  String get name => _name;
  String get loginId => _loginId;
  String get password => _password;
  DateTime get createdAt => _createdAt;

  CompanyModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    Map<String, dynamic>? data = snapshot.data();
    if (data == null) return;
    _id = data['id'] ?? '';
    _name = data['name'] ?? '';
    _loginId = data['loginId'] ?? '';
    _password = data['password'] ?? '';
    _createdAt = data['createdAt'].toDate() ?? DateTime.now();
  }
}
