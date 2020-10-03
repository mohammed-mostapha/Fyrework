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
  dynamic _userAvatarUrl;
  AuthService _authService = locator.get<AuthService>();
  StorageRepo _storageRepo = locator.get<StorageRepo>();

  Future uploadProfilePicture(File image) async {
    _userAvatarUrl =
        await locator.get<StorageRepo>().uploadProfilePicture(image);
    print(_userAvatarUrl);
  }

  Future<String> getProfilePictureDownloadUrl() async {
    return _userAvatarUrl = await _storageRepo
        .getUserProfilePictureDownloadUrl(await _authService.getCurrentUID());
  }

  Future<void> signInWithEmailAndPassword(
      {String email, String password}) async {
    _currentUser = await _authService.signInWithEmailAndPassword(
      email,
      password,
    );

    _userAvatarUrl = await getProfilePictureDownloadUrl();

    print(_currentUser.fullName);
    print(_currentUser.uid);
    print(_userAvatarUrl);
  }
}
