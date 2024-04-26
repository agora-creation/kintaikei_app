import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kintaikei_app/models/company_group.dart';
import 'package:kintaikei_app/models/user.dart';
import 'package:kintaikei_app/services/company_group.dart';
import 'package:kintaikei_app/services/fm.dart';
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

  final FmService _fmService = FmService();
  final LocalDBService _localDBService = LocalDBService();
  final UserService _userService = UserService();
  UserModel? _user;
  UserModel? get user => _user;
  final CompanyGroupService _groupService = CompanyGroupService();
  List<CompanyGroupModel> _groups = [];
  List<CompanyGroupModel> get groups => _groups;

  LoginProvider.initialize() : _auth = FirebaseAuth.instance {
    _auth?.authStateChanges().listen(_onStateChanged);
  }

  Future<String?> register({
    required String name,
    required String email,
    required String password,
  }) async {
    String? error;
    if (name == '') return '名前を入力してください';
    if (email == '') return 'メールアドレスを入力してください';
    if (password == '') return 'パスワードを入力してください';
    try {
      _status = AuthStatus.authenticating;
      notifyListeners();
      final result = await _auth?.signInAnonymously();
      _authUser = result?.user;
      bool isExist = await _userService.emailCheck(email);
      if (!isExist) {
        String id = _userService.id();
        String uid = result?.user?.uid ?? '';
        String token = await _fmService.getToken() ?? '';
        _userService.create({
          'id': id,
          'name': name,
          'email': email,
          'password': password,
          'uid': uid,
          'token': token,
          'lastWorkId': '',
          'lastWorkBreakId': '',
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
    if (email == '') return 'メールアドレスを入力してください';
    if (password == '') return 'パスワードを入力してください';
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
        List<CompanyGroupModel> tmpGroups = await _groupService.selectList(
          userId: tmpUser.id,
        );
        if (tmpGroups.isNotEmpty) {
          _groups = tmpGroups;
        }
        String uid = result?.user?.uid ?? '';
        String token = await _fmService.getToken() ?? '';
        _userService.update({
          'id': _user?.id,
          'uid': uid,
          'token': token,
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

  Future<String?> updateName({
    required String name,
  }) async {
    String? error;
    if (name == '') return '名前を入力してください';
    try {
      _userService.update({
        'id': _user?.id,
        'name': name,
      });
    } catch (e) {
      error = e.toString();
    }
    return error;
  }

  Future<String?> updateEmail({
    required String email,
  }) async {
    String? error;
    if (email == '') return 'メールアドレスを入力してください';
    try {
      bool isExist = await _userService.emailCheck(email);
      if (!isExist) {
        _userService.update({
          'id': _user?.id,
          'email': email,
        });
      } else {
        error = '既に同じメールアドレスが登録されています';
      }
    } catch (e) {
      error = e.toString();
    }
    return error;
  }

  Future<String?> updatePassword({
    required String password,
    required String newPassword,
  }) async {
    String? error;
    if (newPassword == '') return '新しいパスワードを入力してください';
    try {
      UserModel? tmpUser = await _userService.selectToEmailPassword(
        email: _user?.email,
        password: password,
      );
      if (tmpUser != null) {
        _userService.update({
          'id': _user?.id,
          'password': password,
        });
      } else {
        error = '現在のパスワードが間違っています';
      }
    } catch (e) {
      error = e.toString();
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
    _groups.clear();
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
      List<CompanyGroupModel> tmpGroup = await _groupService.selectList(
        userId: tmpUser.id,
      );
      if (tmpGroup.isNotEmpty) {
        _groups = tmpGroup;
      }
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
        List<CompanyGroupModel> tmpGroup = await _groupService.selectList(
          userId: tmpUser.id,
        );
        if (tmpGroup.isNotEmpty) {
          _groups = tmpGroup;
        }
      } else {
        _authUser = null;
        _status = AuthStatus.unauthenticated;
      }
    }
    notifyListeners();
  }
}
