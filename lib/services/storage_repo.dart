import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:myApp/locator.dart';
import 'package:myApp/services/auth_service.dart';
import '../models/cloud_storage_result.dart';

class StorageRepo {
  FirebaseStorage usersProfilePicsStorage =
      FirebaseStorage(storageBucket: "gs://fyrework-63dd9.appspot.com");
  FirebaseStorage gigMediaFilesStorage =
      FirebaseStorage(storageBucket: "gs://fyrework-63dd9.appspot.com");

  AuthService _authService = locator.get<AuthService>();

  //uploading and getting downloadURl of users profiles pics
  Future<String> uploadProfilePicture(File file) async {
    var userId = await _authService.getCurrentUID();

    var usersProfilePicsStorageRef =
        usersProfilePicsStorage.ref().child("users/profile_pictures/$userId");

    var uploadProfilePicture = usersProfilePicsStorageRef.putFile(file);

    var completedTask = await uploadProfilePicture.onComplete;

    String profilePictureDownloadUrl = await completedTask.ref.getDownloadURL();

    return profilePictureDownloadUrl;
  }

  Future<dynamic> getUserProfilePictureDownloadUrl(String uid) {
    var usersProfilePicsStorageRef =
        usersProfilePicsStorage.ref().child("users/profile_pictures/$uid");
    return usersProfilePicsStorageRef.getDownloadURL();
  }

  //uploading gig media files

  Future<String> uploadMediaFile({
    @required File mediaFileToUpload,
    @required String title,
  }) async {
    var imageFileName =
        title + DateTime.now().millisecondsSinceEpoch.toString();

    // GET the reference to the file we want to create
    final StorageReference gigMediaFilesStorageRef = FirebaseStorage.instance
        .ref()
        .child("gigs/gigMediaFiles/$imageFileName");

    StorageUploadTask uploadTask =
        gigMediaFilesStorageRef.putFile(mediaFileToUpload);
    StorageTaskSnapshot storageSnapshot = await uploadTask.onComplete;
    print('one file has been uploaded');
    //making a downloadable URL of the uploaded image
    var downloadUrl = await storageSnapshot.ref.getDownloadURL();

    if (uploadTask.isComplete) {
      return downloadUrl;
      // return CloudStorageResult(
      //   imageUrl: url,
      //   imageFileName: imageFileName,
      // );
    }

    return null;
  }

  Future deleteImage(String imageFileName) async {
    final StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(imageFileName);

    try {
      await firebaseStorageRef.delete();
    } catch (e) {
      return e.toString();
    }
  }
}
