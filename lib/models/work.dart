import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kintaikei_app/common/functions.dart';
import 'package:kintaikei_app/models/work_break.dart';

class WorkModel {
  String _id = '';
  String _companyId = '';
  String _companyName = '';
  String _groupId = '';
  String _groupName = '';
  String _userId = '';
  String _userName = '';
  DateTime startedAt = DateTime.now();
  DateTime endedAt = DateTime.now();
  List<WorkBreakModel> workBreaks = [];
  DateTime _createdAt = DateTime.now();

  String get id => _id;
  String get companyId => _companyId;
  String get companyName => _companyName;
  String get groupId => _groupId;
  String get groupName => _groupName;
  String get userId => _userId;
  String get userName => _userName;
  DateTime get createdAt => _createdAt;

  WorkModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    Map<String, dynamic>? data = snapshot.data();
    if (data == null) return;
    _id = data['id'] ?? '';
    _companyId = data['companyId'] ?? '';
    _companyName = data['companyName'] ?? '';
    _groupId = data['groupId'] ?? '';
    _groupName = data['groupName'] ?? '';
    _userId = data['userId'] ?? '';
    _userName = data['userName'] ?? '';
    startedAt = data['startedAt'].toDate() ?? DateTime.now();
    endedAt = data['endedAt'].toDate() ?? DateTime.now();
    workBreaks = _convertWorkBreaks(data['workBreaks'] ?? []);
    _createdAt = data['createdAt'].toDate() ?? DateTime.now();
  }

  List<WorkBreakModel> _convertWorkBreaks(List list) {
    List<WorkBreakModel> converted = [];
    for (Map data in list) {
      converted.add(WorkBreakModel.fromMap(data));
    }
    return converted;
  }

  String startedTime() {
    return convertDateText('HH:mm', startedAt);
  }

  String endedTime() {
    return convertDateText('HH:mm', endedAt);
  }

  String breakTime() {
    String ret = '00:00';
    if (workBreaks.isNotEmpty) {
      for (WorkBreakModel workBreak in workBreaks) {
        ret = addTime(ret, workBreak.totalTime());
      }
    }
    return ret;
  }

  String totalTime() {
    String ret = '00:00';
    String dateS = convertDateText('yyyy-MM-dd', startedAt);
    String timeS = '${startedTime()}:00.000';
    DateTime datetimeS = DateTime.parse('$dateS $timeS');
    String dateE = convertDateText('yyyy-MM-dd', endedAt);
    String timeE = '${endedTime()}:00.000';
    DateTime datetimeE = DateTime.parse('$dateE $timeE');
    //出勤時間と退勤時間の差を求める
    Duration diff = datetimeE.difference(datetimeS);
    String minutes = twoDigits(diff.inMinutes.remainder(60));
    ret = '${twoDigits(diff.inHours)}:$minutes';
    //勤務時間と休憩の合計時間の差を求める
    ret = subTime(ret, breakTime());
    return ret;
  }
}
