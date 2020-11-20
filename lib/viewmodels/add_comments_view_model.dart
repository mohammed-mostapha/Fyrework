import 'package:myApp/locator.dart';
import 'package:myApp/models/comment.dart';
import 'package:myApp/services/navigation_service.dart';
import 'package:myApp/viewmodels/base_model.dart';
import 'package:myApp/services/firestore_service.dart';
import 'package:flutter/material.dart';

class AddCommentsViewModel extends BaseModel {
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final NavigationService _navigationService = locator<NavigationService>();

  Future addComment({
    @required String gigIdHoldingComment,
    String commentId,
    @required String commentOwnerId,
    @required String commentOwnerProfilePictureUrl,
    @required String comentOwnerFullName,
    @required String commentBody,
  }) async {
    setBusy(true);

    var result;

    result = await _firestoreService.addComment(
        Comment(
          gigIdHoldingComment: gigIdHoldingComment,
          commentId: commentId,
          commentOwnerId: commentOwnerId,
          commentOwnerProfilePictureUrl: commentOwnerProfilePictureUrl,
          comentOwnerFullName: comentOwnerFullName,
          commentBody: commentBody,
        ),
        gigIdHoldingComment);

    if (result is String) {
      // _navigationService.previewAllGigs();
    } else {}
  }
}
