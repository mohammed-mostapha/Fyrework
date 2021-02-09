import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:myApp/models/otherUser.dart';

class DatabaseService {
  final String uid;

  DatabaseService({this.uid});
  //collection reference
  final CollectionReference _usersCollection =
      Firestore.instance.collection('users');
  final CollectionReference _gigsCollection =
      Firestore.instance.collection('gigs');
  final CollectionReference _commentsCollection =
      Firestore.instance.collection('comments');
  final CollectionReference _popularHashtags =
      Firestore.instance.collection('popularHashtags');
  final CollectionReference _takenHandles =
      Firestore.instance.collection('takenHandles');

  Future setUserData(
    String id,
    List myFavoriteHashtags,
    String name,
    String username,
    String email,
    String password,
    String userAvatarUrl,
    String location,
    bool isMinor,
    dynamic ongoingGigsByGigId,
    int lengthOfOngoingGigsByGigId,
  ) async {
    return await _usersCollection.document(id).setData({
      'id': uid,
      'favoriteHashtags': FieldValue.arrayUnion(myFavoriteHashtags),
      'name': name,
      'username': username,
      'email': email,
      // 'password': password,
      'userAvatarUrl': userAvatarUrl,
      'location': location,
      'phoneNumber': null,
      'isMinor?': isMinor,
      'ongoingGigsByGigId': ongoingGigsByGigId,
      'lengthOfOngoingGigsByGigId': lengthOfOngoingGigsByGigId,
    });
  }

  // user Data from snapshots
  OtherUser _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return OtherUser(
      uid: snapshot.data['Id'],
      favoriteHashtags: snapshot.data['favoriteHashtags'],
      name: snapshot.data['name'],
      username: snapshot.data['username'],
      email: snapshot.data['email'],
      userAvatarUrl: snapshot.data['userAvatarUrl'],
      userLocation: snapshot.data['userLocation'],
      isMinor: snapshot.data['isMinor'],
      location: snapshot.data['location'],
      phoneNumber: snapshot.data['phoneNumber'],
      ongoingGigsByGigId: snapshot.data['ongoingGigsByGigId'],
      lengthOfOngoingGigsByGigId: snapshot.data['lengthOfOngoingGigsByGigId'],
    );
  }

  // get user doc stream
  Stream<OtherUser> fetchUserData(String id) {
    return _usersCollection.document(id).snapshots().map(_userDataFromSnapshot);
  }

  // fetch users in search by query(username)
  Stream<QuerySnapshot> fetchUsersInSearch() {
    return _usersCollection.snapshots();
  }

  //fetch users by favoriteHashtags
  Stream<QuerySnapshot> fetchUsersInSearchByFavoriteHashtags(query) {
    return _usersCollection
        .where('favoriteHashtags', arrayContains: query)
        .snapshots();
  }

  // listening to all gigs
  Stream<QuerySnapshot> listenToAllGigs() {
    return _gigsCollection.snapshots();
  }

  // listening to client gigs
  Stream<QuerySnapshot> listenToCilentGigs() {
    return _gigsCollection
        .where('gigValue', isEqualTo: 'I need a provider')
        .snapshots();
  }

  // listening to provider gigs
  Stream<QuerySnapshot> listenToProviderGigs() {
    return _gigsCollection
        .where('gigValue', isEqualTo: 'Gig I can do')
        .snapshots();
  }

  Stream<QuerySnapshot> userOngoingGigsByGigOwnerId(String userId) {
    return _gigsCollection.where('gigOwnerId', isEqualTo: userId).snapshots();
  }

  Future<QuerySnapshot> myOngoingGigsByGigOwnerId(String userId) {
    return _gigsCollection
        .where('gigOwnerId', isEqualTo: userId)
        .getDocuments();
  }

  Stream<QuerySnapshot> userOngoingGigsByAppointedUserId(String userId) {
    return _gigsCollection
        .where('appointedUserId', isEqualTo: userId)
        .snapshots();
  }

  Stream<QuerySnapshot> gigRelatedComments(String gigIdCommentsIdentifier) {
    return _commentsCollection
        .where('gigIdHoldingComment', isEqualTo: gigIdCommentsIdentifier)
        .snapshots();
  }

  //update profile picture only
  Future updateMyProfilePicture(
    String uid,
    String updatedProfileAvatar,
  ) async {
    try {
      return await _usersCollection.document(uid).updateData(
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

  Future updateMyProfileData(
    String uid,
    String myNewHashtag,
    String myNewUsername,
    String myNewName,
    String myNewEmailaddress,
    String myNewLocation,
    String myNewPhoneNumber,
  ) async {
    try {
      return await _usersCollection.document(uid).updateData(<String, dynamic>{
        'hashtag': myNewHashtag,
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

  Future updateOngoingGigsByGigId(String uid, dynamic gigId) async {
    return await _usersCollection.document(uid).updateData({
      "ongoingGigsByGigId": FieldValue.arrayUnion([gigId])
    });
  }

  //add user favorite hashtags to popular hashtags collection
  Future addToPopularHashtags(List favoriteHashtags) async {
    for (String favoriteHashtag in favoriteHashtags) {
      _popularHashtags.add({'hashtag': favoriteHashtag});
    }
  }

  //fetch popular hashtags
  Future fetchPopularHashtags(String query) async {
    List filteredHashtags = List();
    QuerySnapshot querySnapshot = await _popularHashtags.getDocuments();
    List fetchedHashtags =
        querySnapshot.documents.map((doc) => doc.data['hashtag']).toList();
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
    QuerySnapshot querySnapshot = await _takenHandles.getDocuments();
    List takenHandles =
        querySnapshot.documents.map((doc) => doc.data['takenHandle']).toList();
    takenHandles.forEach((element) {
      if (element.contains(query)) {
        filteredTakenHandles.add(element);
      }
    });
    return filteredTakenHandles.toList();
  }

//    Future deleteGig(int index) async {
//     var dialogResponse = await _dialogService.showConfirmationDialog(
//       title: 'Are you sure?',
//       description: 'Do you really want to delete this gig?',
//       confirmationTitle: 'Yes',
//       cancelTitle: 'No',
//     );
//     if (dialogResponse.confirmed) {
//       await _firestoreService.deleteGig(_gigs[index].gigId);
//     }
//   }

//   Future navigateToCreateView() async {
//     await _navigationService.navigateTo(CreateGigViewRoute);
//   }

//   void editGig(int index) {
//     _navigationService.navigateTo(CreateGigViewRoute, arguments: _gigs[index]);
//   }
// }
}
