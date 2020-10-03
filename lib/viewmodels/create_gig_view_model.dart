import 'package:myApp/locator.dart';
import 'package:myApp/models/gig.dart';
import 'package:myApp/new_services/auth_service.dart';
import 'package:myApp/screens/home/home.dart';
import 'package:myApp/services/navigation_service.dart';
import 'package:myApp/viewmodels/base_model.dart';
import 'package:myApp/services/dialog_service.dart';
import 'package:myApp/services/firestore_service.dart';
import 'package:flutter/material.dart';

class CreateGigViewModel extends BaseModel {
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final DialogService _dialogService = locator<DialogService>();
  final NavigationService _navigationService = locator<NavigationService>();

  Gig _edittingGig;

  bool get _editting => _edittingGig != null;

  Future addGig({
    @required String userId,
    @required String userProfilePictureUrl,
    @required String userFullName,
    @required String gigHashtags,
    @required String gigPost,
    @required dynamic gigDeadLine,
    @required String gigCurrency,
    @required dynamic gigBudget,
    @required String gigValue,
    String adultContentText,
    bool adultContentBool,
  }) async {
    setBusy(true);

    var result;

    if (!_editting) {
      result = await _firestoreService.addGig(Gig(
        userId: userId,
        userProfilePictureUrl: userProfilePictureUrl,
        userFullName: userFullName,
        gigHashtags: gigHashtags,
        gigPost: gigPost,
        gigDeadline: gigDeadLine,
        gigCurrency: gigCurrency,
        gigBudget: gigBudget,
        gigValue: gigValue,
        // documentId: _edittingGig.documentId,
      ));
    } else {
      result = await _firestoreService.updateGig(Gig(
        userId: userId,
        userProfilePictureUrl: userProfilePictureUrl,
        userFullName: userFullName,
        gigHashtags: gigHashtags,
        gigPost: gigPost,
        gigDeadline: gigDeadLine,
        gigCurrency: gigCurrency,
        gigBudget: gigBudget,
        gigValue: gigValue,
        // documentId: _edittingGig.documentId,
      ));
    }
    setBusy(false);

    // if (result is String) {
    //   await _dialogService.showDialog(
    //       title: 'Could not create post', description: result);
    // } else {
    //   await _dialogService.showDialog(
    //     title: 'gig successfully added',
    //     description: 'Your Gig has been created',
    //   );
    // }

    // _navigationService.pop();

    if (result is String) {
      _navigationService.previewAllGigs();
    } else {
      print('error');
    }
  }

  void setEdittingGig(Gig edittingGig) {
    _edittingGig = edittingGig;
  }
}
