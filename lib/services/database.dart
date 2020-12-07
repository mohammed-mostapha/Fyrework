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

  // user's gigs from snapshots
  // GigItem _userGigsFromSnapshot(QuerySnapshot snapshot) {
  //   return GigItem(
  //     gigId: snapshot.data['gigId'],
  //     gigOwnerId: snapshot.data['gigOwnerId'],
  //     userProfilePictureDownloadUrl:
  //         snapshot.data['userProfilePictureDownloadUrl'],
  //     userFullName: snapshot.data['userFullName'],
  //     gigHashtags: snapshot.data['gigHashtags'],
  //     gigMediaFilesDownloadUrls: snapshot.data['gigMediaFilesDownloadUrls'],
  //     gigPost: snapshot.data['gigPost'],
  //     gigDeadline: snapshot.data['gigDeadline'],
  //     gigCurrency: snapshot.data['gigCurrency'],
  //     gigBudget: snapshot.data['gigBudget'],
  //     gigValue: snapshot.data['gigValue'],
  //     gigLikes: snapshot.data['gigLikes'],
  //     adultContentText: snapshot.data['adultContentText'],
  //     adultContentBool: snapshot.data['adultContentBool'],
  //     // onDeleteItem: () => model.deleteGig(index),
  //   );
  // }

  // get user's ongoing gigs
  // Future<List<GigItem>> userOngoingGigs(String userId) async {
  Stream<QuerySnapshot> userOngoingGigs(String userId) {
    // return _gigsCollection.document(uid).snapshots().map(_userGigsFromSnapshot);
    // QuerySnapshot userRelatedGigs = await _gigsCollection
    //     .where('gigOwnerId', isEqualTo: userId)
    //     .getDocuments();
    // return await userRelatedGigs.documents;
    // return _gigsCollection
    //     .where('gigOwnerId', isEqualTo: userId)
    //     .snapshots()
    //     .map(_userGigsFromSnapshot);
    return _gigsCollection.where('gigOwnerId', isEqualTo: userId).snapshots();
  }

  Future updateOngoingGigsByGigId(String uid, dynamic gigId) async {
    return await _usersCollection.document(uid).updateData({
      "ongoingGigsByGigId": FieldValue.arrayUnion([gigId])
    });
  }
}
