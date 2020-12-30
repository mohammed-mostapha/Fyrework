import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myApp/models/gig.dart';
import 'package:myApp/models/comment.dart';
import 'package:myApp/models/user.dart';
import 'package:flutter/services.dart';

import 'database.dart';

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
    var gigId;
    String userId = gig.gigOwnerId;

    try {
      // await _gigCollectionReference.add(gig.toMap());
      await _gigsCollectionReference.add(gig.toMap()).then((gig) {
        gigId = gig.documentID;
        DocumentReference gigRef = _gigsCollectionReference.document(gigId);
        gigRef.updateData({'gigId': gigRef.documentID});
      });
      await DatabaseService(uid: userId)
          .updateOngoingGigsByGigId(userId, gigId);
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
      DocumentReference commentRef =
          await _commentsCollectionReference.add(commentData).then((comment) {
        comment.updateData({'commentId': comment.documentID});
      });
      // .document(gigIdHoldingComment +
      //     DateTime.now().millisecondsSinceEpoch.toString())
      // .document()
      // .setData(commentData);

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

  Future appointedGigToUser(
      String gigId, String appointedUserId, String commentId) async {
    try {
      var appointedUser =
          await _usersCollectionReference.document(appointedUserId).get();
      var appointedUserFullName = appointedUser.data['name'];

      await DatabaseService(uid: appointedUserId)
          .updateOngoingGigsByGigId(appointedUserId, gigId);

      await _gigsCollectionReference.document(gigId).updateData({
        'appointed': true,
        'appointedUserId': appointedUserId,
        'appointedUserFullName': appointedUserFullName
      });

      await _commentsCollectionReference.document(commentId).updateData({
        'approved': true,
        'appointedUserId': appointedUserId,
        'appointedUserFullName': appointedUserFullName,
      }).then((value) async {
        await _commentsCollectionReference
            .where('approved', isEqualTo: false)
            .getDocuments()
            .then((querySnapshots) {
          querySnapshots.documents.forEach((document) {
            document.reference.updateData({'rejected': true});
          });
        });
      });
    } catch (e) {
      if (e is PlatformException) {
        return e.message;
      }
    }
  }

  Future rejectProposal(String commentId) async {
    try {
      await _commentsCollectionReference.document(commentId).updateData({
        'rejected': true,
      });
    } catch (e) {
      if (e is PlatformException) {
        return e.message;
      }
    }
  }

  // Future getApponitedOrRejectedUserFullName(
  //     String appointedOrRejectedUserId) async {
  //   try {
  //     var appointedOrRejectedUser = await _usersCollectionReference
  //         .document(appointedOrRejectedUserId)
  //         .get();
  //     var appointedOrRejectedUserFullName =
  //         appointedOrRejectedUser.data['name'];
  //     print(
  //         'appointedOrRejectedUserFullName: $appointedOrRejectedUserFullName');
  //   } catch (e) {
  //     if (e is PlatformException) {
  //       return e.message;
  //     }
  //   }
  // }

  Future commentPrivacyToggle(String commentId, bool value) async {
    try {
      await _commentsCollectionReference
          .document(commentId)
          .updateData(({'privateComment': value}));

      // updateData({'privateComment': value});
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
