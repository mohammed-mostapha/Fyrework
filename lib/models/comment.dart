class Comment {
  final String gigIdHoldingComment;
  final String gigOwnerId;
  final String commentId;
  final String commentOwnerId;
  final String commentOwnerAvatarUrl;
  final String commentOwnerUsername;
  final String commentBody;
  dynamic commentTime;
  final bool isPrivateComment;
  final bool persistentPrivateComment;
  final bool proposal;
  final bool approved;
  final bool rejected;
  final String gigCurrency;
  final String offeredBudget;
  final String preferredPaymentMethod;

  Comment({
    this.gigIdHoldingComment,
    this.gigOwnerId,
    this.commentId,
    this.commentOwnerId,
    this.commentOwnerAvatarUrl,
    this.commentOwnerUsername,
    this.commentBody,
    this.commentTime,
    this.isPrivateComment,
    this.persistentPrivateComment,
    this.proposal,
    this.approved,
    this.rejected,
    this.gigCurrency,
    this.offeredBudget,
    this.preferredPaymentMethod,
  });

  Map<String, dynamic> toMap() {
    return {
      'gigIdHoldingComment': gigIdHoldingComment,
      // 'commentId': commentId + DateTime.now().millisecondsSinceEpoch.toString(),
      'gigOwnerId': gigOwnerId,
      'commentId': commentId,
      'commentOwnerId': commentOwnerId,
      'commentOwnerAvatarUrl': commentOwnerAvatarUrl,
      'commentOwnerUsername': commentOwnerUsername,
      'commentBody': commentBody,
      // 'commentTime': DateTime.now().millisecondsSinceEpoch.toString(),
      'commentTime': commentTime,
      'isPrivateComment': isPrivateComment,
      'persistentPrivateComment': persistentPrivateComment,
      'proposal': proposal,
      'approved': approved,
      'rejected': rejected,
      'gigCurrency': gigCurrency,
      'offeredBudget': offeredBudget,
      'preferredPaymentMethod': preferredPaymentMethod,
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
      commentTime: map['commentTime'],
      isPrivateComment: map['isPrivateComment'],
      persistentPrivateComment: map['persistentPrivateComment'],
      proposal: map['proposal'],
      approved: map['approved'],
      rejected: map['rejected'],
      gigCurrency: map['gigCurrency'],
      offeredBudget: map['offeredBudget'],
      preferredPaymentMethod: map['preferredPaymentMethod'],
    );
  }
}
