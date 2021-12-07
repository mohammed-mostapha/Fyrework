import 'package:Fyrework/models/myUser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:Fyrework/models/otherUser.dart';
import 'package:uuid/uuid.dart';

class RealTimeDatabase {
  final rTDB = FirebaseDatabase.instance.reference();
  var uuid = Uuid().v1();

  Future addLikeNotification({
    @required gigId,
    @required gigOwnerId,
    @required likerId,
    @required likerUsername,
    @required likerUserAvatarUrl,
  }) {
    if (likerId == gigOwnerId) {
      //
    } else {
      var gigOwnerRef = rTDB.child('/users/$gigOwnerId');

      gigOwnerRef.update({
        "$uuid": {
          "notificationId": "$uuid",
          "gigId": gigId,
          "likerId": likerId,
          "likerUsername": likerUsername,
          "likerUserAvatarUrl": likerUserAvatarUrl,
          "body": "$likerUsername liked your gig",
          "seen": false,
          "createdAt": DateTime.now().millisecondsSinceEpoch,
        }
      });
    }
  }

  // marks a notification as seen
  Future markNotificationAsSeen({String myUserId, String notificationId}) {
    return rTDB
        .child('/users/$myUserId/$notificationId')
        .update({'seen': true});
  }

  // fetch unseen notifications count
  Stream<Event> fetchUnseenCount() {
    return rTDB
        .child('/users/${MyUser.uid}')
        .orderByKey()
        .limitToLast(10)
        .onValue;
    // .where((event) => event.snapshot.value['seen'] == false);
  }
}
