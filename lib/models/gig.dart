import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class Gig {
  final String documentId;
  final String userId;
  final String userProfilePictureUrl;
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
  Gig({
    this.documentId,
    this.userId,
    this.userProfilePictureUrl,
    this.userFullName,
    this.gigHashtags,
    this.gigMediaFilesDownloadUrls,
    this.gigPost,
    this.gigDeadline,
    this.gigCurrency,
    this.gigBudget,
    this.gigValue,
    this.adultContentText,
    this.adultContentBool,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userProfilePictureUrl': userProfilePictureUrl,
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
    };
  }

  static Gig fromMap(Map<String, dynamic> map, String documentId) {
    if (map == null) return null;

    return Gig(
      userId: map['userId'],
      userProfilePictureUrl: map['userProfilePictureUrl'],
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
      documentId: documentId,
    );
  }
}
