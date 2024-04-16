import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String _id = '';
  String _name = '';
  String _phoneNumber = '';
  String _uid = '';
  String _token = '';
  DateTime _createdAt = DateTime.now();

  String get id => _id;
  String get name => _name;
  String get phoneNumber => _phoneNumber;
  String get uid => _uid;
  String get token => _token;
  DateTime get createdAt => _createdAt;

  UserModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    Map<String, dynamic>? data = snapshot.data();
    if (data == null) return;
    _id = data['id'] ?? '';
    _name = data['name'] ?? '';
    _phoneNumber = data['phoneNumber'] ?? '';
    _uid = data['uid'] ?? '';
    _token = data['token'] ?? '';
    _createdAt = data['createdAt'].toDate() ?? DateTime.now();
  }
}
