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

  Future<String?> sendCode({
    required String phoneNumber,
    bool reSend = false,
  }) async {
    String? error;
    if (phoneNumber == '') return '電話番号を入力してください';
    int? forceResendingToken;
    if (reSend) {
      String resendTokenString =
          await _ldbService.getString('resendTokenString') ?? '';
      forceResendingToken = int.parse(resendTokenString);
    }
    await _auth?.verifyPhoneNumber(
      phoneNumber: '+81$phoneNumber',
      verificationCompleted: (credential) {},
      verificationFailed: (e) {
        if (e.code == 'invalid-phone-number') {
          error = '電話番号が正しくありません';
        } else {
          error = e.toString();
        }
      },
      codeSent: (id, resendToken) async {
        await _ldbService.setString('verificationId', id);
        await _ldbService.setString(
          'resendTokenString',
          resendToken?.toString() ?? '',
        );
      },
      codeAutoRetrievalTimeout: (id) {},
      forceResendingToken: forceResendingToken,
    );
    return error;
  }

  Future<String?> login({
    required String smsCode,
  }) async {
    String? error;
    if (smsCode == '') return '認証コードを入力してください';
    try {
      _status = AuthStatus.authenticating;
      notifyListeners();
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: await _ldbService.getString('verificationId') ?? '',
        smsCode: smsCode,
      );
      final result = await _auth?.signInWithCredential(credential);
      _authUser = result?.user;
      //ユーザーデータの保存
      //tokenの保存
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
