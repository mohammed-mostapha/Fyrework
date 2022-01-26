import 'package:Fyrework/models/myUser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:Fyrework/models/otherUser.dart';

class DatabaseService {
  // final String uid;

  // DatabaseService({this.uid});
  //db reference
  FirebaseApp fyreworkApp = Firebase.app();

  //collection reference
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference _gigsCollection =
      FirebaseFirestore.instance.collection('gigs');
  final CollectionReference _commentsCollection =
      FirebaseFirestore.instance.collection('comments');
  final CollectionReference _popularHashtags =
      FirebaseFirestore.instance.collection('popularHashtags');
  final CollectionReference _takenHandles =
      FirebaseFirestore.instance.collection('takenHandles');
  final CollectionReference _notifications =
      FirebaseFirestore.instance.collection('notifications');

  Future setUserData({
    @required String id,
    @required List myFavoriteHashtags,
    @required String name,
    @required String handle,
    @required String email,
    @required String userAvatarUrl,
    @required String location,
    @required bool isMinor,
    @required List openGigsByGigId,
    @required List completedGigsByGigId,
  }) async {
    return await _usersCollection.doc(id).set({
      'id': id,
      'favoriteHashtags': FieldValue.arrayUnion(myFavoriteHashtags),
      'name': name,
      'username': handle,
      'email': email,
      'userAvatarUrl': userAvatarUrl,
      'location': location,
      'phoneNumber': null,
      'isMinor?': isMinor,
      'openGigsByGigId': openGigsByGigId,
      'completedGigsByGigId': completedGigsByGigId,
    }).then(
      (value) => _usersCollection
          .doc(id)
          .collection('userRating')
          .doc(id)
          .set({'userRating': 0}),
    );
  }

