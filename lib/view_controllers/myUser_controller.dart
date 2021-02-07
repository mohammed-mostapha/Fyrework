import 'package:myApp/locator.dart';
import 'package:myApp/models/myUser.dart';
import 'package:myApp/services/auth_service.dart';
import 'package:myApp/services/firestore_service.dart';
import 'package:myApp/services/storage_repo.dart';

class MyUserController {
  MyUser currentUser;
  String currentFirebaseUserUid;
  AuthService authService = locator.get<AuthService>();
  StorageRepo storageRepo = locator.get<StorageRepo>();

//fetch user id from firebase
  getCurrentUserFromFirebase(String uid) async {
    //assing myUserData from cloud to my local user object
    await FirestoreService().getCurrentUserData(uid);
  }
}
