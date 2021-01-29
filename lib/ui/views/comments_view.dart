import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myApp/services/database.dart';
import 'package:myApp/ui/widgets/comment_item.dart';

class CommentsView extends StatelessWidget {
  final String gigIdCommentsIdentifier;
  final String gigOwnerId;
  final String passedCurrentUserId;
  const CommentsView(
      {Key key,
      @required this.gigIdCommentsIdentifier,
      @required this.passedCurrentUserId,
      this.gigOwnerId})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: DatabaseService().gigRelatedComments(gigIdCommentsIdentifier),
      builder: (context, snapshot) {
        return !snapshot.hasData
            ? Center(child: Text(''))
            : snapshot.data.documents.length > 0
                ? ListView.builder(
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot data = snapshot.data.documents[index];
                      Map getDocData = data.data;
                      return GestureDetector(
                        // onTap: () => model.editGig(index),
                        child: CommentItem(
                          passedCurrentUserId: passedCurrentUserId,
                          gigIdHoldingComment:
                              getDocData['gigIdHoldingComment'],
                          gigOwnerId: getDocData['gigOwnerId'],
                          commentId: getDocData['commentId'],
                          commentOwnerId: getDocData['commentOwnerId'],
                          commentOwnerProfilePictureUrl:
                              getDocData['commentOwnerProfilePictureUrl'],
                          commentOwnerFullName:
                              getDocData['commentOwnerFullName'],
                          commentBody: getDocData['commentBody'],
                          gigCurrency: getDocData['gigCurrency'],
                          commentTime: getDocData['commentTime'],
                          privateComment: getDocData['privateComment'],
                          proposal: getDocData['proposal'],
                          approved: getDocData['approved'],
                          rejected: getDocData['rejected'],
                          offeredBudget: getDocData['offeredBudget'],
                          // onDeleteItem: () =>
                          //     model.deleteComment(index),
                        ),
                      );
                    })
                : Center(
                    child: Text(
                    'No comments yet...',
                  ));
      },
    );
  }
}
