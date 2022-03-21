import 'package:flutter/material.dart';

class Comment {
  final String gigOwnerId;
  final String gigOwnerUsername;
  final String commentOwnerId;
  final String commentOwnerAvatarUrl;
  final String commentOwnerUsername;
  final dynamic commentBody;
  dynamic createdAt;
  final bool isPrivateComment;
  final bool proposal;
  final bool approved;
  final bool rejected;
  final String preferredPaymentMethod;
  final String workstreamFileUrl;
  final bool containMediaFile;

  Comment({
    @required this.gigOwnerId,
    @required this.gigOwnerUsername,
    @required this.commentOwnerId,
    @required this.commentOwnerAvatarUrl,
    @required this.commentOwnerUsername,
    @required this.commentBody,
    @required this.createdAt,
    @required this.isPrivateComment,
    @required this.proposal,
    @required this.approved,
    @required this.rejected,
    this.preferredPaymentMethod,
    this.workstreamFileUrl,
    @required this.containMediaFile,
  });

  Map<String, dynamic> toMap(
      {@required parentGigId, @required clientGeneratedId}) {
    return {
      'parentGigId': parentGigId,
      'commentId': clientGeneratedId,
      'gigOwnerId': gigOwnerId,
      'gigOwnerUsername': gigOwnerUsername,
      'commentOwnerId': commentOwnerId,
      'commentOwnerAvatarUrl': commentOwnerAvatarUrl,
      'commentOwnerUsername': commentOwnerUsername,
      'commentBody': commentBody,
      'createdAt': createdAt,
      'isPrivateComment': isPrivateComment,
      'proposal': proposal,
      'approved': approved,
      'rejected': rejected,
      'preferredPaymentMethod': preferredPaymentMethod,
      'workstreamFileUrl': workstreamFileUrl,
      'containMediaFile': containMediaFile,
    };
  }

  static Comment fromMap(Map<String, dynamic> map, String documentId) {
    if (map == null) return null;

    return Comment(
      gigOwnerId: map['gigOwnerId'],
      gigOwnerUsername: map['gigOwnerUsername'],
      commentOwnerId: map['commentOwnerId'],
      commentOwnerAvatarUrl: map['commentOwnerAvatarUrl'],
      commentOwnerUsername: map['commentOwnerUsername'],
      commentBody: map['commentBody'],
      createdAt: map['createdAt'],
      isPrivateComment: map['isPrivateComment'],
      proposal: map['proposal'],
      approved: map['approved'],
      rejected: map['rejected'],
      preferredPaymentMethod: map['preferredPaymentMethod'],
      workstreamFileUrl: map['workstreamFileUrl'],
      containMediaFile: map['containMediaFile'],
    );
  }
}
