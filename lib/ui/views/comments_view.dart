import 'package:flutter/material.dart';
import 'package:myApp/viewmodels/comments_view_model.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:myApp/ui/widgets/comment_item.dart';
import 'package:timeago/timeago.dart';

class CommentsView extends StatelessWidget {
  const CommentsView({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<CommentsViewModel>.withConsumer(
        viewModelBuilder: () {
          return CommentsViewModel();
        },
        onModelReady: (model) => model.listenToComments(),
        builder: (context, model, child) => Scaffold(
              backgroundColor: Colors.white,
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                        child: model.comments != null
                            ? ListView.builder(
                                itemCount: model.comments.length,
                                itemBuilder: (context, index) =>
                                    GestureDetector(
                                  // onTap: () => model.editCooment(index),
                                  child: CommentItem(
                                    gigIdHoldingComment: model.comments[index],
                                    commentId: model.comments[index],
                                    commentOwnerId: model.comments[index],
                                    commentOwnerProfilePictureUrl:
                                        model.comments[index],
                                    commentOwnerFullName: model.comments[index],
                                    commentBody: model.comments[index],
                                    onDeleteItem: () =>
                                        model.deleteComment(index),
                                  ),
                                ),
                              )
                            : Center(
                                child: Flexible(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "No one has commentd on this gig yet..add yours to communiate with the gig poster...",
                                    style: TextStyle(fontSize: 18),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              )))
                  ],
                ),
              ),
            ));
  }
}
