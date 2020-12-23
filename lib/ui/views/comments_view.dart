import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myApp/services/database.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:myApp/ui/widgets/comment_item.dart';
import 'package:timeago/timeago.dart';

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
  // Widget build(BuildContext context) {
  //   return ViewModelProvider<CommentsViewModel>.withConsumer(
  //       viewModelBuilder: () {
  //         return CommentsViewModel();
  //       },
  //       onModelReady: (model) =>
  //           model.listenToComments(gigIdCommentsIdentifier),
  //       builder: (context, model, child) => Scaffold(
  //             backgroundColor: Colors.white,
  //             body: Padding(
  //               padding: const EdgeInsets.symmetric(horizontal: 0),
  //               child: Column(
  //                 mainAxisSize: MainAxisSize.max,
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: <Widget>[
  //                   Expanded(
  //                       child: model.comments != null
  //                           ? ListView.builder(
  //                               itemCount: model.comments.length,
  //                               itemBuilder: (context, index) =>
  //                                   GestureDetector(
  //                                 // onTap: () => model.editCooment(index),
  //                                 child: CommentItem(
  //                                   currentUserId: currentUserId,
  //                                   gigIdHoldingComment: model.comments[index],
  //                                   commentId: model.comments[index],
  //                                   commentOwnerId: model.comments[index],
  //                                   commentOwnerProfilePictureUrl:
  //                                       model.comments[index],
  //                                   commentOwnerFullName: model.comments[index],
  //                                   commentBody: model.comments[index],
  //                                   commentTime: model.comments[index],
  //                                   privateComment: model.comments[index],
  //                                   onDeleteItem: () =>
  //                                       model.deleteComment(index),
  //                                 ),
  //                               ),
  //                             )
  //                           : Center(
  //                               child: Flexible(
  //                               child: Padding(
  //                                 padding: const EdgeInsets.all(8.0),
  //                                 child: Text(
  //                                   "No comments yet...",
  //                                   style: TextStyle(fontSize: 18),
  //                                   textAlign: TextAlign.center,
  //                                 ),
  //                               ),
  //                             )))
  //                 ],
  //               ),
  //             ),
  //           ));
  // }
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
        stream: DatabaseService().gigRelatedComments(gigIdCommentsIdentifier),
        builder: (context, snapshot) {
          return !snapshot.hasData
              ? Center(child: Text('No comments yet...'))
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
                            appointedUserId: getDocData['appointedUserId'],
                            appointedUserFullName:
                                getDocData['appointedUserFullName'],
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
      ),
    );
  }
}
