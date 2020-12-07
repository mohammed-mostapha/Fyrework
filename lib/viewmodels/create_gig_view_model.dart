import 'package:myApp/locator.dart';
import 'package:myApp/models/gig.dart';
import 'package:myApp/services/database.dart';
import 'package:myApp/services/navigation_service.dart';
import 'package:myApp/viewmodels/base_model.dart';
import 'package:myApp/services/firestore_service.dart';
import 'package:flutter/material.dart';

class CreateGigViewModel extends BaseModel {
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final NavigationService _navigationService = locator<NavigationService>();

  Gig _edittingGig;

  bool get _editting => _edittingGig != null;

  Future addGig({
    String gigId,
    @required String userId,
    @required String userProfilePictureDownloadUrl,
    @required String userFullName,
    @required String gigHashtags,
    @required List<String> gigMediaFilesDownloadUrls,
    @required String gigPost,
    @required dynamic gigDeadLine,
    @required String gigCurrency,
    @required dynamic gigBudget,
    @required String gigValue,
    String adultContentText,
    bool adultContentBool,
  }) async {
    setBusy(true);

    var gigAdded;
    var updatedOngoingGigsByGigId;

    if (!_editting) {
      gigAdded = await _firestoreService.addGig(
        Gig(
          gigId: gigId,
          gigOwnerId: userId,
          userProfilePictureDownloadUrl: userProfilePictureDownloadUrl,
          userFullName: userFullName,
          gigHashtags: gigHashtags,
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
          gigId: gigId,
          gigOwnerId: userId,
          userProfilePictureDownloadUrl: userProfilePictureDownloadUrl,
          userFullName: userFullName,
          gigHashtags: gigHashtags,
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
