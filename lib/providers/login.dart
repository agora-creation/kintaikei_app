import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kintaikei_app/models/user.dart';
import 'package:kintaikei_app/services/local_db.dart';
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

  final LocalDBService _localDBService = LocalDBService();
  final UserService _userService = UserService();
  UserModel? _user;
  UserModel? get user => _user;

  LoginProvider.initialize() : _auth = FirebaseAuth.instance {
    _auth?.authStateChanges().listen(_onStateChanged);
  }

  Future<String?> register({
    required String name,
    required String email,
    required String password,
  }) async {
    String? error;
    try {
      _status = AuthStatus.authenticating;
      notifyListeners();
      final result = await _auth?.signInAnonymously();
      _authUser = result?.user;
      bool isExist = await _userService.emailCheck(email);
      if (!isExist) {
        String id = _userService.id();
        String uid = result?.user?.uid ?? '';
        _userService.create({
          'id': id,
          'name': name,
          'email': email,
          'password': password,
          'uid': uid,
          'token': '',
          'createdAt': DateTime.now(),
        });
      } else {
        await _auth?.signOut();
        _status = AuthStatus.unauthenticated;
        notifyListeners();
        error = '既に同じメールアドレスが登録されています';
      }
    } catch (e) {
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      error = '登録に失敗しました';
    }
    return error;
  }

  Future<String?> login({
    required String email,
    required String password,
  }) async {
    String? error;
    try {
      _status = AuthStatus.authenticating;
      notifyListeners();
      final result = await _auth?.signInAnonymously();
      _authUser = result?.user;
      UserModel? tmpUser = await _userService.selectToEmailPassword(
        email: email,
        password: password,
      );
      if (tmpUser != null) {
        _user = tmpUser;
        String uid = result?.user?.uid ?? '';
        _userService.update({
          'id': _user?.id,
          'uid': uid,
          'token': '',
        });
      } else {
        await _auth?.signOut();
        _status = AuthStatus.unauthenticated;
        notifyListeners();
        error = 'メールアドレスまたはパスワードが間違ってます';
      }
    } catch (e) {
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      error = 'ログインに失敗しました';
    }
    return error;
  }

  Future _clearUserData() async {
    _userService.update({
      'id': _user?.id,
      'uid': '',
      'token': '',
    });
  }

  Future logout() async {
    await _clearUserData();
    await _auth?.signOut();
    await _localDBService.clear();
    _user = null;
    _status = AuthStatus.unauthenticated;
    notifyListeners();
    return Future.delayed(Duration.zero);
  }

  Future reloadData() async {
    UserModel? tmpUser = await _userService.selectToUid(
      uid: _authUser?.uid,
    );
    if (tmpUser != null) {
      _user = tmpUser;
    }
    notifyListeners();
  }

  Future _onStateChanged(User? authUser) async {
    if (authUser == null) {
      _status = AuthStatus.unauthenticated;
    } else {
      _authUser = authUser;
      _status = AuthStatus.authenticated;
      UserModel? tmpUser = await _userService.selectToUid(
        uid: _authUser?.uid,
      );
      if (tmpUser != null) {
        _user = tmpUser;
      } else {
        _authUser = null;
        _status = AuthStatus.unauthenticated;
      }
    }
    notifyListeners();
  }
}
