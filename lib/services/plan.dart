import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kintaikei_app/common/functions.dart';
import 'package:kintaikei_app/models/company_group.dart';
import 'package:kintaikei_app/models/plan.dart';
import 'package:kintaikei_app/models/user.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class PlanService {
  String collection = 'plan';
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  String id() {
    return firestore.collection(collection).doc().id;
  }

  void create(Map<String, dynamic> values) {
    firestore.collection(collection).doc(values['id']).set(values);
  }

  void update(Map<String, dynamic> values) {
    firestore.collection(collection).doc(values['id']).update(values);
  }

  void delete(Map<String, dynamic> values) {
    firestore.collection(collection).doc(values['id']).delete();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>>? streamList({
    required CompanyGroupModel? group,
    required UserModel? user,
  }) {
    if (group != null) {
      return FirebaseFirestore.instance
          .collection(collection)
          .where('companyId', isEqualTo: group.companyId)
          .where('groupId', isEqualTo: group.id)
          .orderBy('startedAt', descending: true)
          .snapshots();
    } else {
      return FirebaseFirestore.instance
          .collection(collection)
          .where('userId', isEqualTo: user?.id ?? 'error')
          .orderBy('startedAt', descending: true)
          .snapshots();
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>>? streamListNow({
    required CompanyGroupModel? group,
  }) {
    DateTime now = DateTime.now();
    Timestamp startAt = convertTimestamp(now, false);
    Timestamp endAt = convertTimestamp(now, true);
    return FirebaseFirestore.instance
        .collection(collection)
        .where('companyId', isEqualTo: group?.companyId)
        .where('groupId', isEqualTo: group?.id)
        .orderBy('startedAt', descending: false)
        .startAt([startAt]).endAt([endAt]).snapshots();
  }

  List<PlanModel> convertList(
    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot,
  ) {
    List<PlanModel> ret = [];
    if (snapshot.hasData) {
      for (DocumentSnapshot<Map<String, dynamic>> doc in snapshot.data!.docs) {
        ret.add(PlanModel.fromSnapshot(doc));
      }
    }
    return ret;
  }

  List<Appointment> convertListCalendar(
    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot, {
    bool shiftView = false,
  }) {
    List<Appointment> ret = [];
    if (snapshot.hasData) {
      for (DocumentSnapshot<Map<String, dynamic>> doc in snapshot.data!.docs) {
        PlanModel plan = PlanModel.fromSnapshot(doc);
        ret.add(Appointment(
          id: plan.id,
          resourceIds: [plan.userId],
          subject: plan.subject,
          startTime: plan.startedAt,
          endTime: plan.endedAt,
          isAllDay: plan.allDay,
          color: !shiftView ? plan.color : plan.color.withOpacity(0.2),
          notes: 'plan',
        ));
      }
    }
    return ret;
  }
}
