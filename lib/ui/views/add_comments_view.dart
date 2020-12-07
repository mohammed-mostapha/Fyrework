import 'package:flutter/material.dart';
import 'package:myApp/ui/shared/theme.dart';
import 'package:myApp/ui/views/comments_view.dart';
import 'package:myApp/ui/widgets/comment_item.dart';
import 'package:myApp/ui/widgets/provider_widget.dart';
import 'package:myApp/viewmodels/add_comments_view_model.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:myApp/locator.dart';
import 'package:myApp/services/auth_service.dart';
import 'package:myApp/services/storage_repo.dart';
import 'package:timeago/timeago.dart';
import 'package:custom_switch/custom_switch.dart';

class AddCommentsView extends StatefulWidget {
  final String passedGigId;
  AddCommentsView({Key key, @required this.passedGigId}) : super(key: key);
  @override
  _AddCommentsViewState createState() => _AddCommentsViewState(passedGigId);
}

class _AddCommentsViewState extends State<AddCommentsView> {
  AuthService _authService = locator.get<AuthService>();
  StorageRepo _storageRepo = locator.get<StorageRepo>();
  String passedGigId;
  _AddCommentsViewState(this.passedGigId);
  bool privateComment = false;
  String userId;
  String userFullName;
  dynamic userProfilePictureUrl;

  Future<String> getProfilePictureDownloadUrl() async {
    print('fetching profile picture url');
    return userProfilePictureUrl = await _storageRepo
        .getUserProfilePictureDownloadUrl(await _authService.getCurrentUID());
  }

  // return FutureBuilder(
  //     future: Provider.of(context).auth.getCurrentUser(),
  //     builder: (context, snapshot) {
  //       if (snapshot.connectionState == ConnectionState.done) {
  //         userId = snapshot.data.uid;
  //         userFullName = snapshot.data.displayName;
  //       }
  //     });

  TextEditingController _addCommentsController = TextEditingController();

  // _addComment(String val) {
  //   AddCommentsViewModel().addComment(
  //     gigIdHoldingComment: passedGigId,
  //     comentOwnerFullName: 'Mohamed',
  //     commentBody: 'this is mohamed\'s comment',
  //     commentOwnerId: 'id123',
  //     commentOwnerProfilePictureUrl: 'url132',
  //     commentId: 'commentid123',
  //   );
  // }

  addComment() {
    AddCommentsViewModel().addComment(
      gigIdHoldingComment: passedGigId,
      commentOwnerFullName: userFullName,
      commentBody: _addCommentsController.text,
      commentOwnerId: userId,
      commentOwnerProfilePictureUrl: userProfilePictureUrl,
      commentId: passedGigId,
      commentTime: new DateTime.now(),
    );
    _addCommentsController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        // future: Provider.of(context).auth.getCurrentUser(),
        future: Future.wait([
          Provider.of(context).auth.getCurrentUser(),
          getProfilePictureDownloadUrl()
        ]),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            userId = snapshot.data[0].uid;
            userFullName = snapshot.data[0].displayName;
            userProfilePictureUrl = snapshot.data[1];
            return ViewModelProvider<AddCommentsViewModel>.withConsumer(
              viewModelBuilder: () {
                return AddCommentsViewModel();
              },
              builder: (context, model, child) => Scaffold(
                  appBar: new AppBar(
                    backgroundColor: Theme.of(context).primaryColor,
                    title: Text('Comments'),
                  ),
                  body: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                          child: CommentsView(
                        currentUserId: userId,
                        gigIdCommentsIdentifier: passedGigId,
                      )),
                      ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // CircleAvatar(
                            //   backgroundImage:
                            //       NetworkImage(userProfilePictureUrl),
                            //   radius: 20,
                            // ),
                            CustomSwitch(
                              activeColor: FyreworkrColors.fyreworkBlack,
                              value: privateComment,
                              onChanged: (value) {
                                setState(() {
                                  privateComment = value;
                                });
                              },
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              child: TextFormField(
                                controller: _addCommentsController,
                                decoration: InputDecoration(
                                  hintText: "Add comment...",
                                  border: InputBorder.none,
                                  // enabledBorder: UnderlineInputBorder(
                                  //     borderSide: BorderSide(color: Colors.red)),
                                  // focusedBorder: UnderlineInputBorder(
                                  //     borderSide: BorderSide(color: Colors.red)),
                                ),
                                // onFieldSubmitted: addComment(),
                                onFieldSubmitted: (String submittedString) {
                                  AddCommentsViewModel().addComment(
                                    gigIdHoldingComment: passedGigId,
                                    commentOwnerFullName: userFullName,
                                    commentBody: submittedString,
                                    commentOwnerId: userId,
                                    commentOwnerProfilePictureUrl:
                                        userProfilePictureUrl,
                                    commentId: passedGigId,
                                    commentTime: new DateTime.now(),
                                  );
                                  _addCommentsController.clear();
                                },

                                style: TextStyle(color: Colors.black),
                              ),
                            ),

                            IconButton(
                              icon: Icon(
                                Icons.send,
                                color: FyreworkrColors.fyreworkBlack,
                              ),
                              onPressed: () {
                                addComment();
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  )),
            );
          } else {
            return Container();
          }
        });
  }

  @override
  void dispose() {
    _addCommentsController.dispose();
    super.dispose();
  }
}
