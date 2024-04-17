import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kintaikei_app/models/user.dart';

class UserService {
  String collection = 'user';
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

  Future<bool> emailCheck(String email) async {
    bool ret = false;
    await firestore
        .collection(collection)
        .where('email', isEqualTo: email)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        ret = true;
      }
    });
    return ret;
  }

  Future<UserModel?> selectToUid({
    required String? uid,
  }) async {
    UserModel? ret;
    await firestore
        .collection(collection)
        .where('uid', isEqualTo: uid ?? 'error')
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        ret = UserModel.fromSnapshot(value.docs.first);
      }
    });
    return ret;
  }

  Future<UserModel?> selectToEmailPassword({
    required String? email,
    required String? password,
  }) async {
    UserModel? ret;
    await firestore
        .collection(collection)
        .where('email', isEqualTo: email ?? 'error')
        .where('password', isEqualTo: password ?? 'error')
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        ret = UserModel.fromSnapshot(value.docs.first);
      }
    });
    return ret;
  }
}
