import 'package:firebase_auth/firebase_auth.dart';
import 'package:myApp/locator.dart';
import 'package:myApp/models/myUser.dart';
import 'package:myApp/services/auth_service.dart';
import 'package:myApp/services/database.dart';
import 'package:myApp/services/firestore_service.dart';
import 'package:myApp/services/storage_repo.dart';

class UserController {
  MyUser currentUser;
  String currentFirebaseUserUid;
  AuthService authService = locator.get<AuthService>();
  StorageRepo storageRepo = locator.get<StorageRepo>();

  // dynamic _userAvatarUrl;

  // Future uploadProfilePicture(File image) async {
  //   _userAvatarUrl =
  //       await locator.get<StorageRepo>().uploadProfilePicture(image);
  //   print(_userAvatarUrl);
  // }

  // Future<String> getProfilePictureDownloadUrl() async {
  //   return _userAvatarUrl = await _storageRepo
  //       .getUserProfilePictureDownloadUrl(await _authService.getCurrentUID());
  // }

  // Future<void> signInWithEmailAndPassword(
  //     {String email, String password}) async {
  //   currentUser = await authService.signInWithEmailAndPassword(
  //     email,
  //     password,
  //   );

  // _userAvatarUrl = await getProfilePictureDownloadUrl();

  // print(_currentUser.name);
  // print(_currentUser.id);
  // print(_userAvatarUrl);
// }

// Future<String> getCurrentUser() async {
//   return currentUserId = (await _authService.getCurrentUser()).uid;
// }

//fetch user id from firebase
  getCurrentUserFromFirebase() async {
    print('print starting point of userController');
    currentFirebaseUserUid = await authService.getCurrentUID();
    // currentFirebaseUserUid = (await FirebaseAuth.instance.currentUser()).uid;
    // await authService.getCurrentUID();
    // DatabaseService().fetchUserData(currentFirebaseUserUid);
    await FirestoreService().getCurrentUserData(currentFirebaseUserUid);
    print('print userId: ${MyUser.uid}');

    // print('print user model: $User');

    // if (_currentUser.uid != null) {
    //   DatabaseService().fetchUserData(_currentUser.uid);
    // }
  }

// static final UserController currentUser = UserController.getCurrentUser();

// factory UserController() {
//   return currentUser;
// }

// UserController.getCurrentUser() {
//   getCurrentUserFromFirebase().then((value) {
//     print('from the named contructor of UserController: $User');
//   });
// }
// }
}
