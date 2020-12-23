class Gig {
  final bool appointed;
  final String gigId;
  final String gigOwnerId;
  final String userProfilePictureDownloadUrl;
  final String userFullName;
  final String gigHashtags;
  final dynamic gigMediaFilesDownloadUrls;
  final String gigPost;
  final dynamic gigDeadline;
  final String gigCurrency;
  final dynamic gigBudget;
  String gigValue;
  final String adultContentText;
  final bool adultContentBool;
  final int gigLikes;
  final String appointedUserId;
  final String appointedUserFullName;
  Gig({
    this.appointed,
    this.gigId,
    this.gigOwnerId,
    this.userProfilePictureDownloadUrl,
    this.userFullName,
    this.gigHashtags,
    this.gigMediaFilesDownloadUrls,
    this.gigPost,
    this.gigDeadline,
    this.gigCurrency,
    this.gigBudget,
    this.gigValue,
    this.gigLikes,
    this.adultContentText,
    this.adultContentBool,
    this.appointedUserId,
    this.appointedUserFullName,
  });

  Map<String, dynamic> toMap() {
    return {
      'appointed': appointed,
      'gigId': gigId,
      'gigOwnerId': gigOwnerId,
      'userProfilePictureDownloadUrl': userProfilePictureDownloadUrl,
      'userFullName': userFullName,
      'gigHashtags': gigHashtags,
      'gigMediaFilesDownloadUrls': gigMediaFilesDownloadUrls,
      'gigPost': gigPost,
      'gigDeadline': gigDeadline,
      'gigCurrency': gigCurrency,
      'gigBudget': gigBudget,
      'gigValue': gigValue,
      'adultContentText': adultContentText,
      'adultContentBool': adultContentBool,
      'gigLikes': gigLikes,
      'appointedUserId': appointedUserId,
      'appointedUserFullName': appointedUserFullName,
    };
  }

  static Gig fromMap(Map<String, dynamic> map, String documentId) {
    if (map == null) return null;

    return Gig(
      appointed: map['appointed'],
      gigId: map['gigId'],
      gigOwnerId: map['gigOwnerId'],
      userProfilePictureDownloadUrl: map['userProfilePictureDownloadUrl'],
      userFullName: map['userFullName'],
      gigHashtags: map['gigHashtags'],
      gigMediaFilesDownloadUrls: map['gigMediaFilesDownloadUrls'],
      gigPost: map['gigPost'],
      gigDeadline: map['gigDeadline'],
      gigCurrency: map['gigCurrency'],
      gigBudget: map['gigBudget'],
      gigValue: map['gigValue'],
      adultContentText: map['adultContentText'],
      adultContentBool: map['adultContentBool'],
      gigLikes: map['gigLikes'],
      appointedUserId: map['appointedUserId'],
      appointedUserFullName: map['appointedUserFullName'],
    );
  }
}
