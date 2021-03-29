import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:Fyrework/services/database.dart';
import 'package:Fyrework/models/myUser.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:Fyrework/services/storage_repo.dart';
import 'package:Fyrework/view_controllers/myUser_controller.dart';

import '../locator.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Stream<String> get authStateChanges => _firebaseAuth.authStateChanges().map(
        (User user) => user?.uid,
      );

  // GET UID

  Future<String> getCurrentUID() async {
    return (_firebaseAuth.currentUser).uid;
  }

  // GET CURRENT USER
  Future getCurrentUser() async {
    return _firebaseAuth.currentUser;
  }

  // Email & Password Sign Up
  Future createUserWithEmailAndPassword({
    String email,
    String password,
  }) async {
    try {
      var signUpAttempt = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      var authResult = signUpAttempt;
      return authResult;
      // FirebaseUser user = authResult.user;

    } catch (e) {
      print('coming from creatingUser function: $e');
    }
  }

  Future updateUserName(String name, User currentUser) async {
    await FirebaseAuth.instance.currentUser.updateProfile(displayName: name);
    await currentUser.reload();
    // return currentUser.uid;
  }

//  Email & Password Sign In
  Future<UserCredential> signInWithEmailAndPassword(
      String email, String password) async {
    var signInAttempt = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    var authResult = signInAttempt;
    return authResult;
  }

  // Sign Out
  signOut() {
    _firebaseAuth.signOut();
    MyUser.clearData();
  }

  // Reset Password
  Future sendPasswordResetEmail(String email) async {
    return _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  // Converting an anonymous user to user with gmail
  Future convertWithGoogle() async {
    final currentUser = _firebaseAuth.currentUser;
    final GoogleSignInAccount googleAccount = await _googleSignIn.signIn();
    final GoogleSignInAuthentication _googleAuth =
        await googleAccount.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
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
    final AuthCredential credential = GoogleAuthProvider.credential(
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
