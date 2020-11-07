import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myApp/models/user.dart';

class DatabaseService {
  final String uid;

  DatabaseService({this.uid});
  //collection reference
  final CollectionReference usersCollection =
      Firestore.instance.collection('users');

  Future updateUserData(String uid, String name, String email, String password,
      String location, bool is_minor) async {
    return await usersCollection.document(uid).setData({
      'user_ID': uid,
      'name': name,
      'email': email,
      'password': password,
      'location': location,
      'is_minor?': is_minor
    });
  }

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
