import 'package:flutter/material.dart';
import 'package:myApp/locator.dart';
import 'package:myApp/models/comment.dart';
import 'package:myApp/services/navigation_service.dart';
import 'package:myApp/viewmodels/base_model.dart';
import 'package:myApp/services/firestore_service.dart';

class AddCommentsViewModel extends BaseModel {
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final NavigationService _navigationService = locator<NavigationService>();

  Comment _edittingcomment;

  bool get _editting => _edittingcomment != null;

  Future addComment({
    @required String gigIdHoldingComment,
    String commentId,
    @required String commentOwnerId,
    @required String commentOwnerProfilePictureUrl,
    @required String commentOwnerFullName,
    @required String commentBody,
    @required DateTime commentTime,
    @required bool privateComment,
  }) async {
    setBusy(true);

    var result;
    if (!_editting) {
      result = await _firestoreService.addComment(
          Comment(
              gigIdHoldingComment: gigIdHoldingComment,
              commentId: commentId,
              commentOwnerId: commentOwnerId,
              commentOwnerProfilePictureUrl: commentOwnerProfilePictureUrl,
              commentOwnerFullName: commentOwnerFullName,
              commentBody: commentBody,
              commentTime: commentTime,
              privateComment: privateComment),
          gigIdHoldingComment);

      // if (result is String) {
      //   // _navigationService.previewAllGigs();
      // } else {}
    } else {
      result = await _firestoreService.updateComment(
        Comment(
            gigIdHoldingComment: gigIdHoldingComment,
            commentId: commentId,
            commentOwnerId: commentOwnerId,
            commentOwnerProfilePictureUrl: commentOwnerProfilePictureUrl,
            commentOwnerFullName: commentOwnerFullName,
            commentBody: commentBody,
            commentTime: commentTime,
            privateComment: privateComment),
      );
    }
    setBusy(false);
  }

  void setEdittingComment(Comment edittingComment) {
    _edittingcomment = edittingComment;
  }
}
