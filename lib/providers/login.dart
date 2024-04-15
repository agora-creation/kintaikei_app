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

  Future<String?> login({
    required String phoneNumber,
  }) async {
    String? error;
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
