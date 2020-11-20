class Comment {
  final String gigIdHoldingComment;
  final String commentId;
  final String commentOwnerId;
  final String commentOwnerProfilePictureUrl;
  final String comentOwnerFullName;
  final String commentBody;

  Comment({
    this.gigIdHoldingComment,
    this.commentId,
    this.commentOwnerId,
    this.commentOwnerProfilePictureUrl,
    this.comentOwnerFullName,
    this.commentBody,
  });

  Map<String, dynamic> toMap() {
    return {
      'gigIdHoldingComment': gigIdHoldingComment,
      'commentId': commentId,
      'commentOwnerId':
          commentOwnerId + DateTime.now().millisecondsSinceEpoch.toString(),
      'commentOwnerProfilePicture': commentOwnerProfilePictureUrl,
      'comentOwnerFullName': comentOwnerFullName,
      'commentBody': commentBody,
    };
  }

  static Comment fromMap(Map<String, dynamic> map, String documentId) {
    if (map == null) return null;

    return Comment(
      gigIdHoldingComment: map['gigIdHoldingComment'],
      commentId: map['commentId'],
      commentOwnerId: map['commentOwnerId'],
      commentOwnerProfilePictureUrl: map['commentOwnerProfilePicture'],
      comentOwnerFullName: map['comentOwnerFullName'],
    );
  }
}
