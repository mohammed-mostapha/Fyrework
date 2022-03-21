import 'package:Fyrework/custom_widgets/comment_item.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class CommentsView extends StatefulWidget {
  final bool isGigAppointed;
  final String parentGigId;
  final String gigOwnerId;
  const CommentsView({
    Key key,
    @required this.parentGigId,
    @required this.isGigAppointed,
    this.gigOwnerId,
  }) : super(key: key);

  @override
  _CommentsViewState createState() => _CommentsViewState();
}

class _CommentsViewState extends State<CommentsView> {
  DatabaseReference _parentGigRef;
  List allCommentsList = List();
  @override
  void initState() {
    super.initState();
    _parentGigRef = FirebaseDatabase.instance
        .reference()
        .child('gigs')
        .child(widget.parentGigId)
        .child('comments');
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Event>(
      stream: _parentGigRef.onValue,
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

        if (commentsSnapshot.data.snapshot.value == null) {
          return Center(
              child: Text(
            'No comments yet...',
            style: Theme.of(context).textTheme.bodyText1,
          ));
        } else if (commentsSnapshot.data.snapshot.value != null) {
          DataSnapshot dataValues = commentsSnapshot.data.snapshot;
          Map<dynamic, dynamic> values = dataValues.value;
          allCommentsList.clear();
          values.forEach((key, values) {
            allCommentsList.add(values);
          });
          return ListView.builder(
              itemCount: allCommentsList.length,
              itemBuilder: (context, index) {
                print('allCommentsList: $allCommentsList');
                return GestureDetector(
                  child: CommentItem(
                    parentGigId: allCommentsList[index]['parentGigId'],
                    isGigAppointed: widget.isGigAppointed,
                    gigOwnerId: allCommentsList[index]['gigOwnerId'],
                    gigOwnerUsername: allCommentsList[index]
                        ['gigOwnerUsername'],
                    commentId: allCommentsList[index]['commentId'],
                    commentOwnerId: allCommentsList[index]['commentOwnerId'],
                    commentOwnerAvatarUrl: allCommentsList[index]
                        ['commentOwnerAvatarUrl'],
                    commentOwnerUsername: allCommentsList[index]
                        ['commentOwnerUsername'],
                    commentBody: allCommentsList[index]['commentBody'],
                    gigValue: allCommentsList[index]['gigValue'],
                    createdAt: allCommentsList[index]['createdAt'],
                    isPrivateComment: allCommentsList[index]
                        ['isPrivateComment'],
                    proposal: allCommentsList[index]['proposal'],
                    approved: allCommentsList[index]['approved'],
                    rejected: allCommentsList[index]['rejected'],
                    preferredPaymentMethod: allCommentsList[index]
                        ['preferredPaymentMethod'],
                    workstreamFileUrl: allCommentsList[index]
                        ['workstreamFileUrl'],
                    containMediaFile: allCommentsList[index]
                        ['containMediaFile'],
                    ratingCount: allCommentsList[index]['ratingCount'],
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
