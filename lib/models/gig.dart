class Gig {
  final bool appointed;
  final String gigId;
  final String gigOwnerId;
  final String gigClientId;
  final String gigWorkerId;
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
  final String appointedUserId;
  final String appointedUsername;
  final List appliersOrHirersByUserId;
  final List gigRelatedUsersByUserId;
  final bool hidden;
  final bool paymentReleased;
  final bool markedAsComplete;
  final bool clientLeftReview;
  final List gigActions;
  final int likesCount;
  final List likersByUserId;
  final String gigLocationIndex;
  final String gigOwnerUsernameIndex;
  Gig({
    this.appointed = false,
    this.gigId,
    this.gigOwnerId,
    this.gigClientId,
    this.gigWorkerId,
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
    this.adultContentText,
    this.adultContentBool,
    this.appointedUserId,
    this.appointedUsername,
    this.appliersOrHirersByUserId,
    this.gigRelatedUsersByUserId,
    this.hidden = false,
    this.paymentReleased = false,
    this.markedAsComplete = false,
    this.clientLeftReview = false,
    this.gigActions,
    this.likesCount = 0,
    this.likersByUserId,
    this.gigLocationIndex,
    this.gigOwnerUsernameIndex,
  });

  Map<String, dynamic> toMap() {
    return {
      'appointed': appointed,
      'gigId': gigId,
      'gigOwnerId': gigOwnerId,
      'gigClientId': gigClientId,
      'gigWorkerId': gigWorkerId,
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
      'appointedUserId': appointedUserId,
      'appointedUsername': appointedUsername,
      'appliersOrHirersByUserId': [],
      'gigRelatedUsersByUserId': [],
      'hidden': hidden,
      'gigActions': [],
      'paymentReleased': paymentReleased,
      'markedAsComplete': markedAsComplete,
      'clientLeftReview': clientLeftReview,
      'likesCount': likesCount,
      'likersByUserId': [],
      'gigLocationIndex': gigLocationIndex,
      'gigOwnerUsernameIndex': gigOwnerUsernameIndex,
    };
  }

  static Gig fromMap(Map<String, dynamic> map, String documentId) {
    if (map == null) return null;

    return Gig(
      appointed: map['appointed'],
      gigId: map['gigId'],
      gigOwnerId: map['gigOwnerId'],
      gigClientId: map['gigClientId'],
      gigWorkerId: map['gigWorkerId'],
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
      appointedUserId: map['appointedUserId'],
      appointedUsername: map['appointedUsername'],
      appliersOrHirersByUserId: map['appliersOrHirersByUserId'],
      gigRelatedUsersByUserId: map['gigRelatedUsersByUserId'],
      hidden: map['hidden'],
      gigActions: map['gigActions'],
      paymentReleased: map['paymentReleased'],
      markedAsComplete: map['markedAsComplete'],
      clientLeftReview: map['clientLeftReview'],
      likesCount: map['likesCount'],
      likersByUserId: map['likersByUserId'],
      gigLocationIndex: map['gigLocationIndex'],
      gigOwnerUsernameIndex: map['gigOwnerUsernameIndex'],
    );
  }
}