  // user Data from snapshots
  OtherUser _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return OtherUser(
      uid: snapshot.data()['Id'],
      favoriteHashtags: snapshot.data()['favoriteHashtags'],
      name: snapshot.data()['name'],
      username: snapshot.data()['username'],
      email: snapshot.data()['email'],
      userAvatarUrl: snapshot.data()['userAvatarUrl'],
      userLocation: snapshot.data()['userLocation'],
      isMinor: snapshot.data()['isMinor'],
      location: snapshot.data()['location'],
      phoneNumber: snapshot.data()['phoneNumber'],
      openGigsByGigId: snapshot.data()['openGigsByGigId'],
      completedGigsByGigId: snapshot.data()['completedGigsByGigId'],
    );
  }

  Future<QuerySnapshot> fetchUserRating({@required String userId}) {
    return _usersCollection.doc(userId).collection('userRating').get();
  }

  // get user doc stream
  Stream<OtherUser> fetchUserData({String userId}) {
    return _usersCollection.doc(userId).snapshots().map(_userDataFromSnapshot);
  }

  // fetch users in search by query(username)
  Stream<QuerySnapshot> fetchUsersInSearch() {
    return _usersCollection.snapshots();
  }

  // filter all gigs
  Stream<QuerySnapshot> filterAllGigs(String query) {
    return query.isEmpty
        ? _gigsCollection
            .where('hidden', isEqualTo: false)
            .orderBy('createdAt', descending: true)
            .snapshots()
        : _gigsCollection
            .where('hidden', isEqualTo: false)
            .where('gigHashtags', arrayContains: query)
            .orderBy('createdAt', descending: true)
            .snapshots();
  }

  // filter client gigs
  Stream<QuerySnapshot> filterCilentGigs(String query) {
    if (query.isEmpty) {
      return _gigsCollection
          .where('hidden', isEqualTo: false)
          .where('gigValue', isEqualTo: 'I need a provider')
          .orderBy('createdAt', descending: true)
          .snapshots();
    } else {
      return _gigsCollection
          .where('hidden', isEqualTo: false)
          .where(
            'gigLocationIndex',
            isEqualTo: query.substring(0, 1).toUpperCase(),
          )
          .snapshots();
    }
  }

  // filter provider gigs
  Stream<QuerySnapshot> filterProviderGigs(String query) {
    return query.isEmpty
        ? _gigsCollection
            .where('hidden', isEqualTo: false)
            .where('gigValue', isEqualTo: 'Gig i can do')
            .orderBy('createdAt', descending: true)
            .snapshots()
        : _gigsCollection
            .where('hidden', isEqualTo: false)
            .where(
              'gigOwnerUsernameIndex',
              isEqualTo: query.substring(0, 1).toUpperCase(),
            )
            .snapshots();
  }

  Future<QuerySnapshot> fetchOrCreateGigsForAdverts(
      String receivedAdvertHashtag) {
    print('count me receivedHashtag: $receivedAdvertHashtag');
    print('count me');
    return _gigsCollection
        .where('hidden', isEqualTo: false)
        .where('gigHashtags', arrayContains: receivedAdvertHashtag)
        .orderBy('createdAt', descending: true)
        .get();
  }

  Future<QuerySnapshot> fetchGigsByOwnerId({String userId}) async {
    await Future.delayed(Duration(milliseconds: 1000));
    return _gigsCollection
        .where('hidden', isEqualTo: false)
        .where('gigOwnerId', isEqualTo: userId)
        .get();
  }

  Stream<QuerySnapshot> openGigsByGigRelatedUsers({String userId}) {
    return _gigsCollection
        .where('hidden', isEqualTo: false)
        .where('gigRelatedUsersByUserId', arrayContains: userId)
        .where('markedAsComplete', isEqualTo: false)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> completedGigsByGigRelatedUsers({String userId}) {
    return _gigsCollection
        .where('hidden', isEqualTo: false)
        .where('gigRelatedUsersByUserId', arrayContains: userId)
        .where('markedAsComplete', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> likedGigsByLikersByUserId({String userId}) {
    return _gigsCollection
        .where('hidden', isEqualTo: false)
        .where('likersByUserId', arrayContains: userId)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> gigRelatedComments(String gigIdCommentsIdentifier) {
    return _commentsCollection
        .where('gigIdHoldingComment', isEqualTo: gigIdCommentsIdentifier)
        .orderBy('createdAt', descending: false)
        .snapshots();
  }

  // Stream<QuerySnapshot> unseenNotificationsCount() {
  //   return _notifications
  //       .where('seen', isEqualTo: false)
  //       .orderBy('createdAt', descending: true)
  //       .snapshots();
  // }

  Stream<QuerySnapshot> fetchAllNotifications() {
    return _notifications.orderBy('createdAt', descending: true).snapshots();
  }

  // Future markNotificationAsSeen({String notificationId}) {
  //   return _notifications.doc(notificationId).update({
  //     'seen': true,
  //   });
  // }

  Stream<QuerySnapshot> fetchIndividualGig({@required String gigId}) {
    return _gigsCollection.where('gigId', isEqualTo: gigId).snapshots();
  }

  //update profile picture only
  Future updateMyAvatar({
    String uid,
    String updatedProfileAvatar,
  }) async {
    try {
      return await _usersCollection.doc(uid).update(
        <String, dynamic>{
          'userAvatarUrl': updatedProfileAvatar,
        },
      );
    } catch (e) {
      if (e is PlatformException) {
        print(e.message);
        return e.message;
      }
    }
    print('updated your avatar');
  }
  // end update profile picture only

  //update my gig by gigId
  Future updateMyGigByGigId({
    @required String gigId,
    String editedGigLocation,
    DateTime editedGigDeadline,
    String editedGigCurrency,
    String editedGigBudget,
    List editedFavoriteHashtags,
    String editedGigPost,
  }) async {
    try {
      return await _gigsCollection.doc(gigId).update(<String, dynamic>{
        'gigLocation': editedGigLocation,
        'gigDeadlineInUnixMilliseconds': editedGigDeadline != null
            ? editedGigDeadline.millisecondsSinceEpoch
            : null,
        'gigCurrency': editedGigCurrency,
        'gigBudget': editedGigBudget,
        'gigHashtags': editedFavoriteHashtags,
        'gigPost': editedGigPost,
      });
    } catch (e) {
      if (e is PlatformException) {
        print(e.message);
        return e.message;
      }
    }
  }

  //end update my gig by gigId
  Future deleteMyGigByGigId({
    @required String gigId,
  }) async {
    try {
      await _usersCollection.doc(MyUser.uid).update(<String, dynamic>{
        'openGigsByGigId': FieldValue.arrayRemove([gigId])
      });

      await _usersCollection.doc(MyUser.uid).update(<String, dynamic>{
        'deletedGigsByGigId': FieldValue.arrayUnion([gigId])
      });

      await _gigsCollection.doc(gigId).update(<String, dynamic>{
        'hidden': true,
      });
    } catch (e) {
      if (e is PlatformException) {
        print(e.message);
        return e.message;
      }
    }
  }

  Future updateMyProfileData({
    String uid,
    String myNewAvatar,
    List<String> myNewFavoriteHashtag,
    String myNewUsername,
    String myNewName,
    String myNewEmailaddress,
    String myNewLocation,
    String myNewPhoneNumber,
  }) async {
    try {
      return await _usersCollection.doc(uid).update(<String, dynamic>{
        'userAvatarUrl': myNewAvatar,
        'favoriteHashtags': myNewFavoriteHashtag,
        'username': myNewUsername,
        'name': myNewName,
        'email': myNewEmailaddress,
        'location': myNewLocation,
        'phoneNumber': myNewPhoneNumber,
      });
    } catch (e) {
      if (e is PlatformException) {
        print(e.message);
        return e.message;
      }
    }
  }

  Future updateOpenGigsByGigId({String userId, String gigId}) async {
    return await _usersCollection.doc(userId).update({
      "openGigsByGigId": FieldValue.arrayUnion([gigId]),
    });
  }

  Future addUserIdToGigRelatedUsersArray({String gigId, String userId}) async {
    return await _gigsCollection.doc(gigId).update({
      'gigRelatedUsersByUserId': FieldValue.arrayUnion([userId]),
    });
  }

  //add user favorite hashtags to popular hashtags collection
  Future addToPopularHashtags(List favoriteHashtags) async {
    QuerySnapshot querySnapshot = await _popularHashtags.get();
    List allPopularHashtags =
        querySnapshot.docs.map((doc) => doc.data()['hashtag']).toList();
    for (String favoriteHashtag in favoriteHashtags) {
      if (!allPopularHashtags.contains(favoriteHashtag)) {
        _popularHashtags.add({'hashtag': favoriteHashtag});
      }
    }
  }

  //fetch popular hashtags
  Future fetchPopularHashtags(String query) async {
    List filteredHashtags = List();
    QuerySnapshot querySnapshot = await _popularHashtags.get();
    List fetchedHashtags =
        querySnapshot.docs.map((doc) => doc.data()['hashtag']).toList();
    fetchedHashtags.forEach((element) {
      if (element.contains(query)) {
        filteredHashtags.add(element);
      }
    });
    return filteredHashtags.toList();
  }

  //add handle to  takenHandles collection
  Future addToTakenHandles(String username) async {
    _takenHandles.add({'takenHandle': username});
  }

  //fetch taken Handles
  Future fetchTakenHandles(String query) async {
    List filteredTakenHandles = List();
    QuerySnapshot querySnapshot = await _takenHandles.get();
    List takenHandles =
        querySnapshot.docs.map((doc) => doc.data()['takenHandle']).toList();
    takenHandles.forEach((element) {
      if (element.contains(query)) {
        filteredTakenHandles.add(element);
      }
    });
    return filteredTakenHandles.toList();
  }

// Add Gig Actions
  Future addGigWorkstreamActions({
    @required String gigId,
    @required String action,
    @required userAvatarUrl,
    @required gigActionOwner,
  }) async {
    return await _gigsCollection.doc(gigId).collection('gigActions').add({
      "gigAction": action,
      "userAvatarUrl": userAvatarUrl,
      "createdAt": FieldValue.serverTimestamp(),
      "gigActionOwner": gigActionOwner
    });

    // updateData({
    //   "gigActions": FieldValue.arrayUnion([action, userAvatarUrl]),
    // });
  }

  //converting open gigs to completed gigs for both gigOwner & appointedUser
  Future convertOpenGigToCompletedGig({
    @required String gigId,
    @required String gigOwnerId,
    @required String appointedUserId,
  }) async {
    FirebaseFirestore db = FirebaseFirestore.instanceFor(app: fyreworkApp);
    var batch = db.batch();

    // for the gig
    batch.update(_gigsCollection.doc(gigId), {
      'markedAsComplete': true,
    });

    //for the gigOwner
    batch.update(_usersCollection.doc(gigOwnerId), {
      'openGigsByGigId': FieldValue.arrayRemove([gigId]),
      'completedGigsByGigId': FieldValue.arrayUnion([gigId]),
    });

    //for the appointedUser
    batch.update(_usersCollection.doc(appointedUserId), {
      'openGigsByGigId': FieldValue.arrayRemove([gigId]),
      'completedGigsByGigId': FieldValue.arrayUnion([gigId]),
    });

    //execute batch writes
    batch.commit();
  }

  Future addRatingToUser({
    @required String userId,
    @required String gigId,
    @required int userRating,
  }) async {
    return await _usersCollection.doc(userId).collection('userRating').add({
      'gigId': gigId,
      'userRating': userRating,
    });
  }

  Future updateCommentRatingCount(
      {@required String commentId, @required int ratingCount}) async {
    return await _commentsCollection.doc(commentId).update({
      'ratingCount': ratingCount,
    });
  }

  Future updateLeftReviewFieldToTrue(
      {@required String commentId, @required String review}) async {
    return await _commentsCollection
        .doc(commentId)
        .update({'leftReview': true, 'commentBody': review});
  }

  // show gig actions
  Stream<QuerySnapshot> showGigWorkstreamActions({@required String gigId}) {
    return _gigsCollection
        .doc(gigId)
        .collection('gigActions')
        .orderBy('createdAt', descending: false)
        .snapshots();
  }

  Future<DocumentSnapshot> fetchAppointedUserData(
      {@required String gigId}) async {
    DocumentSnapshot appointedUser = await _gigsCollection.doc(gigId).get();
    return appointedUser;
  }
}
