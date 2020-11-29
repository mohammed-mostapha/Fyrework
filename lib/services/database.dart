import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myApp/models/user.dart';

class DatabaseService {
  final String uid;

  DatabaseService({this.uid});
  //collection reference
  final CollectionReference _usersCollection =
      Firestore.instance.collection('users');

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
      uid: uid,
      name: snapshot.data['name'],
      email: snapshot.data['email'],
      ongoingGigsByGigId: snapshot.data['ongoingGigsByGigId'.length],
    );
  }

  // get user doc stream
  Stream<UserData> get userData {
    return _usersCollection
        .document(uid)
        .snapshots()
        .map(_userDataFromSnapshot);
  }

  //add gigId to gigPoster ongoingGigsByGigId field in firebase
  // Future updateOngoingGigsByGigId(String uid, dynamic gigId) async {
  //   return await _usersCollection
  //       .document(uid)
  //       .updateData({"ongoingGigsByGigId": FieldValue.arrayUnion(gigId)});
  // }
  Future updateOngoingGigsByGigId(String uid, dynamic gigId) async {
    print('this is from the function uid: $uid');
    print('this is from the function gigId: $gigId');
    return await _usersCollection.document(uid).updateData({
      "ongoingGigsByGigId": FieldValue.arrayUnion([gigId])
    });
  }
}
