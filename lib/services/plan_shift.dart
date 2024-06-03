import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kintaikei_app/common/functions.dart';
import 'package:kintaikei_app/common/style.dart';
import 'package:kintaikei_app/models/company_group.dart';
import 'package:kintaikei_app/models/plan_shift.dart';
import 'package:kintaikei_app/models/user.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class PlanShiftService {
  String collection = 'planShift';
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

  List<Appointment> convertList(
    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot,
  ) {
    List<Appointment> ret = [];
    if (snapshot.hasData) {
      for (DocumentSnapshot<Map<String, dynamic>> doc in snapshot.data!.docs) {
        PlanShiftModel planShift = PlanShiftModel.fromSnapshot(doc);
        String startedAtText = convertDateText('HH:mm', planShift.startedAt);
        String endedAtText = convertDateText('HH:mm', planShift.endedAt);
        ret.add(Appointment(
          id: planShift.id,
          resourceIds: [planShift.userId],
          subject: '勤務予定($startedAtText～$endedAtText)',
          startTime: planShift.startedAt,
          endTime: planShift.endedAt,
          isAllDay: planShift.allDay,
          color: kBlueGreyColor,
          notes: 'planShift',
          recurrenceRule: planShift.getRepeatRule(),
        ));
      }
    }
    return ret;
  }
}
