import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:Fyrework/locator.dart';
import 'package:Fyrework/models/comment.dart';
import 'package:Fyrework/services/navigation_service.dart';
import 'package:Fyrework/services/firestore_service.dart';

class AddCommentViewModel {
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final NavigationService _navigationService = locator<NavigationService>();

  Comment _edittingcomment;

  bool get _editting => _edittingcomment != null;

  Future addComment({
    @required String gigIdHoldingComment,
    @required String gigOwnerId,
    String commentId,
    @required String commentOwnerId,
    @required String commentOwnerAvatarUrl,
    @required String commentOwnerUsername,
    @required String commentBody,
    @required bool isPrivateComment,
    bool persistentPrivateComment,
    @required bool proposal,
    @required bool approved,
    @required bool rejected,
    @required String gigCurrency,
    @required String offeredBudget,
    String preferredPaymentMethod,
    @required bool containMediaFile,
  }) async {
    var result;
    if (!_editting) {
      result = await _firestoreService.addComment(
          Comment(
            gigIdHoldingComment: gigIdHoldingComment,
            gigOwnerId: gigOwnerId,
            commentId: commentId,
            commentOwnerId: commentOwnerId,
            commentOwnerAvatarUrl: commentOwnerAvatarUrl,
            commentOwnerUsername: commentOwnerUsername,
            commentBody: commentBody,
            createdAt: FieldValue.serverTimestamp(),
            isPrivateComment: isPrivateComment,
            persistentPrivateComment: persistentPrivateComment,
            proposal: proposal,
            approved: approved,
            rejected: rejected,
            gigCurrency: gigCurrency,
            offeredBudget: offeredBudget,
            preferredPaymentMethod: preferredPaymentMethod,
            containMediaFile: containMediaFile,
          ),
          gigIdHoldingComment);
    } else {
      result = await _firestoreService.updateComment(
        Comment(
          gigIdHoldingComment: gigIdHoldingComment,
          gigOwnerId: gigOwnerId,
          commentId: commentId,
          commentOwnerId: commentOwnerId,
          commentOwnerAvatarUrl: commentOwnerAvatarUrl,
          commentOwnerUsername: commentOwnerUsername,
          commentBody: commentBody,
          // commentTime: commentTime,
          isPrivateComment: isPrivateComment,
          persistentPrivateComment: persistentPrivateComment,
          proposal: proposal,
          approved: approved,
          rejected: rejected,
          gigCurrency: gigCurrency,
          offeredBudget: offeredBudget,
          preferredPaymentMethod: preferredPaymentMethod,
          containMediaFile: containMediaFile,
        ),
      );
    }
  }
}
