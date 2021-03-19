import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:Fyrework/models/myUser.dart';
import 'package:Fyrework/services/database.dart';
import 'package:Fyrework/ui/widgets/comment_item.dart';

class CommentsView extends StatelessWidget {
  final bool isGigAppointed;
  final String gigIdCommentsIdentifier;
  final String gigOwnerId;
  // final String passedCurrentUserId
  const CommentsView(
      {Key key,
      @required this.gigIdCommentsIdentifier,
      @required this.isGigAppointed,
      this.gigOwnerId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: DatabaseService().gigRelatedComments(gigIdCommentsIdentifier),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: Text(''));
        }

        if (snapshot.hasData && !(snapshot.data.documents.length > 0)) {
          return Center(
              child: Text(
            'No comments yet...',
            style: Theme.of(context).textTheme.bodyText1,
          ));
        } else if (snapshot.hasData && snapshot.data.documents.length > 0) {
          return ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) {
                DocumentSnapshot data = snapshot.data.documents[index];
                Map getDocData = data.data;
                return GestureDetector(
                  // onTap: () => model.editGig(index),
                  child: CommentItem(
                    // passedCurrentUserId: MyUser.uid,`
                    isGigAppointed: isGigAppointed,
                    gigIdHoldingComment: getDocData['gigIdHoldingComment'],
                    gigOwnerId: getDocData['gigOwnerId'],
                    commentId: getDocData['commentId'],
                    commentOwnerId: getDocData['commentOwnerId'],
                    commentOwnerAvatarUrl: getDocData['commentOwnerAvatarUrl'],
                    commentOwnerUsername: getDocData['commentOwnerUsername'],
                    commentBody: getDocData['commentBody'],
                    gigCurrency: getDocData['gigCurrency'],
                    createdAt: getDocData['createdAt'],
                    isPrivateComment: getDocData['isPrivateComment'],
                    proposal: getDocData['proposal'],
                    approved: getDocData['approved'],
                    rejected: getDocData['rejected'],
                    offeredBudget: getDocData['offeredBudget'],
                    preferredPaymentMethod:
                        getDocData['preferredPaymentMethod'],
                    workstreamFileUrl: getDocData['workstreamFileUrl'],
                    containMediaFile: getDocData['containMediaFile'],

                    // onDeleteItem: () =>
                    //     model.deleteComment(index),
                  ),
                );
              });
        }
      },
    );
  }
}
