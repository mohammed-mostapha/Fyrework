import 'package:Fyrework/locator.dart';
import 'package:Fyrework/models/myUser.dart';
import 'package:Fyrework/services/auth_service.dart';
import 'package:Fyrework/firebase_database/firestore_database.dart';
import 'package:Fyrework/services/storage_repo.dart';

class MyUserController {
  MyUser currentUser;
  String currentFirebaseUserUid;
  AuthService authService = locator.get<AuthService>();
  StorageRepo storageRepo = locator.get<StorageRepo>();

//fetch user id from firebase
  getCurrentUserFromFirebase(String uid) async {
    //passing myUserData from cloud to my local user object
    await FirestoreDatabase().getCurrentUserData(uid);
  }
}
