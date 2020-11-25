import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myApp/models/gig.dart';
import 'package:myApp/models/comment.dart';
import 'package:myApp/models/user.dart';
import 'package:flutter/services.dart';

class FirestoreService {
  final CollectionReference _usersCollectionReference =
      Firestore.instance.collection('users');
  final CollectionReference _gigsCollectionReference =
      Firestore.instance.collection('gigs');
  final CollectionReference _commentsCollectionReference =
      Firestore.instance.collection('comments');

  final StreamController<List<Gig>> _gigsController =
      StreamController<List<Gig>>.broadcast();

  final StreamController<List<Comment>> _commentsController =
      StreamController<List<Comment>>.broadcast();

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
      await _gigsCollectionReference.add(gig.toMap()).then((gig) {
        var gigId = gig.documentID;
        DocumentReference gig_ref = _gigsCollectionReference.document(gigId);
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
      Map<String, dynamic> commentData = comment.toMap();
      print('commentData $commentData');
      await _commentsCollectionReference
          .document(gigIdHoldingComment +
              DateTime.now().millisecondsSinceEpoch.toString())
          .setData(commentData);
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
    _gigsCollectionReference.snapshots().listen((gigsSnapshot) {
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

  Stream listenToCommentsRealTime(String gigIdCommentsIdentifier) {
    // Register the handler for when the comments data changes
    _commentsCollectionReference.snapshots().listen((commentsSnapshot) {
      if (commentsSnapshot.documents.isNotEmpty) {
        var commentsByGigId = commentsSnapshot.documents
            .where((element) =>
                element.documentID.contains(gigIdCommentsIdentifier))
            .map((snapshot) =>
                Comment.fromMap(snapshot.data, snapshot.documentID))
            .where((mappedItem) =>
                mappedItem.gigIdHoldingComment == gigIdCommentsIdentifier)
            .toList();

        _commentsController.add(commentsByGigId);
      }
    });

    return _commentsController.stream;
  }

  Future deleteGig(String commentId) async {
    await _gigsCollectionReference.document(commentId).delete();
  }

  Future deleteComment(String commentId) async {
    await _commentsCollectionReference.document(commentId).delete();
  }

  Future updateGig(Gig gig) async {
    try {
      await _gigsCollectionReference
          .document(gig.gigId)
          .updateData(gig.toMap());
    } catch (e) {
      // TODO: Find or create a way to repeat error handling without so much repeated code
      if (e is PlatformException) {
        return e.message;
      }

      return e.toString();
    }
  }

  Future updateGigAddRemoveLike(String gigId, bool likedOrNot) async {
    try {
      await _gigsCollectionReference
          .document(gigId)
          .updateData({'gigLikes': FieldValue.increment(likedOrNot ? 1 : -1)});
    } catch (e) {
      // TODO: Find or create a way to repeat error handling without so much repeated code
      if (e is PlatformException) {
        return e.message;
      }

      return e.toString();
    }
  }

  Future updateComment(Comment comment) async {
    try {
      await _commentsCollectionReference
          .document(comment.commentId)
          .updateData(comment.toMap());
    } catch (e) {
      // TODO: Find or create a way to repeat error handling without so much repeated code
      if (e is PlatformException) {
        return e.message;
      }

      return e.toString();
    }
  }
}
