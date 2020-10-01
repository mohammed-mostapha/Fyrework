import 'dart:io';
import 'package:myApp/locator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myApp/models/user.dart';
import 'package:myApp/new_services/auth_service.dart';
import 'package:myApp/new_services/storage_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserController {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  User _currentUser;
  String _preferencesUserUid;
  String _preferencesUserFullName;
  dynamic _preferencesAvatarUrl;
  AuthService _authService = locator.get<AuthService>();
  // StorageRepo _storageRepo = locator.get<StorageRepo>();

// saving user data in shared preferences
  // Future<void> savePreferencesUserUid(
  //   String uid,
  // ) async {
  //   final SharedPreferences prefs = await _prefs;
  //   prefs.setString("userUid", uid);
  // }

  // Future<void> savePreferencesUserFullName(
  //   String userFullName,
  // ) async {
  //   final SharedPreferences prefs = await _prefs;
  //   prefs.setString("preferencesUserFullName", userFullName);
  // }

//getting user data from shared preferences
  // getPreferencesUserUid() async {
  //   final SharedPreferences prefs = await _prefs;
  //   _preferencesUserUid = prefs.getString("userUid");
  //   return _preferencesUserUid;
  // }

  // getPreferencesUserFullName() async {
  //   final SharedPreferences prefs = await _prefs;
  //   _preferencesUserFullName = prefs.getString("preferencesUserFullName");
  //   return _preferencesUserUid;
  // }

  Future uploadProfilePicture(File image) async {
    _preferencesAvatarUrl =
        await locator.get<StorageRepo>().uploadProfilePicture(image);
    print(_preferencesAvatarUrl);
  }

  // Future<String> getProfilePictureDownloadUrl() async {
  //   return _avatarUrl = await _storageRepo
  //       .getUserProfilePictureDownloadUrl(await _authService.getCurrentUID());
  // }

  Future<void> signInWithEmailAndPassword(
      {String email, String password}) async {
    print('1111111111111111111111111111111111111');
    _currentUser = await _authService.signInWithEmailAndPassword(
      email,
      password,
    );
    print('22222222222222222222222222222222222222');
    // _avatarUrl = await getProfilePictureDownloadUrl();
    print(_preferencesAvatarUrl.runtimeType);
    print('333333333333333333333333333333333333333');

    print(_currentUser.fullName);
    print(_currentUser.uid);
    print(_preferencesAvatarUrl);
  }

  // String setAvatarUrl(userAvatar) => this._avatarUrl = userAvatar;
  // String setUserFullName(userFullName) =>
  //     this._currentUser.fullName = userFullName;

  // void setCurrentUserUid(uid) {
  //   print('Coming from UserController...i received this uid: ${uid}');
  //   this._currentUserUid = uid;
  //   print(
  //       'Coming from UserController...after assigning the new uid it is: $_currentUserUid');
  // }

  // Future<String> setAvatarUrlAndUserFullName(userAvatar, userFullName) {
  //   this._avatarUrl = userAvatar;
  //   this._currentUser.fullName = userFullName;
  // }

  // User get currentUser => _currentUser;
  // AuthService get authService => _authService;
  // get currentUserUid {
  //   return print(_currentUserUid);
  // }

  // get avatarUrl => _avatarUrl;
  // String get currentUserFullName => _currentUserFullName;
}
