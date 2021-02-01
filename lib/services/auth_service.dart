import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:myApp/screens/my_profile.dart';
import 'package:myApp/services/database.dart';
import 'package:myApp/models/myUser.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:myApp/services/storage_repo.dart';
import 'package:myApp/ui/shared/theme.dart';
import 'package:myApp/view_controllers/myUser_controller.dart';

import '../locator.dart';

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
  Future createUserWithEmailAndPassword(
    // String hashtag,
    List myFavoriteHashtags,
    String name,
    // String username,
    String handle,
    String email,
    String password,
    String userAvatarUrl,
    File profilePictureToUpload,
    String location,
    bool isMinor,
    dynamic ongoingGigsByGigId,
    int lengthOfOngoingGigsByGigId,
  ) async {
    final authResult = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);

    FirebaseUser user = authResult.user;

    //just waiting for uier.uid to use
    userAvatarUrl = await locator
        .get<StorageRepo>()
        .uploadProfilePicture(profilePictureToUpload, user.uid);

    // create a new document for the user with the uid in users collection
    await DatabaseService(uid: user.uid).setUserData(
        user.uid,
        myFavoriteHashtags,
        name,
        handle,
        email,
        password,
        userAvatarUrl,
        location,
        isMinor,
        ongoingGigsByGigId,
        lengthOfOngoingGigsByGigId);
    // return _userFromFirebaseUser(user);

    // Update the displayName of the user in authData
    await updateUserName(name, authResult.user);
    return authResult.user.uid;
  }

  // // create user obj based on FirebaseUser
  // User _userFromFirebaseUser(FirebaseUser user) {
  //   return user != null ? User(uid: user.uid) : null;
  // }

  Future updateUserName(String name, FirebaseUser currentUser) async {
    var userUpdateInfo = UserUpdateInfo();
    userUpdateInfo.displayName = name;
    await currentUser.updateProfile(userUpdateInfo);
    await currentUser.reload();
    return currentUser.uid;
  }

//  Email & Password Sign In
  Future<MyUser> signInWithEmailAndPassword(
      String email, String password) async {
    var authResult = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    String myUid = authResult.user.uid;
    MyUserController().getCurrentUserFromFirebase(myUid);
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
  // Future signInAnonymously() {
  //   return _firebaseAuth.signInAnonymously();
  // }

  //Convert an anonymous user to a user with credentials
  // Future convertUserWithEmail(
  //     String email, String password, String name, String location) async {
  //   final currentUser = await _firebaseAuth.currentUser();
  //   final credential =
  //       EmailAuthProvider.getCredential(email: email, password: password);
  //   await currentUser.linkWithCredential(credential);
  //   await updateUserName(name, currentUser);
  // }

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
}

class HashtagValidator {
  static String validate(String value) {
    if (value.isEmpty) {
      return '';
    }
    if (value.length < 2) {
      return "Hashtag must be at least 2 characters long";
    }
    if (value.length > 30) {
      return "Hashtag must not exceed 30 characters";
    }
    return null;
  }
}

class UsernameValidator {
  static String validate(String value) {
    if (value.isEmpty) {
      return '';
    }
    if (value.length < 2) {
      return "Username must be at least 2 characters long";
    }
    if (value.length > 30) {
      return "Username must not exceed 30 characters";
    }
    return null;
  }
}

class NameValidator {
  static String validate(String value) {
    if (value.isEmpty) {
      return '';
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
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value);
    if (value.isEmpty) {
      return '';
    } else if (!emailValid) {
      return "Please provide a valid email address";
    }
    return null;
  }
}

class PasswordValidator {
  static String validate(String value) {
    if (value.isEmpty) {
      return '';
    } else if (value.length < 8) {
      return "Password must be at least 8 characters long";
    }
    return null;
  }
}
