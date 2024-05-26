import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kintaikei_app/common/functions.dart';
import 'package:kintaikei_app/common/style.dart';

class PlanShiftModel {
  String _id = '';
  String _companyId = '';
  String _companyName = '';
  String _groupId = '';
  String _groupName = '';
  String _userId = '';
  String _userName = '';
  DateTime _startedAt = DateTime.now();
  DateTime _endedAt = DateTime.now();
  bool _allDay = false;
  bool _repeat = false;
  String _repeatInterval = '';
  List<String> repeatWeeks = [];
  DateTime? _repeatUntil;
  int _alertMinute = 0;
  DateTime _alertedAt = DateTime.now();
  DateTime _createdAt = DateTime.now();

  String get id => _id;
  String get companyId => _companyId;
  String get companyName => _companyName;
  String get groupId => _groupId;
  String get groupName => _groupName;
  String get userId => _userId;
  String get userName => _userName;
  DateTime get startedAt => _startedAt;
  DateTime get endedAt => _endedAt;
  bool get allDay => _allDay;
  bool get repeat => _repeat;
  String get repeatInterval => _repeatInterval;
  DateTime? get repeatUntil => _repeatUntil;
  int get alertMinute => _alertMinute;
  DateTime get alertedAt => _alertedAt;
  DateTime get createdAt => _createdAt;

  PlanShiftModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    Map<String, dynamic>? data = snapshot.data();
    if (data == null) return;
    _id = data['id'] ?? '';
    _companyId = data['companyId'] ?? '';
    _companyName = data['companyName'] ?? '';
    _groupId = data['groupId'] ?? '';
    _groupName = data['groupName'] ?? '';
    _userId = data['userId'] ?? '';
    _userName = data['userName'] ?? '';
    _startedAt = data['startedAt'].toDate() ?? DateTime.now();
    _endedAt = data['endedAt'].toDate() ?? DateTime.now();
    _allDay = data['allDay'] ?? false;
    _repeat = data['repeat'] ?? false;
    _repeatInterval = data['repeatInterval'] ?? '';
    repeatWeeks = _convertRepeatWeeks(data['repeatWeeks'] ?? []);
    if (data['repeatUntil'] != null) {
      _repeatUntil = data['repeatUntil'].toDate();
    }
    _alertMinute = data['alertMinute'] ?? 0;
    _alertedAt = data['alertedAt'].toDate() ?? DateTime.now();
    _createdAt = data['createdAt'].toDate() ?? DateTime.now();
  }

  List<String> _convertRepeatWeeks(List list) {
    List<String> ret = [];
    for (dynamic id in list) {
      ret.add('$id');
    }
    return ret;
  }

  String? getRepeatRule() {
    String? ret;
    if (_repeat) {
      ret = '';
      if (_repeatInterval == kRepeatIntervals[0]) {
        ret = 'FREQ=DAILY;';
        ret += 'INTERVAL=1;';
      } else if (_repeatInterval == kRepeatIntervals[1]) {
        ret = 'FREQ=WEEKLY;';
        ret += 'INTERVAL=1;';
        if (repeatWeeks.isNotEmpty) {
          String byday = '';
          for (String week in repeatWeeks) {
            if (byday != '') byday += ',';
            byday += _ruleConvertWeek(week);
          }
          ret += 'BYDAY=$byday;';
        }
      } else if (_repeatInterval == kRepeatIntervals[2]) {
        ret = 'FREQ=MONTHLY;';
        ret += 'INTERVAL=1;';
      } else if (_repeatInterval == kRepeatIntervals[3]) {
        ret = 'FREQ=YEARLY;';
        ret += 'INTERVAL=1;';
      }
      if (_repeatUntil != null) {
        ret += 'UNTIL=${convertDateText('yyyyMMddTHHmmss', _repeatUntil)}Z;';
      }
    }
    return ret;
  }

  String _ruleConvertWeek(String week) {
    switch (week) {
      case '月':
        return 'MO';
      case '火':
        return 'TU';
      case '水':
        return 'WE';
      case '木':
        return 'TH';
      case '金':
        return 'FR';
      case '土':
        return 'SA';
      case '日':
        return 'SU';
      default:
        return '';
    }
  }

  String getRepeatText() {
    String ret = '';
    if (_repeat) {
      if (_repeatInterval == kRepeatIntervals[0]) {
        ret = '毎日';
      } else if (_repeatInterval == kRepeatIntervals[1]) {
        ret = '毎週';
        if (repeatWeeks.isNotEmpty) {
          String weeksText = '';
          for (String week in repeatWeeks) {
            if (weeksText != '') weeksText += ',';
            weeksText += week;
          }
          ret += '($weeksText)';
        }
      } else if (_repeatInterval == kRepeatIntervals[2]) {
        ret = '毎月';
      } else if (_repeatInterval == kRepeatIntervals[3]) {
        ret = '毎年';
      }
    }
    return ret;
  }
}
