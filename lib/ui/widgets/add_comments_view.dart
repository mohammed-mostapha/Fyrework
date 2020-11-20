import 'package:flutter/material.dart';
import 'package:myApp/ui/widgets/provider_widget.dart';
import 'package:myApp/vew_controllers/user_controller.dart';

import 'package:myApp/locator.dart';

class CommentsPage extends StatefulWidget {
  @override
  _CommentsPageState createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
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

  List<String> _comments = [];
  TextEditingController _addCommentsController = TextEditingController();

  _addComment(String val) {
    setState(() {
      _comments.add(val);
    });
  }

  Widget _buildCommentsList() {
    return ListView.builder(itemBuilder: (context, index) {
      if (index < _comments.length) {
        return _buildCommentItem(_comments[index]);
      }
    });
  }

  Widget _buildCommentItem(String comment) {
    return ListTile(title: Text(comment));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: Text('Comments'),
        ),
        body: Column(
          children: <Widget>[
            Expanded(child: _buildCommentsList()),
            TextField(
              controller: _addCommentsController,
              onSubmitted: (String submittedString) {
                _addComment(submittedString);
                _addCommentsController.clear();
              },
              decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(20.0),
                  hintText: "Add a comment...get in touch with gig poster"),
            )
          ],
        ));
  }

  @override
  void dispose() {
    _addCommentsController.dispose();
    super.dispose();
  }
}
