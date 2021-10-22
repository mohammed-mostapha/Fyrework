import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:Fyrework/locator.dart';
// import 'package:myApp/services/auth_service.dart';

class StorageRepo {
  FirebaseStorage usersProfilePicsStorage =
      FirebaseStorage.instanceFor(bucket: "gs://fyrework-63dd9.appspot.com");
  FirebaseStorage gigMediaFilesStorage =
      FirebaseStorage.instanceFor(bucket: "gs://fyrework-63dd9.appspot.com");

  // AuthService _authService = locator.get<AuthService>();

  //uploading and getting downloadURl of users profiles pics
  Future<String> uploadProfilePicture(
      {@required File profilePictureToUpload, @required String userId}) async {
    // var userId = await _authService.getCurrentUID();

    var usersProfilePicsStorageRef =
        usersProfilePicsStorage.ref().child("users/profile_pictures/$userId");

    var uploadProfilePicture =
        usersProfilePicsStorageRef.putFile(profilePictureToUpload);

    var completedTask = await uploadProfilePicture;

    String profilePictureDownloadUrl = await completedTask.ref.getDownloadURL();

    return profilePictureDownloadUrl;
  }

  Future<dynamic> getUserProfilePictureDownloadUrl(String uid) {
    var usersProfilePicsStorageRef =
        usersProfilePicsStorage.ref().child("users/profile_pictures/$uid");
    return usersProfilePicsStorageRef.getDownloadURL();
  }

  //deleting user profile picture
  Future<dynamic> deleteProfilePicture(String url) async {
    print('print url: $url');
    Reference profilePictureToDelete = await usersProfilePicsStorage.ref(url);
    await profilePictureToDelete.delete();
  }

  //uploading gig media files

  Future<String> uploadMediaFile({
    @required String title,
    @required File mediaFileToUpload,
  }) async {
    var imageFileName =
        title + DateTime.now().millisecondsSinceEpoch.toString();

    // GET the reference to the file we want to create
    final Reference gigMediaFilesStorageRef = FirebaseStorage.instance
        .ref()
        .child("gigs/gigMediaFiles/$imageFileName");

    UploadTask uploadTask = gigMediaFilesStorageRef.putFile(mediaFileToUpload);
    TaskSnapshot storageSnapshot = await uploadTask;
    print('one file has been uploaded');
    //making a downloadable URL of the uploaded image
    var downloadUrl = await storageSnapshot.ref.getDownloadURL();

    // if (uploadTask.isComplete) {
    if (downloadUrl != null) {
      return downloadUrl;
      // return CloudStorageResult(
      //   imageUrl: url,
      //   imageFileName: imageFileName,
      // );
    }

    return null;
  }

  Future deleteImage(String imageFileName) async {
    final Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(imageFileName);

    try {
      await firebaseStorageRef.delete();
    } catch (e) {
      return e.toString();
    }
  }
}
