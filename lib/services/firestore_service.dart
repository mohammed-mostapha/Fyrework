import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myApp/models/gig.dart';
import 'package:myApp/models/user.dart';
import 'package:flutter/services.dart';

class FirestoreService {
  final CollectionReference _usersCollectionReference =
      Firestore.instance.collection('users');
  final CollectionReference _gigCollectionReference =
      Firestore.instance.collection('gigs');

  final StreamController<List<Gig>> _gigsController =
      StreamController<List<Gig>>.broadcast();

  Future createUser(User user) async {
    try {
      await _usersCollectionReference.document(user.id).setData(user.toJson());
    } catch (e) {
      // TODO: Find or create a way to repeat error handling without so much repeated code
      if (e is PlatformException) {
        return e.message;
      }

      return e.toString();
    }
  }

  Future getUser(String uid) async {
    try {
      var userData = await _usersCollectionReference.document(uid).get();
      return User.fromData(userData.data);
    } catch (e) {
      // TODO: Find or create a way to repeat error handling without so much repeated code
      if (e is PlatformException) {
        return e.message;
      }

      return e.toString();
    }
  }

  Future addGig(Gig gig) async {
    try {
      await _gigCollectionReference.add(gig.toMap());
    } catch (e) {
      // TODO: Find or create a way to repeat error handling without so much repeated code
      if (e is PlatformException) {
        return e.message;
      }

      return e.toString();
    }
  }

  // Future getGigsOnceOff() async {
  //   try {
  //     var gigDocumentSnapshot = await _gigCollectionReference.getDocuments();
  //     if (gigDocumentSnapshot.documents.isNotEmpty) {
  //       return gigDocumentSnapshot.documents
  //           .map((snapshot) => Gig.fromMap(snapshot.data, snapshot.documentID))
  //           .where((mappedItem) => mappedItem.gigHashtags != null)
  //           .toList();
  //     }
  //   } catch (e) {
  //     // TODO: Find or create a way to repeat error handling without so much repeated code
  //     if (e is PlatformException) {
  //       return e.message;
  //     }

  //     return e.toString();
  //   }
  // }

  Stream listenToGigsRealTime() {
    // Register the handler for when the gigs data changes
    _gigCollectionReference.snapshots().listen((gigsSnapshot) {
      if (gigsSnapshot.documents.isNotEmpty) {
        var gigs = gigsSnapshot.documents
            .map((snapshot) => Gig.fromMap(snapshot.data, snapshot.documentID))
            .where((mappedItem) => mappedItem.gigHashtags != null)
            .toList();

        // Add the posts onto the controller
        _gigsController.add(gigs);
      }
    });

    return _gigsController.stream;
  }

  Future deleteGig(String documentId) async {
    await _gigCollectionReference.document(documentId).delete();
  }

  Future updateGig(Gig gig) async {
    try {
      await _gigCollectionReference
          .document(gig.documentId)
          .updateData(gig.toMap());
    } catch (e) {
      // TODO: Find or create a way to repeat error handling without so much repeated code
      if (e is PlatformException) {
        return e.message;
      }

      return e.toString();
    }
  }
}
