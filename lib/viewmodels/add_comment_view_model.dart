import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:Fyrework/locator.dart';
import 'package:Fyrework/models/comment.dart';
import 'package:Fyrework/services/navigation_service.dart';
import 'package:Fyrework/services/firestore_service.dart';

class AddCommentViewModel {
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final NavigationService _navigationService = locator<NavigationService>();

  Future addComment({
    @required String gigIdHoldingComment,
    @required String gigOwnerId,
    @required String gigOwnerUsername,
    String commentId,
    @required String commentOwnerId,
    @required String commentOwnerAvatarUrl,
    @required String commentOwnerUsername,
    @required dynamic commentBody,
    @required bool isPrivateComment,
    @required bool proposal,
    @required bool approved,
    @required bool rejected,
    String gigCurrency,
    String offeredBudget,
    @required String gigValue,
    String preferredPaymentMethod,
    @required bool isGigCompleted,
    @required bool containMediaFile,
    appointedUserId,
    appointedUsername,
    int ratingCount,
    bool leftReview,
  }) async {
    var result;
    result = await _firestoreService.addComment(
        Comment(
          gigIdHoldingComment: gigIdHoldingComment,
          gigOwnerId: gigOwnerId,
          gigOwnerUsername: gigOwnerUsername,
          commentId: commentId,
          commentOwnerId: commentOwnerId,
          commentOwnerAvatarUrl: commentOwnerAvatarUrl,
          commentOwnerUsername: commentOwnerUsername,
          commentBody: commentBody,
          // createdAt: FieldValue.serverTimestamp(),
          createdAt: DateTime.now(),
          isPrivateComment: isPrivateComment,
          proposal: proposal,
          approved: approved,
          rejected: rejected,
          gigCurrency: gigCurrency,
          offeredBudget: offeredBudget,
          gigValue: gigValue,
          preferredPaymentMethod: preferredPaymentMethod,
          containMediaFile: containMediaFile,
          commentPrivacyToggle: isPrivateComment,
          isGigCompleted: isGigCompleted,
          appointedUserId: appointedUserId,
          appointedUsername: appointedUsername,
          ratingCount: ratingCount,
          leftReview: leftReview,
        ),
        gigIdHoldingComment);
  }
}
