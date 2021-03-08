class Gig {
  final bool appointed;
  final String gigId;
  final String gigOwnerId;
  final String gigOwnerAvatarUrl;
  final String gigOwnerUsername;
  dynamic createdAt;
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
  final bool hidden;
  Gig({
    this.appointed = false,
    this.gigId,
    this.gigOwnerId,
    this.gigOwnerAvatarUrl,
    this.gigOwnerUsername,
    this.createdAt,
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
    this.hidden,
  });

  Map<String, dynamic> toMap() {
    return {
      'appointed': appointed,
      'gigId': gigId,
      'gigOwnerId': gigOwnerId,
      'gigOwnerAvatarUrl': gigOwnerAvatarUrl,
      'gigOwnerUsername': gigOwnerUsername,
      'createdAt': createdAt,
      'gigOwnerLocation': gigOwnerLocation,
      'gigLocation': gigLocation,
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
      'appointedusername': appointedusername,
      'appliersOrHirersByUserId': [],
      'hidden': hidden,
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
      createdAt: map['createdAt'],
      gigOwnerLocation: map['gigOwnerLocation'],
      gigLocation: map['gigLocation'],
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
      appointedusername: map['appointedusername'],
      appliersOrHirersByUserId: map['appliersOrHirersByUserId'],
      hidden: map['hidden'],
    );
  }
}
