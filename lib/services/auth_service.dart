import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myApp/services/database.dart';
import 'package:myApp/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:myApp/ui/shared/theme.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Stream<String> get onAuthStateChanged => _firebaseAuth.onAuthStateChanged.map(
        (FirebaseUser user) => user?.uid,
      );

  // GET UID
  Future<String> getCurrentUID() async {
    return (await _firebaseAuth.currentUser()).uid;
  }

  // GET CURRENT USER
  Future getCurrentUser() async {
    return await _firebaseAuth.currentUser();
  }

  // Email & Password Sign Up
  Future createUserWithEmailAndPassword(String email, String password,
      String name, String location, bool is_minor) async {
    final authResult = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);

    FirebaseUser user = authResult.user;

    // create a new document for the user with the uid
    await DatabaseService(uid: user.uid)
        .updateUserData(user.uid, name, email, password, location, is_minor);
    // return _userFromFirebaseUser(user);

    // Update the username
    await updateUserName(name, authResult.user);
    return authResult.user.uid;
  }

  // create user obj based on FirebaseUser
  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }

  Future updateUserName(String name, FirebaseUser currentUser) async {
    var userUpdateInfo = UserUpdateInfo();
    userUpdateInfo.displayName = name;
    await currentUser.updateProfile(userUpdateInfo);
    await currentUser.reload();
    return currentUser.uid;
  }

  // Email & Password Sign In
  // Future<String> signInWithEmailAndPassword(
  //     String email, String password) async {
  //   return (await _firebaseAuth.signInWithEmailAndPassword(
  //           email: email, password: password))
  //       .user
  //       .uid;
  // }

  // Email & Password Sign In
  Future<User> signInWithEmailAndPassword(String email, String password) async {
    var authResult = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return User(
        uid: authResult.user.uid, fullName: authResult.user.displayName);
  }

  // Sign Out
  signOut() {
    return _firebaseAuth.signOut();
  }

  // Reset Password
  Future sendPasswordResetEmail(String email) async {
    return _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  // Create Anonymous User
  Future signInAnonymously() {
    return _firebaseAuth.signInAnonymously();
  }

  //Convert an anonymous user to a user with credentials
  Future convertUserWithEmail(
      String email, String password, String name, String location) async {
    final currentUser = await _firebaseAuth.currentUser();
    final credential =
        EmailAuthProvider.getCredential(email: email, password: password);
    await currentUser.linkWithCredential(credential);
    await updateUserName(name, currentUser);
  }

  // Converting an anonymous user to user with gmail
  Future convertWithGoogle() async {
    final currentUser = await _firebaseAuth.currentUser();
    final GoogleSignInAccount googleAccount = await _googleSignIn.signIn();
    final GoogleSignInAuthentication _googleAuth =
        await googleAccount.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      idToken: _googleAuth.idToken,
      accessToken: _googleAuth.accessToken,
    );
    await currentUser.linkWithCredential(credential);
    await updateUserName(_googleSignIn.currentUser.displayName, currentUser);
  }

  // Google signIn
  Future<String> signInWithGoogle() async {
    final GoogleSignInAccount googleAccount = await _googleSignIn.signIn();
    final GoogleSignInAuthentication _googleAuth =
        await googleAccount.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      idToken: _googleAuth.idToken,
      accessToken: _googleAuth.accessToken,
    );
    return (await _firebaseAuth.signInWithCredential(credential)).user.uid;
  }

  // signing up with phone number
  Future createUserWithPhone(String phone, BuildContext context) async {
    final _codeController = TextEditingController();
    _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: Duration(seconds: 60),
        verificationCompleted: (AuthCredential authCredential) {
          _firebaseAuth
              .signInWithCredential(authCredential)
              .then((AuthResult result) {
            Navigator.of(context).pushReplacementNamed('/home');
          }).catchError((e) {
            return "error";
          });
        },
        verificationFailed: (AuthException exception) {
          return "error";
        },
        codeSent: (String verificationId, [int forceResendingToken]) {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => AlertDialog(
                    title: Column(
                      children: <Widget>[
                        AutoSizeText("We sent you a message."),
                        AutoSizeText("Enter SMS code"),
                      ],
                    ),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        TextField(
                          controller: _codeController,
                        )
                      ],
                    ),
                    actions: <Widget>[
                      FlatButton(
                        child: Text("submit"),
                        textColor: FyreworkrColors.white,
                        color: Colors.green,
                        onPressed: () {
                          var _credential = PhoneAuthProvider.getCredential(
                              verificationId: verificationId,
                              smsCode: _codeController.text.trim());
                          _firebaseAuth
                              .signInWithCredential(_credential)
                              .then((AuthResult result) {
                            Navigator.of(context).pushReplacementNamed('/home');
                          }).catchError((e) {
                            return "error";
                          });
                        },
                      )
                    ],
                  ));
        },
        codeAutoRetrievalTimeout: (String verifivationId) {
          verifivationId = verifivationId;
          print(verifivationId);
          print("Timeout");
        });
  }
}

class NameValidator {
  static String validate(String value) {
    if (value.isEmpty) {
      return '*';
    }
    if (value.length < 2) {
      return "Name must be at least 2 characters long";
    }
    if (value.length > 50) {
      return "Name must be less than 50 characters long";
    }
    return null;
  }
}

class EmailValidator {
  static String validate(String value) {
    if (value.isEmpty) {
      return '*';
    }
    return null;
  }
}

class PasswordValidator {
  static String validate(String value) {
    if (value.isEmpty) {
      return '*';
    }
    return null;
  }
}
