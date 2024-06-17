import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kintaikei_app/common/functions.dart';
import 'package:kintaikei_app/models/company_group.dart';
import 'package:kintaikei_app/models/user.dart';
import 'package:kintaikei_app/models/work.dart';

class WorkService {
  String collection = 'work';
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

  Future<WorkModel?> selectToId({
    required String? id,
  }) async {
    WorkModel? ret;
    await firestore
        .collection(collection)
        .where('id', isEqualTo: id ?? 'error')
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        ret = WorkModel.fromSnapshot(value.docs.first);
      }
    });
    return ret;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>>? streamList({
    required CompanyGroupModel? group,
    required UserModel? user,
    required DateTime searchMonth,
  }) {
    DateTime monthS = DateTime(searchMonth.year, searchMonth.month, 1);
    DateTime monthE = DateTime(searchMonth.year, searchMonth.month + 1, 1).add(
      const Duration(days: -1),
    );
    Timestamp startAt = convertTimestamp(monthS, false);
    Timestamp endAt = convertTimestamp(monthE, true);
    if (group != null) {
      return FirebaseFirestore.instance
          .collection(collection)
          .where('companyId', isEqualTo: group.companyId)
          .where('groupId', isEqualTo: group.id)
          .orderBy('startedAt', descending: false)
          .startAt([startAt]).endAt([endAt]).snapshots();
    } else {
      return FirebaseFirestore.instance
          .collection(collection)
          .where('userId', isEqualTo: user?.id ?? 'error')
          .orderBy('startedAt', descending: false)
          .startAt([startAt]).endAt([endAt]).snapshots();
    }
  }

  List<WorkModel> convertList(
    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot,
  ) {
    List<WorkModel> ret = [];
    if (snapshot.hasData) {
      for (DocumentSnapshot<Map<String, dynamic>> doc in snapshot.data!.docs) {
        WorkModel work = WorkModel.fromSnapshot(doc);
        if (work.startedAt.millisecondsSinceEpoch !=
            work.endedAt.millisecondsSinceEpoch) {
          ret.add(work);
        }
      }
    }
    return ret;
  }
}
