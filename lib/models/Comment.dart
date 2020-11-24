class Comment {
  final String gigIdHoldingComment;
  final String commentId;
  final String commentOwnerId;
  final String commentOwnerProfilePictureUrl;
  final String commentOwnerFullName;
  final String commentBody;
  dynamic commentTime;

  Comment({
    this.gigIdHoldingComment,
    this.commentId,
    this.commentOwnerId,
    this.commentOwnerProfilePictureUrl,
    this.commentOwnerFullName,
    this.commentBody,
    this.commentTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'gigIdHoldingComment': gigIdHoldingComment,
      // 'commentId': commentId + DateTime.now().millisecondsSinceEpoch.toString(),
      'commentId': commentId,
      'commentOwnerId': commentOwnerId,
      'commentOwnerProfilePictureUrl': commentOwnerProfilePictureUrl,
      'commentOwnerFullName': commentOwnerFullName,
      'commentBody': commentBody,
      // 'commentTime': DateTime.now().millisecondsSinceEpoch.toString(),
      'commentTime': commentTime,
    };
  }

  static Comment fromMap(Map<String, dynamic> map, String documentId) {
    if (map == null) return null;

    return Comment(
      gigIdHoldingComment: map['gigIdHoldingComment'],
      commentId: map['commentId'],
      commentOwnerId: map['commentOwnerId'],
      commentOwnerProfilePictureUrl: map['commentOwnerProfilePictureUrl'],
      commentOwnerFullName: map['commentOwnerFullName'],
      commentBody: map['commentBody'],
      commentTime: map['commentTime'],
    );
  }
}
