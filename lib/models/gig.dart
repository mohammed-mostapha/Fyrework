class Gig {
  final bool appointed;
  final String gigId;
  final String gigOwnerId;
  final String gigOwnerAvatarUrl;
  final String gigOwnerUsername;
  final String gigOwnerLocation;
  final String gigLocation;
  final List gigHashtags;
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
  final String appointedusername;
  final List appliersOrHirersByUserId;
  Gig({
    this.appointed = false,
    this.gigId,
    this.gigOwnerId,
    this.gigOwnerAvatarUrl,
    this.gigOwnerUsername,
    this.gigOwnerLocation,
    this.gigLocation,
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
    this.appointedusername,
    this.appliersOrHirersByUserId,
  });

  Map<String, dynamic> toMap() {
    return {
      'appointed': appointed,
      'gigId': gigId,
      'gigOwnerId': gigOwnerId,
      'gigOwnerAvatarUrl': gigOwnerAvatarUrl,
      'gigOwnerUsername': gigOwnerUsername,
      'gigOwnerLocation': gigOwnerLocation,
      'gigLocation': gigLocation,
      'gigHashtags': gigHashtags,
      'gigMediaFilesDownloadUrls': gigMediaFilesDownloadUrls,
      'gigPost': gigPost,
      'gigDeadlineInUnixMilliseconds': gigDeadline,
      'gigCurrency': gigCurrency,
      'gigBudget': gigBudget,
      'gigValue': gigValue,
      'adultContentText': adultContentText,
      'adultContentBool': adultContentBool,
      'gigLikes': gigLikes,
      'appointedUserId': appointedUserId,
      'appointedusername': appointedusername,
      'appliersOrHirersByUserId': appliersOrHirersByUserId,
    };
  }

  static Gig fromMap(Map<String, dynamic> map, String documentId) {
    if (map == null) return null;

    return Gig(
      appointed: map['appointed'],
      gigId: map['gigId'],
      gigOwnerId: map['gigOwnerId'],
      gigOwnerAvatarUrl: map['gigOwnerAvatarUrl'],
      gigOwnerUsername: map['gigOwnerUsername'],
      gigOwnerLocation: map['gigOwnerLocation'],
      gigLocation: map['gigLocation'],
      gigHashtags: map['gigHashtags'],
      gigMediaFilesDownloadUrls: map['gigMediaFilesDownloadUrls'],
      gigPost: map['gigPost'],
      gigDeadline: map['gigDeadlineInUnixMilliseconds'],
      gigCurrency: map['gigCurrency'],
      gigBudget: map['gigBudget'],
      gigValue: map['gigValue'],
      adultContentText: map['adultContentText'],
      adultContentBool: map['adultContentBool'],
      gigLikes: map['gigLikes'],
      appointedUserId: map['appointedUserId'],
      appointedusername: map['appointedusername'],
      appliersOrHirersByUserId: map['appliersOrHirersByUserId'],
    );
  }
}
