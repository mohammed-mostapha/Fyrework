import 'package:myApp/locator.dart';
import 'package:myApp/models/Comment.dart';
import 'package:myApp/services/navigation_service.dart';
import 'package:myApp/services/dialog_service.dart';
import 'package:myApp/viewmodels/base_model.dart';
import 'package:myApp/services/firestore_service.dart';
import 'package:flutter/material.dart';

class CommentsViewModel extends BaseModel {
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final DialogService _dialogService = locator<DialogService>();

  List<dynamic> _comments;
  List<dynamic> get comments => _comments;

  bool get busy => false;

  void listenToComments(String gigIdCommentsIdentifier) {
    setBusy(true);
    _firestoreService
        .listenToCommentsRealTime(gigIdCommentsIdentifier)
        .listen((commentsData) {
      List<dynamic> updatedComments = commentsData;
      if (updatedComments != null && updatedComments.length > 0) {
        _comments = updatedComments;
        notifyListeners();
      }

      setBusy(false);
    });
  }

  Future deleteComment(int index) async {
    var dialogResponse = await _dialogService.showConfirmationDialog(
      title: 'Are you sure?',
      description: 'Do you really want to delete this comment?',
      confirmationTitle: 'Yes',
      cancelTitle: 'No',
    );
    if (dialogResponse.confirmed) {
      setBusy(true);
      await _firestoreService.deleteGig(_comments[index].commentId);
      setBusy(false);
    }
  }
}
