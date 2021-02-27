import 'package:Fyrework/locator.dart';
import 'package:Fyrework/models/gig.dart';
import 'package:Fyrework/services/database.dart';
import 'package:Fyrework/services/navigation_service.dart';
import 'package:Fyrework/viewmodels/base_model.dart';
import 'package:Fyrework/services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CreateGigViewModel extends BaseModel {
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final NavigationService _navigationService = locator<NavigationService>();

  Gig _edittingGig;

  bool get _editting => _edittingGig != null;

  Future addGig({
    bool appointed,
    String gigId,
    @required String userId,
    @required String userProfilePictureDownloadUrl,
    @required String username,
    // dynamic createdAt,
    @required List gigHashtags,
    @required String userLocation,
    @required String gigLocation,
    @required List<String> gigMediaFilesDownloadUrls,
    @required String gigPost,
    @required dynamic gigDeadLine,
    @required String gigCurrency,
    @required dynamic gigBudget,
    @required String gigValue,
    String adultContentText,
    bool adultContentBool,
  }) async {
    var gigAdded;
    var updatedOngoingGigsByGigId;

    if (!_editting) {
      gigAdded = await _firestoreService.addGig(
        gigHashtags,
        Gig(
          appointed: appointed,
          gigId: gigId,
          gigOwnerId: userId,
          gigOwnerAvatarUrl: userProfilePictureDownloadUrl,
          gigOwnerUsername: username,
          createdAt: FieldValue.serverTimestamp(),
          gigHashtags: gigHashtags,
          gigOwnerLocation: userLocation,
          gigLocation: gigLocation,
          gigMediaFilesDownloadUrls: gigMediaFilesDownloadUrls,
          gigPost: gigPost,
          gigDeadline: gigDeadLine,
          gigCurrency: gigCurrency,
          gigBudget: gigBudget,
          gigValue: gigValue,
          adultContentText: adultContentText,
          adultContentBool: adultContentBool,
        ),
      );
    } else {
      gigAdded = await _firestoreService.updateGig(
        Gig(
          appointed: appointed,
          gigId: gigId,
          gigOwnerId: userId,
          gigMediaFilesDownloadUrls: userProfilePictureDownloadUrl,
          gigOwnerUsername: username,
          gigHashtags: gigHashtags,
          gigOwnerLocation: userLocation,
          gigLocation: gigLocation,
          gigPost: gigPost,
          gigDeadline: gigDeadLine,
          gigCurrency: gigCurrency,
          gigBudget: gigBudget,
          gigValue: gigValue,
          adultContentText: adultContentText,
          adultContentBool: adultContentBool,
        ),
      );
    }
    setBusy(false);

    // if (gigAdded is String && updatedOngoingGigsByGigId is String) {
    if (gigAdded is String) {
      _navigationService.previewAllGigs();
    } else {
      print('error');
    }
  }

  void setEdittingGig(Gig edittingGig) {
    _edittingGig = edittingGig;
  }
}
