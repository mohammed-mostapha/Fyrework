import 'package:Fyrework/models/gig.dart';
import 'package:Fyrework/models/myUser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

class RealTimeDatabase {
  final _rTDb = FirebaseDatabase.instance.reference();
  var _nUid = Uuid().v1();

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
        "$_nUid": {
          "notificationId": "$_nUid",
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
        "$_nUid": {
          "notificationId": "$_nUid",
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
  Stream<Event> fetchUnseenCount() {
    return _rTDb
        .child('/users/${MyUser.uid}')
        .orderByKey()
        // .limitToLast(10)
        .onValue
        .where((event) => event.snapshot.value['seen'] == false);
  }

  // Adding a new gig
  Future createNewGig({List gigHashtags, Gig gig}) async {
    try {
      DatabaseReference recordRef = _rTDb.child('gigs').push();
      await recordRef.set(gig.toMap(rTDbGigId: recordRef.key));
    } catch (e) {
      print('error is: $e');
    }
  }
}
