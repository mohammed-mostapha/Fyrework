import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:myApp/locator.dart';
import 'package:myApp/new_services/auth_service.dart';
import 'package:myApp/vew_controllers/user_controller.dart';

class StorageRepo {
  FirebaseStorage storage =
      FirebaseStorage(storageBucket: "gs://fyrework-63dd9.appspot.com");

  AuthService _authService = locator.get<AuthService>();

  Future<String> uploadProfilePicture(File file) async {
    var userId = await _authService.getCurrentUID();

    var storageRef = storage.ref().child("users/profile_pictures/$userId");

    var uploadProfilePicture = storageRef.putFile(file);

    var completedTask = await uploadProfilePicture.onComplete;

    String profilePictureDownloadUrl = await completedTask.ref.getDownloadURL();

    return profilePictureDownloadUrl;
  }

  Future<dynamic> getUserProfilePictureDownloadUrl(String uid) {
    var storageRef = storage.ref().child("users/profile_pictures/$uid");
    return storageRef.getDownloadURL();
  }
}
