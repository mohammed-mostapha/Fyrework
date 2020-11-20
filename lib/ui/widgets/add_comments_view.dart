import 'package:flutter/material.dart';
import 'package:myApp/ui/widgets/provider_widget.dart';
import 'package:myApp/viewmodels/add_comments_view_model.dart';
import 'package:provider_architecture/provider_architecture.dart';

class AddCommentsView extends StatefulWidget {
  final String passedGigId;
  AddCommentsView({Key key, @required this.passedGigId}) : super(key: key);
  @override
  _AddCommentsViewState createState() => _AddCommentsViewState(passedGigId);
}

class _AddCommentsViewState extends State<AddCommentsView> {
  String passedGigId;
  _AddCommentsViewState(this.passedGigId);

  String userId;
  String userFullName;
  String userProfilePictureUrl;

  // return FutureBuilder(
  //     future: Provider.of(context).auth.getCurrentUser(),
  //     builder: (context, snapshot) {
  //       if (snapshot.connectionState == ConnectionState.done) {
  //         userId = snapshot.data.uid;
  //         userFullName = snapshot.data.displayName;
  //       }
  //     });

  TextEditingController _addCommentsController = TextEditingController();

  _addComment(String val) {
    AddCommentsViewModel().addComment(
      gigIdHoldingComment: passedGigId,
      comentOwnerFullName: 'Mohamed',
      commentBody: 'this is mohamed\'s comment',
      commentOwnerId: 'id123',
      commentOwnerProfilePictureUrl: 'url132',
      commentId: 'commentid123',
    );
  }

  Widget _buildCommentsList() {
    // return ListView.builder(itemBuilder: (context, index) {
    //   if (index < _comments.length) {
    //     return _buildCommentItem(_comments[index]);
    //   }
    // });
  }

  Widget _buildCommentItem(String comment) {
    return ListTile(title: Text(comment));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Provider.of(context).auth.getCurrentUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            userId = snapshot.data.uid;
            userFullName = snapshot.data.displayName;
            return snapshot.data.isAnonymous
                ? Container(
                    child: Flexible(
                        child: Text(
                            'You are an Anonymous user in the mean time...signUp to continue')),
                  )
                : ViewModelProvider<AddCommentsViewModel>.withConsumer(
                    viewModelBuilder: () {
                      return AddCommentsViewModel();
                    },
                    builder: (context, model, child) => Scaffold(
                        appBar: new AppBar(
                          title: Text('Comments'),
                        ),
                        body: Column(
                          children: <Widget>[
                            // Expanded(child: _buildCommentsList()),
                            TextField(
                              controller: _addCommentsController,
                              onSubmitted: (String submittedString) {
                                AddCommentsViewModel().addComment(
                                  gigIdHoldingComment: passedGigId,
                                  comentOwnerFullName: userFullName,
                                  commentBody: submittedString,
                                  commentOwnerId: userId,
                                  commentOwnerProfilePictureUrl: 'url132',
                                  commentId: passedGigId,
                                );

                                _addCommentsController.clear();
                                print(
                                    'go check Cloud DB for comments collection');
                              },
                              decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.all(20.0),
                                  hintText:
                                      "Add a comment...get in touch with gig poster"),
                            )
                          ],
                        )),
                  );
          }
        });
  }

  @override
  void dispose() {
    _addCommentsController.dispose();
    super.dispose();
  }
}
