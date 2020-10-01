import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myApp/models/brew.dart';
import 'package:myApp/models/user.dart';

class DatabaseService {
  final String uid;

  DatabaseService({this.uid});
  //collection reference
  final CollectionReference usersCollection =
      Firestore.instance.collection('users');

  Future updateUserData(
      String name, String email, String password, String location) async {
    return await usersCollection.document(uid).setData({
      'name': name,
      'email': email,
      'password': password,
      'location': location,
    });
  }

  // List<Brew> _brewListFromSnapshot(QuerySnapshot snapshot) {
  //   return snapshot.documents.map((doc) {
  //     return Brew(
  //       name: doc.data['name'] ?? '',
  //       strength: doc.data['strength'] ?? 0,
  //       sugars: doc.data['sugars'] ?? '0',
  //     );
  //   }).toList();
  // }

  // get brews stream
  // Stream<List<Brew>> get brews {
  //   return usersCollection.snapshots().map(_brewListFromSnapshot);
  // }

  // user Data from snapshots
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
      uid: uid,
      name: snapshot.data['name'],
    );
  }

  // get user doc stream
  Stream<UserData> get userData {
    return usersCollection.document(uid).snapshots().map(_userDataFromSnapshot);
  }
}
