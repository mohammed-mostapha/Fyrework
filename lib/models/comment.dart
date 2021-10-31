import 'package:flutter/material.dart';

class Comment {
  final String gigIdHoldingComment;
  final String gigOwnerId;
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
  final String preferredPaymentMethod;
  final String workstreamFileUrl;
  final bool containMediaFile;
  final bool commentPrivacyToggle;
  final bool isGigCompleted;
  final String appointedUserId;
  final String appointedUsername;
  final int ratingCount;
  final bool leftReview;

  Comment({
    this.gigIdHoldingComment,
    this.gigOwnerId,
    this.gigOwnerUsername,
    this.commentId,
    this.commentOwnerId,
    this.commentOwnerAvatarUrl,
    this.commentOwnerUsername,
    this.commentBody,
    this.createdAt,
    this.isPrivateComment,
    this.proposal,
    this.approved,
    this.rejected,
    this.gigCurrency,
    this.offeredBudget,
    this.preferredPaymentMethod,
    this.workstreamFileUrl,
    this.containMediaFile,
    this.commentPrivacyToggle,
    this.isGigCompleted,
    this.appointedUserId,
    this.appointedUsername,
    this.ratingCount,
    this.leftReview,
  });

  Map<String, dynamic> toMap() {
    return {
      'gigIdHoldingComment': gigIdHoldingComment,
      'gigOwnerId': gigOwnerId,
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
      'preferredPaymentMethod': preferredPaymentMethod,
      'workstreamFileUrl': workstreamFileUrl,
      'containMediaFile': containMediaFile,
      'commentPrivacyToggle': commentPrivacyToggle,
      'isGigCompleted': isGigCompleted,
      'appointedUserId': appointedUserId,
      'appointedUsername': appointedUsername,
      'ratingCount': ratingCount,
      'leftReview': leftReview,
    };
  }

  static Comment fromMap(Map<String, dynamic> map, String documentId) {
    if (map == null) return null;

    return Comment(
      gigIdHoldingComment: map['gigIdHoldingComment'],
      gigOwnerId: map['gigOwnerId'],
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
      preferredPaymentMethod: map['preferredPaymentMethod'],
      workstreamFileUrl: map['workstreamFileUrl'],
      containMediaFile: map['containMediaFile'],
      commentPrivacyToggle: map['commentPrivacyToggle'],
      isGigCompleted: map['isGigCompleted'],
      appointedUserId: map['appointedUserId'],
      appointedUsername: map['appointedUsername'],
      ratingCount: map['ratingCount'],
      leftReview: map['leftReview'],
    );
  }
}
