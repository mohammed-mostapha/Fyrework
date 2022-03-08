import 'package:Fyrework/firebase_database/realtime_database.dart';
import 'package:Fyrework/locator.dart';
import 'package:Fyrework/models/gig.dart';
import 'package:Fyrework/services/navigation_service.dart';
import 'package:Fyrework/firebase_database/firestore_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class CreateGigViewModel {
  final FirestoreDatabase _firestoreService = locator<FirestoreDatabase>();
  final RealTimeDatabase _rTDB = locator<RealTimeDatabase>();
  final NavigationService _navigationService = locator<NavigationService>();

  // Future createGig({
  //   bool appointed,
  //   String gigId,
  //   @required String userId,
  //   @required String userProfilePictureDownloadUrl,
  //   @required String username,
  //   @required List gigHashtags,
  //   @required String userLocation,
  //   @required String gigLocation,
  //   @required List<String> gigMediaFilesDownloadUrls,
  //   @required String gigPost,
  //   @required dynamic gigDeadLine,
  //   @required String gigCurrency,
  //   @required dynamic gigBudget,
  //   @required String gigValue,
  //   String adultContentText,
  //   bool adultContentBool,
  // }) async {
  //   var gigAdded;

  //   gigAdded = await _firestoreService.createGig(
  //     gigHashtags,
  //     Gig(
  //       appointed: appointed,
  //       appliersOrHirersByUserId: [],
  //       likersByUserId: [],
  //       gigId: gigId,
  //       gigOwnerId: userId,
  //       gigClientId: '',
  //       gigWorkerId: '',
  //       gigOwnerAvatarUrl: userProfilePictureDownloadUrl,
  //       gigOwnerUsername:
  //           username.substring(0, 1).toUpperCase() + username.substring(1),
  //       createdAt: FieldValue.serverTimestamp(),
  //       gigHashtags: gigHashtags,
  //       gigOwnerLocation: userLocation,
  //       gigLocation: gigLocation.substring(0, 1).toUpperCase() +
  //           gigLocation.substring(1),
  //       gigMediaFilesDownloadUrls: gigMediaFilesDownloadUrls,
  //       gigPost: gigPost,
  //       gigDeadline: gigDeadLine,
  //       gigCurrency: gigCurrency,
  //       gigBudget: gigBudget,
  //       gigValue: gigValue,
  //       adultContentText: adultContentText,
  //       adultContentBool: adultContentBool,
  //       gigLocationIndex: gigLocation.substring(0, 1).toUpperCase(),
  //       gigOwnerUsernameIndex: username.substring(0, 1).toUpperCase(),
  //     ),
  //   );

  //   // if (gigAdded is String && updatedOngoingGigsByGigId is String) {
  //   if (gigAdded is String) {
  //     _navigationService.previewAllGigs();
  //   } else {
  //     print('error');
  //   }
  // }

  Future createGig({
    bool appointed,
    String gigId,
    @required String userId,
    @required String userProfilePictureDownloadUrl,
    @required String username,
    @required List gigHashtags,
    @required String userLocation,
    @required String gigLocation,
    @required List<String> gigMediaFilesDownloadUrls,
    @required String gigPost,
    @required dynamic gigDeadLine,
    @required String gigCurrency,
    @required dynamic gigBudget,
    @required String gigValue,
    String adultContentText,
    bool adultContentBool,
  }) async {
    print('error is: last gigDeadline: $gigDeadLine');
    print('error is: last gigDeadline: ${gigDeadLine.runtimeType}');
    var gigAdded;

    gigAdded = await _rTDB.createNewGig(
      gigHashtags: gigHashtags,
      gig: Gig(
        appointed: appointed,
        appliersOrHirersByUserId: [],
        likersByUserId: [],
        gigRelatedUsersByUserId: [],
        gigId: gigId,
        gigOwnerId: userId,
        gigClientId: '',
        gigWorkerId: '',
        gigOwnerAvatarUrl: userProfilePictureDownloadUrl,
        gigOwnerUsername:
            username.substring(0, 1).toUpperCase() + username.substring(1),
        createdAt: ServerValue.timestamp,
        gigHashtags: gigHashtags,
        gigOwnerLocation: userLocation,
        gigLocation: gigLocation.substring(0, 1).toUpperCase() +
            gigLocation.substring(1),
        gigMediaFilesDownloadUrls: gigMediaFilesDownloadUrls,
        gigPost: gigPost,
        gigDeadline: '$gigDeadLine',
        gigCurrency: gigCurrency,
        gigBudget: gigBudget,
        gigValue: gigValue,
        adultContentText: adultContentText,
        adultContentBool: adultContentBool,
        gigLocationIndex: gigLocation.substring(0, 1).toUpperCase(),
        gigOwnerUsernameIndex: username.substring(0, 1).toUpperCase(),
      ),
    );

    // if (gigAdded is String && updatedOngoingGigsByGigId is String) {
    if (gigAdded is String) {
      _navigationService.previewAllGigs();
    } else {
      print('error');
    }
  }

  Future createGigAsAdvert({
    bool appointed,
    String gigId,
    @required String userId,
    @required String userProfilePictureDownloadUrl,
    @required String username,
    @required List gigHashtags,
    @required String userLocation,
    @required String gigLocation,
    @required List<String> gigMediaFilesDownloadUrls,
    @required String gigPost,
    @required dynamic gigDeadLine,
    @required String gigCurrency,
    @required dynamic gigBudget,
    @required String gigValue,
    String adultContentText,
    bool adultContentBool,
  }) async {
    var gigAdded;

    gigAdded = await _firestoreService.createGig(
      gigHashtags,
      Gig(
        appliersOrHirersByUserId: [],
        appointed: appointed,
        likersByUserId: [],
        gigId: gigId,
        gigOwnerId: userId,
        gigOwnerAvatarUrl: userProfilePictureDownloadUrl,
        gigOwnerUsername:
            username.substring(0, 1).toUpperCase() + username.substring(1),
        gigClientId: '',
        gigWorkerId: '',
        createdAt: FieldValue.serverTimestamp(),
        gigHashtags: gigHashtags,
        gigOwnerLocation: userLocation,
        gigLocation: gigLocation.substring(0, 1).toUpperCase() +
            gigLocation.substring(1),
        gigMediaFilesDownloadUrls: gigMediaFilesDownloadUrls,
        gigPost: gigPost,
        gigDeadline: gigDeadLine,
        gigCurrency: gigCurrency,
        gigBudget: gigBudget,
        gigValue: gigValue,
        adultContentText: adultContentText,
        adultContentBool: adultContentBool,
        gigLocationIndex: gigLocation.substring(0, 1).toUpperCase(),
        gigOwnerUsernameIndex: username.substring(0, 1).toUpperCase(),
      ),
    );

    // if (gigAdded is String && updatedOngoingGigsByGigId is String) {
    if (gigAdded is String) {
      _navigationService.previewAllGigs();
    } else {
      print('error');
    }
  }
}
