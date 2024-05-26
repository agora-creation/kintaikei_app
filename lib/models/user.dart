import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kintaikei_app/common/functions.dart';

class UserModel {
  String _id = '';
  String _name = '';
  String _email = '';
  String _password = '';
  String _uid = '';
  String _token = '';
  String _lastWorkId = '';
  String _lastWorkBreakId = '';
  DateTime _createdAt = DateTime.now();

  String get id => _id;
  String get name => _name;
  String get email => _email;
  String get password => _password;
  String get uid => _uid;
  String get token => _token;
  String get lastWorkId => _lastWorkId;
  String get lastWorkBreakId => _lastWorkBreakId;
  DateTime get createdAt => _createdAt;

  UserModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    Map<String, dynamic>? data = snapshot.data();
    if (data == null) return;
    _id = data['id'] ?? '';
    _name = data['name'] ?? '';
    _email = data['email'] ?? '';
    _password = data['password'] ?? '';
    _uid = data['uid'] ?? '';
    _token = data['token'] ?? '';
    _lastWorkId = data['lastWorkId'] ?? '';
    _lastWorkBreakId = data['lastWorkBreakId'] ?? '';
    _createdAt = data['createdAt'].toDate() ?? DateTime.now();
  }

  UserModel.fromMap(Map<String, dynamic> data) {
    _id = data['id'] ?? '';
    _name = data['name'] ?? '';
    _email = data['email'] ?? '';
    _password = data['password'] ?? '';
    _uid = data['uid'] ?? '';
    _token = data['token'] ?? '';
    _lastWorkId = data['lastWorkId'] ?? '';
    _lastWorkBreakId = data['lastWorkBreakId'] ?? '';
    _createdAt = DateTime.parse(data['createdAt'] ?? '');
  }

  Map<String, dynamic> toMap() => {
        'id': _id,
        'name': _name,
        'email': _email,
        'password': _password,
        'uid': _uid,
        'token': _token,
        'lastWorkId': _lastWorkId,
        'lastWorkBreakId': _lastWorkBreakId,
        'createdAt': convertDateText('yyyy-MM-dd HH:mm', _createdAt),
      };

  int getWorkStatus() {
    //0は未出勤
    //1は出勤中
    //2は休憩中
    int ret = 0;
    if (_lastWorkId == '') {
      ret = 0;
    } else {
      if (_lastWorkBreakId == '') {
        ret = 1;
      } else {
        ret = 2;
      }
    }
    return ret;
  }
}
