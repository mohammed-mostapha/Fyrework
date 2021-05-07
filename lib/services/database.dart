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
    @required int lengthOfOpenGigsByGigId,
    @required List completedGigsByGigId,
    @required int lengthOfCompletedGigsByGigId,
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
      'lengthOfOpenGigsByGigId': lengthOfOpenGigsByGigId,
      'completedGigsByGigId': completedGigsByGigId,
      'lengthOfCompletedGigsByGigId': lengthOfCompletedGigsByGigId,
    }).then(
      (value) => _usersCollection
          .doc(id)
          .collection('userRating')
          .doc(id)
          .set({'thisUserId': id}),
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
      lengthOfOpenGigsByGigId: snapshot.data()['lengthOfOpenGigsByGigId'],
      completedGigsByGigId: snapshot.data()['completedGigsByGigId'],
      lengthOfCompletedGigsByGigId:
          snapshot.data()['lengthOfCompletedGigsByGigId'],
    );
  }

  Future<QuerySnapshot> fetchUserRating({@required String userId}) {
    return _usersCollection.doc(userId).collection('userRating').get();
  }

  // get user doc stream
  Stream<OtherUser> fetchUserData(String id) {
    return _usersCollection.doc(id).snapshots().map(_userDataFromSnapshot);
  }

  // fetch users in search by query(username)
  Stream<QuerySnapshot> fetchUsersInSearch() {
    return _usersCollection.snapshots();
  }

  // filter all gigs
  Stream<QuerySnapshot> filterAllGigs(String query) {
    return query.isEmpty
        ? _gigsCollection.orderBy('createdAt', descending: true).snapshots()
        : _gigsCollection
            .where('hidden', isEqualTo: false)
            .where('gigHashtags', arrayContains: query)
            .orderBy('createdAt', descending: true)
            .snapshots();
  }

  // listening to client gigs
  Stream<QuerySnapshot> listenToCilentGigs() {
    return _gigsCollection
        .where('gigValue', isEqualTo: 'I need a provider')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // listening to provider gigs
  Stream<QuerySnapshot> listenToProviderGigs() {
    return _gigsCollection
        .where('gigValue', isEqualTo: 'Gig I can do')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  //fetch an individual gig
  Stream<DocumentSnapshot> listenToAnIndividualGig(gigId) {
    // return _gigsCollection.where('gigId', isEqualTo: gigId).snapshots();
    return _gigsCollection.doc(gigId).snapshots();
  }

  Stream<QuerySnapshot> userOpenGigsByGigOwnerId(String userId) {
    return _gigsCollection.where('gigOwnerId', isEqualTo: userId).snapshots();
  }

  Future<QuerySnapshot> myOpenGigsByGigOwnerId(String userId) {
    return _gigsCollection.where('gigOwnerId', isEqualTo: userId).get();
  }

  Stream<QuerySnapshot> userOpenGigsByAppointedUserId(String userId) {
    return _gigsCollection
        .where('appointedUserId', isEqualTo: userId)
        .snapshots();
  }

  Stream<QuerySnapshot> gigRelatedComments(String gigIdCommentsIdentifier) {
    return _commentsCollection
        .where('gigIdHoldingComment', isEqualTo: gigIdCommentsIdentifier)
        .orderBy('createdAt', descending: false)
        .snapshots();
  }

  //update profile picture only
  Future updateMyProfilePicture(
    String uid,
    String updatedProfileAvatar,
  ) async {
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
      return await _gigsCollection.doc(gigId).update(<String, dynamic>{
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
    List<String> myNewFavoriteHashtag,
    String myNewUsername,
    String myNewName,
    String myNewEmailaddress,
    String myNewLocation,
    String myNewPhoneNumber,
  }) async {
    try {
      return await _usersCollection.doc(uid).update(<String, dynamic>{
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

  Future updateOpenGigsByGigId(String uid, String gigId) async {
    return await _usersCollection.doc(uid).update({
      "openGigsByGigId": FieldValue.arrayUnion(
        [gigId],
      ),
      "lengthOfOpenGigsByGigId": FieldValue.increment(1),
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

    //for the gigOwner
    batch.update(_usersCollection.doc(gigOwnerId), {
      'openGigsByGigId': FieldValue.arrayRemove([gigId]),
      'lengthOfOpenGigsByGigId': FieldValue.increment(-1),
      'completedGigsByGigId': FieldValue.arrayUnion([gigId]),
      'lengthOfCompletedGigsByGigId': FieldValue.increment(1),
    });

    //for the appointedUser
    batch.update(_usersCollection.doc(appointedUserId), {
      'openGigsByGigId': FieldValue.arrayRemove([gigId]),
      'lengthOfOpenGigsByGigId': FieldValue.increment(-1),
      'completedGigsByGigId': FieldValue.arrayUnion([gigId]),
      'lengthOfCompletedGigsByGigId': FieldValue.increment(1),
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
