class Comment {
  final String gigIdHoldingComment;
  final String gigOwnerId;
  final String commentId;
  final String commentOwnerId;
  final String commentOwnerProfilePictureUrl;
  final String commentOwnerFullName;
  final String commentBody;
  dynamic commentTime;
  final bool privateComment;
  final bool proposal;
  final bool approved;
  final String appointedUserId;
  final String appointedUserFullName;
  final String gigCurrency;
  final String offeredBudget;

  Comment({
    this.gigIdHoldingComment,
    this.gigOwnerId,
    this.commentId,
    this.commentOwnerId,
    this.commentOwnerProfilePictureUrl,
    this.commentOwnerFullName,
    this.commentBody,
    this.commentTime,
    this.privateComment,
    this.proposal,
    this.approved,
    this.appointedUserId,
    this.appointedUserFullName,
    this.gigCurrency,
    this.offeredBudget,
  });

  Map<String, dynamic> toMap() {
    return {
      'gigIdHoldingComment': gigIdHoldingComment,
      // 'commentId': commentId + DateTime.now().millisecondsSinceEpoch.toString(),
      'gigOwnerId': gigOwnerId,
      'commentId': commentId,
      'commentOwnerId': commentOwnerId,
      'commentOwnerProfilePictureUrl': commentOwnerProfilePictureUrl,
      'commentOwnerFullName': commentOwnerFullName,
      'commentBody': commentBody,
      // 'commentTime': DateTime.now().millisecondsSinceEpoch.toString(),
      'commentTime': commentTime,
      'privateComment': privateComment,
      'proposal': proposal,
      'approved': approved,
      'gigCurrency': gigCurrency,
      'offeredBudget': offeredBudget,
      'appointedUserId': appointedUserId,
      'appointedUserFullName': appointedUserFullName,
    };
  }

  static Comment fromMap(Map<String, dynamic> map, String documentId) {
    if (map == null) return null;

    return Comment(
      gigIdHoldingComment: map['gigIdHoldingComment'],
      gigOwnerId: map['gigOwnerId'],
      commentId: map['commentId'],
      commentOwnerId: map['commentOwnerId'],
      commentOwnerProfilePictureUrl: map['commentOwnerProfilePictureUrl'],
      commentOwnerFullName: map['commentOwnerFullName'],
      commentBody: map['commentBody'],
      commentTime: map['commentTime'],
      privateComment: map['privateComment'],
      proposal: map['proposal'],
      approved: map['approved'],
      gigCurrency: map['gigCurrency'],
      offeredBudget: map['offeredBudget'],
      appointedUserId: map['appointedUserId'],
      appointedUserFullName: map['appointedUserFullName'],
    );
  }
}
