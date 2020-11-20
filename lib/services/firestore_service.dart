import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myApp/models/gig.dart';
import 'package:myApp/models/comment.dart';
import 'package:myApp/models/user.dart';
import 'package:flutter/services.dart';

class FirestoreService {
  final CollectionReference _usersCollectionReference =
      Firestore.instance.collection('users');
  final CollectionReference _gigCollectionReference =
      Firestore.instance.collection('gigs');
  final CollectionReference _commentsCollectionReference =
      Firestore.instance.collection('comments');

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
      // await _gigCollectionReference.add(gig.toMap());
      await _gigCollectionReference.add(gig.toMap()).then((gig) {
        var gigId = gig.documentID;
        DocumentReference gig_ref = _gigCollectionReference.document(gigId);
        gig_ref.updateData({'gigId': gig_ref.documentID});
      });
    } catch (e) {
      // TODO: Find or create a way to repeat error handling without so much repeated code
      if (e is PlatformException) {
        return e.message;
      }

      return e.toString();
    }
  }

  Future addComment(Comment comment, String gigIdHoldingComment) async {
    try {
      // await _gigCollectionReference.add(gig.toMap());

      Map<String, dynamic> commentData = comment.toMap();
      //
      await _commentsCollectionReference
          .document(gigIdHoldingComment +
              DateTime.now().millisecondsSinceEpoch.toString())
          .setData(commentData);
      //end new
      // await _commentsCollectionReference.add(comment.toMap()).then((comment) {
      //   var commentId = comment.documentID;
      //   DocumentReference documentRef =
      //       _commentsCollectionReference.document(commentId);
      //   documentRef.updateData({'commentId': documentRef.documentID});
      // });
    } catch (e) {
      // TODO: Find or create a way to repeat error handling without so much repeated code
      if (e is PlatformException) {
        return e.message;
      }

      return e.toString();
    }
  }

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

  Future deleteGig(String gigId) async {
    await _gigCollectionReference.document(gigId).delete();
  }

  Future updateGig(Gig gig) async {
    try {
      await _gigCollectionReference.document(gig.gigId).updateData(gig.toMap());
    } catch (e) {
      // TODO: Find or create a way to repeat error handling without so much repeated code
      if (e is PlatformException) {
        return e.message;
      }

      return e.toString();
    }
  }
}
