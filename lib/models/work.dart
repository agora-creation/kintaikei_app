import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kintaikei_app/models/work_break.dart';

class WorkModel {
  String _id = '';
  String _companyId = '';
  String _groupId = '';
  String _userId = '';
  DateTime _startedAt = DateTime.now();
  DateTime _endedAt = DateTime.now();
  List<WorkBreakModel> workBreaks = [];
  DateTime _createdAt = DateTime.now();

  String get id => _id;
  String get companyId => _companyId;
  String get groupId => _groupId;
  String get userId => _userId;
  DateTime get startedAt => _startedAt;
  DateTime get endedAt => _endedAt;
  DateTime get createdAt => _createdAt;

  WorkModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    Map<String, dynamic>? data = snapshot.data();
    if (data == null) return;
    _id = data['id'] ?? '';
    _companyId = data['companyId'] ?? '';
    _groupId = data['groupId'] ?? '';
    _userId = data['userId'] ?? '';
    _startedAt = data['startedAt'].toDate() ?? DateTime.now();
    _endedAt = data['endedAt'].toDate() ?? DateTime.now();
    workBreaks = _convertWorkBreaks(data['workBreaks']);
    _createdAt = data['createdAt'].toDate() ?? DateTime.now();
  }

  List<WorkBreakModel> _convertWorkBreaks(List list) {
    List<WorkBreakModel> converted = [];
    for (Map data in list) {
      converted.add(WorkBreakModel.fromMap(data));
    }
    return converted;
  }
}
