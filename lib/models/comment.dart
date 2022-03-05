import 'package:flutter/material.dart';

class Comment {
  final String gigIdHoldingComment;
  final String gigOwnerId;
  final String gigClientId;
  final String gigworkerId;
  final String gigOwnerUsername;
  final String commentId;
  final String commentOwnerId;
  final String commentOwnerAvatarUrl;
  final String commentOwnerUsername;
  final dynamic commentBody;
  dynamic createdAt;
  final bool isPrivateComment;
  final bool proposal;
  final bool approved;
  final bool rejected;
  final String gigCurrency;
  final String offeredBudget;
  final String gigValue;
  final String preferredPaymentMethod;
  final String workstreamFileUrl;
  final bool containMediaFile;
  final bool commentPrivacyToggle;
  final bool isGigCompleted;
  final int ratingCount;
  final bool leftReview;

  Comment({
    @required this.gigIdHoldingComment,
    @required this.gigOwnerId,
    @required this.gigClientId,
    @required this.gigworkerId,
    @required this.gigOwnerUsername,
    @required this.commentId,
    @required this.commentOwnerId,
    @required this.commentOwnerAvatarUrl,
    @required this.commentOwnerUsername,
    @required this.commentBody,
    @required this.createdAt,
    @required this.isPrivateComment,
    @required this.proposal,
    @required this.approved,
    @required this.rejected,
    @required this.gigCurrency,
    @required this.offeredBudget,
    @required this.gigValue,
    @required this.preferredPaymentMethod,
    @required this.workstreamFileUrl,
    @required this.containMediaFile,
    @required this.commentPrivacyToggle,
    @required this.isGigCompleted,
    @required this.ratingCount,
    @required this.leftReview,
  });

  Map<String, dynamic> toMap() {
    return {
      'gigIdHoldingComment': gigIdHoldingComment,
      'gigOwnerId': gigOwnerId,
      'gigClientId': gigClientId,
      'gigWorkerId': gigworkerId,
      'gigOwnerUsername': gigOwnerUsername,
      'commentId': commentId,
      'commentOwnerId': commentOwnerId,
      'commentOwnerAvatarUrl': commentOwnerAvatarUrl,
      'commentOwnerUsername': commentOwnerUsername,
      'commentBody': commentBody,
      'createdAt': createdAt,
      'isPrivateComment': isPrivateComment,
      'proposal': proposal,
      'approved': approved,
      'rejected': rejected,
      'gigCurrency': gigCurrency,
      'offeredBudget': offeredBudget,
      'gigValue': gigValue,
      'preferredPaymentMethod': preferredPaymentMethod,
      'workstreamFileUrl': workstreamFileUrl,
      'containMediaFile': containMediaFile,
      'commentPrivacyToggle': commentPrivacyToggle,
      'isGigCompleted': isGigCompleted,
      'ratingCount': ratingCount,
      'leftReview': leftReview,
    };
  }

  static Comment fromMap(Map<String, dynamic> map, String documentId) {
    if (map == null) return null;

    return Comment(
      gigIdHoldingComment: map['gigIdHoldingComment'],
      gigOwnerId: map['gigOwnerId'],
      gigClientId: map['gigClientId'],
      gigworkerId: map['gigWorkerId'],
      gigOwnerUsername: map['gigOwnerUsername'],
      commentId: map['commentId'],
      commentOwnerId: map['commentOwnerId'],
      commentOwnerAvatarUrl: map['commentOwnerAvatarUrl'],
      commentOwnerUsername: map['commentOwnerUsername'],
      commentBody: map['commentBody'],
      createdAt: map['createdAt'],
      isPrivateComment: map['isPrivateComment'],
      proposal: map['proposal'],
      approved: map['approved'],
      rejected: map['rejected'],
      gigCurrency: map['gigCurrency'],
      offeredBudget: map['offeredBudget'],
      gigValue: map['gigValue'],
      preferredPaymentMethod: map['preferredPaymentMethod'],
      workstreamFileUrl: map['workstreamFileUrl'],
      containMediaFile: map['containMediaFile'],
      commentPrivacyToggle: map['commentPrivacyToggle'],
      isGigCompleted: map['isGigCompleted'],
      ratingCount: map['ratingCount'],
      leftReview: map['leftReview'],
    );
  }
}
