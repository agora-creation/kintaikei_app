import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kintaikei_app/models/company_group.dart';

class CompanyGroupService {
  String collection = 'companyGroup';
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

  Future<CompanyGroupModel?> selectToId({
    required String? id,
  }) async {
    CompanyGroupModel? ret;
    await firestore
        .collection(collection)
        .where('id', isEqualTo: id ?? 'error')
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        ret = CompanyGroupModel.fromSnapshot(value.docs.first);
      }
    });
    return ret;
  }

  Future<List<CompanyGroupModel>> selectList({
    required String userId,
  }) async {
    List<CompanyGroupModel> ret = [];
    await firestore
        .collection(collection)
        .where('userIds', arrayContains: userId)
        .get()
        .then((value) {
      for (DocumentSnapshot<Map<String, dynamic>> map in value.docs) {
        ret.add(CompanyGroupModel.fromSnapshot(map));
      }
    });
    return ret;
  }
}
