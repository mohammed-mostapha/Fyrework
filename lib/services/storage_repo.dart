import 'dart:io';
import 'package:Fyrework/services/bunny_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StorageRepo {
  //uploading and getting downloadURl of users profiles pics
  Future uploadMyAvatar({
    @required File profilePictureToUPload,
    @required String userId,
    @required String storageZonePath,
  }) async {
    String myUploadedAvatarUrl = await BunnyService().uploadAvatarToBunny(
      fileToUpload: profilePictureToUPload,
      userId: userId,
      storageZonePath: storageZonePath,
    );
    print('uploaded your avatar');
    return myUploadedAvatarUrl;
  }

  // delete user profile picture
  Future deleteMyAvatar({
    @required String userAvatarUrl,
  }) async {
    await BunnyService().deleteAvatarFromBunny(
      userAvatarUrl: userAvatarUrl,
    );
    print('deleted your avatar');
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
