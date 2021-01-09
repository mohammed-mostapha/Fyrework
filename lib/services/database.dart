import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myApp/models/myUser.dart';
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

  Future setUserData(
      String id,
      String name,
      String email,
      String password,
      String userAvatarUrl,
      String location,
      bool isMinor,
      dynamic ongoingGigsByGigId,
      int lengthOfOngoingGigsByGigId) async {
    return await _usersCollection.document(id).setData({
      'id': uid,
      'name': name,
      'email': email,
      'password': password,
      'userAvatarUrl': userAvatarUrl,
      'location': location,
      'isMinor?': isMinor,
      'ongoingGigsByGigId': ongoingGigsByGigId,
      'lengthOfOngoingGigsByGigId': lengthOfOngoingGigsByGigId,
    });
  }

  // user Data from snapshots
  OtherUser _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return OtherUser(
      uid: snapshot.data['Id'],
      name: snapshot.data['name'],
      email: snapshot.data['email'],
      userAvatarUrl: snapshot.data['userAvatarUrl'],
      userLocation: snapshot.data['userLocation'],
      isMinor: snapshot.data['isMinor'],
      location: snapshot.data['location'],
      ongoingGigsByGigId: snapshot.data['ongoingGigsByGigId'],
      lengthOfOngoingGigsByGigId: snapshot.data['lengthOfOngoingGigsByGigId'],
    );
  }

  // get user doc stream
  Stream<OtherUser> fetchUserData(String id) {
    print('print working in DB');
    return _usersCollection.document(id).snapshots().map(_userDataFromSnapshot);
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

  Future updateOngoingGigsByGigId(String uid, dynamic gigId) async {
    return await _usersCollection.document(uid).updateData({
      "ongoingGigsByGigId": FieldValue.arrayUnion([gigId])
    });
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
}
