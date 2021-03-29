import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Fyrework/models/gig.dart';
import 'package:Fyrework/models/comment.dart';
import 'package:Fyrework/models/myUser.dart';
import 'package:flutter/services.dart';

import 'database.dart';

class FirestoreService {
  final CollectionReference _usersCollectionReference =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference _gigsCollectionReference =
      FirebaseFirestore.instance.collection('gigs');
  final CollectionReference _commentsCollectionReference =
      FirebaseFirestore.instance.collection('comments');
  final CollectionReference _popularHashtagsCollectionReference =
      FirebaseFirestore.instance.collection('popularHashtags');

  final StreamController<List<Gig>> _gigsController =
      StreamController<List<Gig>>.broadcast();

  Future getCurrentUserData(String uid) async {
    try {
      var userData = await _usersCollectionReference.doc(uid).get();
      MyUser.fromData(userData.data());
      print('see this: loaded userData from cloud to local stoge');
    } catch (e) {
      if (e is PlatformException) {
        return e.message;
      }

      return e.toString();
    }
  }

  Future addGig(List gigHashtags, Gig gig) async {
    var gigId;
    String userId = gig.gigOwnerId;

    try {
      // await _gigCollectionReference.add(gig.toMap());
      await _gigsCollectionReference.add(gig.toMap()).then((gig) {
        gigId = gig.id;
        DocumentReference gigRef = _gigsCollectionReference.doc(gigId);
        gigRef.update({'gigId': gigRef.id});
      });
      await DatabaseService(uid: userId)
          .updateOngoingGigsByGigId(userId, gigId);

      // only add gigHashtags that dont already exist in popularHashtags cloud firestore collection
      QuerySnapshot popularHashtagsDocuments =
          await _popularHashtagsCollectionReference.get();
      List<String> popularHashtagsValues = List();
      popularHashtagsDocuments.docs.forEach((document) {
        popularHashtagsValues.add("${document.data()['hashtag']}");
      });
      print('popularHashtagsValues: $popularHashtagsValues');
      for (int count = 0; count < gigHashtags.length; count++) {
        if (!popularHashtagsValues.contains(gigHashtags[count])) {
          _popularHashtagsCollectionReference
              .doc()
              .set({'hashtag': gigHashtags[count]});
        }
      }
    } catch (e) {
      // TODO: Find or create a way to repeat error handling without so much repeated code
      if (e is PlatformException) {
        // return e.message;
      }
      // return e.toString();
    }
  }

  Future addComment(Comment comment, String gigIdHoldingComment) async {
    try {
      Map<String, dynamic> commentData = comment.toMap();
      DocumentReference commentRef =
          await _commentsCollectionReference.add(commentData).then((comment) {
        comment.update({'commentId': comment.id});
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

  Stream listenToAllGigsRealTime() {
    // Register the handler for when the gigs data changes
    _gigsCollectionReference.snapshots().listen((gigsSnapshot) {
      if (gigsSnapshot.docs.isNotEmpty) {
        var gigs = gigsSnapshot.docs
            .map((snapshot) => Gig.fromMap(snapshot.data(), snapshot.id))
            .where((mappedItem) => mappedItem.gigHashtags != null)
            .toList();
        // Add the posts onto the controller
        _gigsController.add(gigs);
      }
    });
    return _gigsController.stream;
  }

  // Stream listenToCommentsRealTime(String gigIdCommentsIdentifier) {
  //   // Register the handler for when the comments data changes
  //   _commentsCollectionReference.snapshots().listen((commentsSnapshot) {
  //     if (commentsSnapshot.documents.isNotEmpty) {
  //       var commentsByGigId = commentsSnapshot.documents
  //           .where((element) =>
  //               element.documentID.contains(gigIdCommentsIdentifier))
  //           .map((snapshot) =>
  //               Comment.fromMap(snapshot.data, snapshot.documentID))
  //           .where((mappedItem) =>
  //               mappedItem.gigIdHoldingComment == gigIdCommentsIdentifier)
  //           .toList();

  //       _commentsController.add(commentsByGigId);
  //     }
  //   });

  //   return _commentsController.stream;
  // }

  Future deleteGig(String commentId) async {
    await _gigsCollectionReference.doc(commentId).delete();
  }

  Future deleteComment(String commentId) async {
    await _commentsCollectionReference.doc(commentId).delete();
  }

  Future updateGig(Gig gig) async {
    try {
      await _gigsCollectionReference.doc(gig.gigId).update(gig.toMap());
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
          .doc(gigId)
          .update({'gigLikes': FieldValue.increment(likedOrNot ? 1 : -1)});
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
          await _usersCollectionReference.doc(appointedUserId).get();
      var appointedUsername = appointedUser.data()['username'];

      await DatabaseService(uid: appointedUserId)
          .updateOngoingGigsByGigId(appointedUserId, gigId);

      await _gigsCollectionReference.doc(gigId).update({
        'appointed': true,
        'appointedUserId': appointedUserId,
        'appointedUsername': appointedUsername
      });

      await _commentsCollectionReference.doc(commentId).update({
        'approved': true,
        'appointedUserId': appointedUserId,
        'appointedUsername': appointedUsername,
      }).then((value) async {
        await _commentsCollectionReference
            .where('approved', isEqualTo: false)
            .get()
            .then((querySnapshots) {
          querySnapshots.docs.forEach((document) {
            document.reference.update({'rejected': true});
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
      await _commentsCollectionReference.doc(commentId).update({
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
          .doc(commentId)
          .update(({'privateComment': value}));

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
          .doc(comment.commentId)
          .update(comment.toMap());
    } catch (e) {
      // TODO: Find or create a way to repeat error handling without so much repeated code
      if (e is PlatformException) {
        return e.message;
      }

      return e.toString();
    }
  }
}
