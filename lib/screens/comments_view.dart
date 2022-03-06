import 'package:Fyrework/custom_widgets/comment_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:Fyrework/firebase_database/firestore_database.dart';

class CommentsView extends StatelessWidget {
  final bool isGigAppointed;
  final String gigIdCommentsIdentifier;
  final String gigOwnerId;
  const CommentsView({
    Key key,
    @required this.gigIdCommentsIdentifier,
    @required this.isGigAppointed,
    this.gigOwnerId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirestoreDatabase().gigRelatedComments(gigIdCommentsIdentifier),
      builder: (context, commentsSnapshot) {
        if (commentsSnapshot.hasError) {
          return Center(
            child: Text(''),
          );
        }
        if (!commentsSnapshot.hasData) {
          return Center(
            child: Text(''),
          );
        }

        if (commentsSnapshot.hasData &&
            !(commentsSnapshot.data.docs.length > 0)) {
          return Center(
              child: Text(
            'No comments yet...',
            style: Theme.of(context).textTheme.bodyText1,
          ));
        } else if (commentsSnapshot.hasData &&
            commentsSnapshot.data.docs.length > 0) {
          return ListView.builder(
              itemCount: commentsSnapshot.data.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot data = commentsSnapshot.data.docs[index];
                Map getDocData = data.data();
                return GestureDetector(
                  child: CommentItem(
                    isGigAppointed: isGigAppointed,
                    gigIdHoldingComment: getDocData['gigIdHoldingComment'],
                    gigOwnerId: getDocData['gigOwnerId'],
                    gigOwnerUsername: getDocData['gigOwnerUsername'],
                    commentId: getDocData['commentId'],
                    commentOwnerId: getDocData['commentOwnerId'],
                    commentOwnerAvatarUrl: getDocData['commentOwnerAvatarUrl'],
                    commentOwnerUsername: getDocData['commentOwnerUsername'],
                    commentBody: getDocData['commentBody'],
                    gigCurrency: getDocData['gigCurrency'],
                    gigValue: getDocData['gigValue'],
                    offeredBudget: getDocData['offeredBudget'],
                    createdAt: getDocData['createdAt'],
                    isPrivateComment: getDocData['isPrivateComment'],
                    proposal: getDocData['proposal'],
                    approved: getDocData['approved'],
                    rejected: getDocData['rejected'],
                    preferredPaymentMethod:
                        getDocData['preferredPaymentMethod'],
                    workstreamFileUrl: getDocData['workstreamFileUrl'],
                    containMediaFile: getDocData['containMediaFile'],
                    commentPrivacyToggle: getDocData['commentPrivacyToggle'],
                    isGigCompleted: getDocData['isGigCompleted'],
                    ratingCount: getDocData['ratingCount'],
                    leftReview: getDocData['leftReview'],
                  ),
                );
              });
        }
        return Center(
            child: Text(
          'No comments yet...',
          style: Theme.of(context).textTheme.bodyText1,
        ));
      },
    );
  }
}
