import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class Gig {
  final String userId;
  final String userProfilePictureUrl;
  final String userFullName;
  final String gigHashtags;
  final String gigPost;
  final dynamic gigDeadline;
  final String gigCurrency;
  final dynamic gigBudget;
  String gigValue;
  final String adultContentText;
  final bool adultContentBool;
  final String imageUrl;
  final String documentId;
  Gig({
    this.userId,
    this.userProfilePictureUrl,
    this.userFullName,
    this.gigHashtags,
    this.gigPost,
    this.gigDeadline,
    this.gigCurrency,
    this.gigBudget,
    this.gigValue,
    this.adultContentText =
        'This is adult content that should not be visible to minors.',
    this.adultContentBool = false,
    this.documentId,
    this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userProfilePictureUrl': userProfilePictureUrl,
      'userFullName': userFullName,
      'gigHashtags': gigHashtags,
      'gigPost': gigPost,
      'gigDeadline': gigDeadline,
      'gigCurrency': gigCurrency,
      'gigBudget': gigBudget,
      'gigValue': gigValue,
      'adultContentText': adultContentText,
      'adultcontentBool': adultContentBool,
    };
  }

  static Gig fromMap(Map<String, dynamic> map, String documentId) {
    if (map == null) return null;

    return Gig(
      userId: map['userId'],
      userProfilePictureUrl: map['userProfilePictureUrl'],
      userFullName: map['userFullName'],
      gigHashtags: map['gigHashtags'],
      gigPost: map['gigPost'],
      gigDeadline: map['gigDeadline'],
      gigCurrency: map['gigCurrency'],
      gigBudget: map['gigBudget'],
      gigValue: map['gigValue'],
      adultContentText: map['adultContentText'],
      adultContentBool: map['adultContentBool'],
      documentId: documentId,
    );
  }
}
