import 'package:Fyrework/models/comment.dart';
import 'package:Fyrework/models/gig.dart';
import 'package:Fyrework/models/myUser.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';

class RealTimeDatabase {
  final _rTDb = FirebaseDatabase.instance.reference();
  var _clientGeneratedid = Uuid().v1();

  // Create a new gig
  Future createNewGig({List gigHashtags, Gig gig}) async {
    try {
      DatabaseReference gigRef = _rTDb.child('gigs').push();
      await gigRef.set(gig.toMap(rTDbGigId: gigRef.key));
    } catch (e) {
      print('error is: $e');
      return e;
    }
  }

  // Add a new comment
  Future addComment({String parentGigId, Comment comment}) {
    try {
      return _rTDb.child('gigs').child(parentGigId).child('comments').update(
        {
          _clientGeneratedid: comment.toMap(
              parentGigId: parentGigId, clientGeneratedId: _clientGeneratedid),
        },
      );
    } catch (e) {
      print('error is: $e');
      return e;
    }
  }

  Future addLikeNotification({
    @required gigId,
    @required gigOwnerId,
    @required likerId,
    @required likerUsername,
    @required likerUserAvatarUrl,
  }) {
    if (likerId == gigOwnerId) {
      return null;
    } else {
      var gigOwnerRef = _rTDb.child('/users/$gigOwnerId');

      return gigOwnerRef.update({
        _clientGeneratedid: {
          "notificationId": "$_clientGeneratedid",
          "gigId": gigId,
          "userId": likerId,
          "username": likerUsername,
          "userAvatarUrl": likerUserAvatarUrl,
          "body": "$likerUsername liked your gig",
          "seen": false,
          "createdAt": DateTime.now().millisecondsSinceEpoch,
        }
      });
    }
  }

  Future addCommentNotification(
      {@required gigId,
      @required gigOwnerId,
      @required commenterId,
      @required commenterUsername,
      @required commenterUserAvatarUrl,
      @required commentBody}) {
    if (commenterId == gigOwnerId) {
      return null;
    } else {
      var gigOwnerRef = _rTDb.child('/users/$gigOwnerId');

      return gigOwnerRef.update({
        "$_clientGeneratedid": {
          "notificationId": "$_clientGeneratedid",
          "gigId": gigId,
          "userId": commenterId,
          "username": commenterUsername,
          "userAvatarUrl": commenterUserAvatarUrl,
          "body": "$commenterUsername commented on your gig",
          "seen": false,
          "createdAt": DateTime.now().millisecondsSinceEpoch,
        }
      });
    }
  }

  // marks a notification as seen
  Future markNotificationAsSeen({String myUserId, String notificationId}) {
    return _rTDb
        .child('/users/$myUserId/$notificationId')
        .update({'seen': true});
  }

  // fetch unseen notifications count
  Stream<Event> unseenNotificationsCount() {
    return _rTDb
        .child('/users/${MyUser.uid}')
        .orderByKey()
        // .limitToLast(10)
        .onValue
        .where((event) => event.snapshot.value['seen'] == false);
  }

  // change comment privacy
  Future changeCommentPrivacy(
      {@required String parentGigId,
      @required String commentId,
      @required bool isPrivateComment}) async {
    try {
      DatabaseReference _commentRef = _rTDb
          .child('gigs')
          .child(parentGigId)
          .child('comments')
          .child(commentId);
      return await _commentRef.update({'isPrivateComment': isPrivateComment});
    } catch (e) {
      return e;
    }
  }

  // set gigClient and gigWorker
  Future setGigClientAndGigWorker({
    @required String parentGigId,
    @required String parentGigClientId,
    @required String parentGigWorkerId,
  }) async {
    try {
      DatabaseReference _gigRef = _rTDb.child('gigs').child(parentGigId);
      return await _gigRef.update({
        'gigClientId': parentGigClientId,
        'gigWorkerId': parentGigWorkerId,
      });
    } catch (e) {
      if (e is PlatformException) {
        return e.message;
      }
    }
  }

  // Accept or reject proposal comment
  Future acceptOrRejectProposalComment(
      {String parentGigId, String commentId, bool approved, bool rejected}) {
    DatabaseReference _commentRef = _rTDb
        .child('gigs')
        .child(parentGigId)
        .child('comments')
        .child(commentId);

    return _commentRef.update({'approved': approved, 'rejected': rejected});
  }
}
