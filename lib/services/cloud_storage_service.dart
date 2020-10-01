import 'dart:io';

import 'package:flutter/material.dart';
import '../models/cloud_storage_result.dart';
import 'package:firebase_storage/firebase_storage.dart';

class CloudStorageService {
  Future<CloudStorageResult> uploadMediaFile({
    @required File mediaFileToUpload,
    @required String title,
  }) async {
    var imageFileName =
        title + DateTime.now().millisecondsSinceEpoch.toString();

    // GET the reference to the file we want to create
    final StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(imageFileName);

    StorageUploadTask uploadTask =
        firebaseStorageRef.putFile(mediaFileToUpload);
    StorageTaskSnapshot storageSnapshot = await uploadTask.onComplete;
    print('one file has been uploaded');
    //making a downloadable URL of the uploaded image
    var downloadUrl = await storageSnapshot.ref.getDownloadURL();

    if (uploadTask.isComplete) {
      var url = downloadUrl.toString();
      return CloudStorageResult(
        imageUrl: url,
        imageFileName: imageFileName,
      );
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
