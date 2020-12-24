import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myApp/models/gig.dart';
import 'package:myApp/models/user.dart';
import 'package:myApp/ui/widgets/gig_item.dart';

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

  Future updateUserData(String uid, String name, String email, String password,
      String location, bool is_minor, dynamic ongoingGigsByGigId) async {
    return await _usersCollection.document(uid).setData({
      'user_ID': uid,
      'name': name,
      'email': email,
      'password': password,
      'location': location,
      'is_minor?': is_minor,
      'ongoingGigsByGigId': ongoingGigsByGigId,
    });
  }

  // user Data from snapshots
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
      uid: snapshot.data['user_ID'],
      name: snapshot.data['name'],
      email: snapshot.data['email'],
      ongoingGigsByGigId: snapshot.data['ongoingGigsByGigId'],
    );
  }

  // get user doc stream
  Stream<UserData> userData(String uid) {
    return _usersCollection
        .document(uid)
        .snapshots()
        .map(_userDataFromSnapshot);
  }

  Stream<QuerySnapshot> userOngoingGigsByGigOwnerId(String userId) {
    return _gigsCollection.where('gigOwnerId', isEqualTo: userId).snapshots();
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
}
