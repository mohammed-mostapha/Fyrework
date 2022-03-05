import 'package:flutter/material.dart';

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
  final List appliersOrHirersByUserId;
  final bool hidden;
  final bool markedAsComplete;
  final bool clientLeftReview;
  final List gigActions;
  final int likesCount;
  final List likersByUserId;
  final String gigLocationIndex;
  final String gigOwnerUsernameIndex;
  Gig({
    this.appointed = false,
    @required this.gigId,
    @required this.gigOwnerId,
    @required this.gigClientId,
    @required this.gigWorkerId,
    @required this.gigOwnerAvatarUrl,
    @required this.gigOwnerUsername,
    @required this.createdAt,
    @required this.gigOwnerLocation,
    @required this.gigLocation,
    @required this.gigHashtags,
    @required this.gigMediaFilesDownloadUrls,
    @required this.gigPost,
    @required this.gigDeadline,
    @required this.gigCurrency,
    @required this.gigBudget,
    @required this.gigValue,
    @required this.adultContentText,
    @required this.adultContentBool,
    @required this.appliersOrHirersByUserId,
    this.hidden = false,
    this.markedAsComplete = false,
    this.clientLeftReview = false,
    @required this.gigActions,
    this.likesCount = 0,
    @required this.likersByUserId,
    @required this.gigLocationIndex,
    @required this.gigOwnerUsernameIndex,
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
      'appliersOrHirersByUserId': [],
      'hidden': hidden,
      'gigActions': [],
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
      appliersOrHirersByUserId: map['appliersOrHirersByUserId'],
      hidden: map['hidden'],
      gigActions: map['gigActions'],
      markedAsComplete: map['markedAsComplete'],
      clientLeftReview: map['clientLeftReview'],
      likesCount: map['likesCount'],
      likersByUserId: map['likersByUserId'],
      gigLocationIndex: map['gigLocationIndex'],
      gigOwnerUsernameIndex: map['gigOwnerUsernameIndex'],
    );
  }
}
