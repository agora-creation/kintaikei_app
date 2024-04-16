import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kintaikei_app/models/user.dart';
import 'package:kintaikei_app/services/ldb.dart';
import 'package:kintaikei_app/services/user.dart';

enum AuthStatus {
  authenticated,
  uninitialized,
  authenticating,
  unauthenticated,
}

class LoginProvider with ChangeNotifier {
  AuthStatus _status = AuthStatus.uninitialized;
  AuthStatus get status => _status;
  FirebaseAuth? _auth;
  User? _authUser;
  User? get authUser => _authUser;

  final LDBService _ldbService = LDBService();
  final UserService _userService = UserService();
  UserModel? _user;
  UserModel? get user => _user;

  LoginProvider.initialize() : _auth = FirebaseAuth.instance {
    _auth?.authStateChanges().listen(_onStateChanged);
  }

  Future<String?> verifyPhoneNumber({
    required String phoneNumber,
  }) async {
    String? error;
    if (phoneNumber == '') return '電話番号を入力してください';
    try {
      await _auth?.verifyPhoneNumber(
        phoneNumber: '+81$phoneNumber',
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {
          if (e.code == 'invalid-phone-number') {
            error = '電話番号が正しくありません';
          }
        },
        codeSent: (String verificationId, int? resendToken) async {
          String smsCode = '';
          //認証ダイアログ
          final credential = PhoneAuthProvider.credential(
            verificationId: verificationId,
            smsCode: smsCode,
          );
          await _auth?.signInWithCredential(credential);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          //デフォルトは30秒
        },
      );

      // // _status = AuthStatus.authenticating;
      // // notifyListeners();
      // // final result = await _auth?.signInAnonymously();
      // // _authUser = result?.user;
      // // UserModel? tmpUser = await _userService.selectData(
      // //   email: email,
      // //   password: password,
      // // );
      // // if (tmpUser != null) {
      // //   OrganizationModel? tmpOrganization =
      // //       await _organizationService.selectData(
      // //     userId: tmpUser.id,
      // //   );
      // //   if (tmpOrganization != null) {
      // //     _user = tmpUser;
      // //     _organization = tmpOrganization;
      // //     OrganizationGroupModel? tmpGroup = await _groupService.selectData(
      // //       organizationId: tmpOrganization.id,
      // //       userId: tmpUser.id,
      // //     );
      // //     if (tmpGroup != null) {
      // //       _group = tmpGroup;
      // //     }
      // //     String uid = result?.user?.uid ?? '';
      // //     String token = await _fmService.getToken() ?? '';
      // //     _userService.update({
      // //       'id': _user?.id,
      // //       'uid': uid,
      // //       'token': token,
      // //     });
      // //     await setPrefsString('email', email);
      // //     await setPrefsString('password', password);
      // //   } else {
      // //     await _auth?.signOut();
      // //     _status = AuthStatus.unauthenticated;
      // //     notifyListeners();
      // //     error = '団体が見つかりません';
      // //   }
      // } else {
      //   await _auth?.signOut();
      //   _status = AuthStatus.unauthenticated;
      //   notifyListeners();
      //   error = 'メールアドレスまたはパスワードが間違ってます';
      // }
    } catch (e) {
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      error = 'ログインに失敗しました';
    }

    return error;
  }

  Future logout() async {
    _userService.update({
      'id': _user?.id,
      'uid': '',
      'token': '',
    });
    await _auth?.signOut();
    await _ldbService.clear();
    _user = null;
    _status = AuthStatus.unauthenticated;
    notifyListeners();
    return Future.delayed(Duration.zero);
  }

  Future reloadData() async {}

  Future _onStateChanged(User? authUser) async {
    if (authUser == null) {
      _status = AuthStatus.unauthenticated;
    } else {
      _authUser = authUser;
      _status = AuthStatus.authenticated;
    }
    notifyListeners();
  }
}
