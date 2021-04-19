class Comment {
  final String gigIdHoldingComment;
  final String gigOwnerId;
  final String commentId;
  final String commentOwnerId;
  final String commentOwnerAvatarUrl;
  final String commentOwnerUsername;
  final String commentBody;
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

  Comment({
    this.gigIdHoldingComment,
    this.gigOwnerId,
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
  });

  Map<String, dynamic> toMap() {
    return {
      'gigIdHoldingComment': gigIdHoldingComment,
      'gigOwnerId': gigOwnerId,
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
    };
  }

  static Comment fromMap(Map<String, dynamic> map, String documentId) {
    if (map == null) return null;

    return Comment(
      gigIdHoldingComment: map['gigIdHoldingComment'],
      gigOwnerId: map['gigOwnerId'],
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
    );
  }
}
