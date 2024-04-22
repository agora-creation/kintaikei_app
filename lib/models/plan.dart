import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kintaikei_app/common/style.dart';

class PlanModel {
  String _id = '';
  String _companyId = '';
  String _companyName = '';
  String _groupId = '';
  String _groupName = '';
  String _userId = '';
  String _userName = '';
  String _subject = '';
  DateTime _startedAt = DateTime.now();
  DateTime _endedAt = DateTime.now();
  bool _allDay = false;
  Color _color = kBlueColor;
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
  String get subject => _subject;
  DateTime get startedAt => _startedAt;
  DateTime get endedAt => _endedAt;
  bool get allDay => _allDay;
  Color get color => _color;
  int get alertMinute => _alertMinute;
  DateTime get alertedAt => _alertedAt;
  DateTime get createdAt => _createdAt;

  PlanModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    Map<String, dynamic>? data = snapshot.data();
    if (data == null) return;
    _id = data['id'] ?? '';
    _companyId = data['companyId'] ?? '';
    _companyName = data['companyName'] ?? '';
    _groupId = data['groupId'] ?? '';
    _groupName = data['groupName'] ?? '';
    _userId = data['userId'] ?? '';
    _userName = data['userName'] ?? '';
    _subject = data['subject'] ?? '';
    _startedAt = data['startedAt'].toDate() ?? DateTime.now();
    _endedAt = data['endedAt'].toDate() ?? DateTime.now();
    _allDay = data['allDay'] ?? false;
    _color = Color(int.parse(data['color'], radix: 16));
    _alertMinute = data['alertMinute'] ?? 0;
    _alertedAt = data['alertedAt'].toDate() ?? DateTime.now();
    _createdAt = data['createdAt'].toDate() ?? DateTime.now();
  }
}
