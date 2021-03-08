import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Fyrework/models/myUser.dart';
import 'package:Fyrework/services/database.dart';
import 'package:Fyrework/ui/widgets/gig_item.dart';
import 'package:flutter/material.dart';
import 'package:Fyrework/ui/widgets/user_profile.dart';

class UsersSearchByHandle extends StatelessWidget {
  UsersSearchByHandle({Key key}) : super(key: key);
  // String currentUserId = UserController.currentUserId;
  String currentUserId = MyUser.uid;

  @override
  Widget build(BuildContext context) {
    showUserProfile(String userId) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => UserProfileView(
                    passedUserUid: userId,
                    fromComment: false,
                    fromGig: true,
                  )));
    }

    return StreamBuilder<QuerySnapshot>(
      stream: DatabaseService().fetchUsersInSearch(),
      builder: (context, AsyncSnapshot<QuerySnapshot> usersSnapshot) {
        Iterable<DocumentSnapshot> handleResults;

        if (usersSnapshot.hasData && usersSnapshot.data != null) {
          handleResults = usersSnapshot.data.documents.where((u) =>
              "${u['username']}"
                  .toLowerCase()
                  .contains('developer'.substring(1)));
        }
        // search difference
        if (!usersSnapshot.hasData) {
          return Container(
            color: Theme.of(context).primaryColor,
            child: Center(
              child: Text(
                '',
                style: TextStyle(
                    fontSize: 16, color: Theme.of(context).primaryColor),
              ),
            ),
          );
        }
        if (handleResults.length > 0) {
          return Container(
            color: Theme.of(context).primaryColor,
            child: ListView(
              children: handleResults
                  .map<Widget>((u) => GestureDetector(
                        child: Padding(
                          padding: const EdgeInsets.all(0.1),
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 5),
                            decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                border: Border(
                                    bottom: BorderSide(
                                        width: 0.3, color: Colors.grey[50]))),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Theme.of(context).hintColor,
                                backgroundImage: NetworkImage(
                                  u['userAvatarUrl'],
                                ),
                                radius: 20,
                              ),
                              title: Container(
                                padding: EdgeInsets.only(left: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(u['username'],
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            .copyWith(
                                                color: Theme.of(context)
                                                    .accentColor),
                                        overflow: TextOverflow.ellipsis),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(u['name'],
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2
                                            .copyWith(
                                                color: Theme.of(context)
                                                    .hintColor),
                                        overflow: TextOverflow.ellipsis),
                                  ],
                                ),
                              ),
                              trailing: Container(
                                padding: EdgeInsets.only(left: 10),
                                height: 43.0,
                                width: MediaQuery.of(context).size.width / 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: u['favoriteHashtags'].length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          final hashtagItem =
                                              u['favoriteHashtags'][index] +
                                                  ' ';
                                          return Text(
                                            '$hashtagItem',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1
                                                .copyWith(
                                                    color: Theme.of(context)
                                                        .accentColor),
                                          );
                                        },
                                      ),
                                    ),
                                    Text(
                                      u['location'],
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText2
                                          .copyWith(
                                              color:
                                                  Theme.of(context).hintColor),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        onTap: () {
                          showUserProfile(u['id']);
                        },
                      ))
                  .toList(),
            ),
          );
        } else {
          return Container(
            color: Theme.of(context).primaryColor,
            child: Center(
              child: Text(
                'No users found under this criteria',
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).accentColor,
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
