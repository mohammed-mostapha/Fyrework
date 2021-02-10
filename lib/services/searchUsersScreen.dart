import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:myApp/models/otherUser.dart';
import 'package:myApp/ui/widgets/user_profile.dart';

import 'database.dart';

class SearchUsersScreen extends StatefulWidget {
  @override
  _SearchUsersScreenState createState() => _SearchUsersScreenState();
}

class _SearchUsersScreenState extends State<SearchUsersScreen> {
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => showSearch(
          context: context,
          delegate: SearchUsers(
            DatabaseService().fetchUsersInSearch(),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
    );
  }
}

//Search delegate
class SearchUsers extends SearchDelegate<OtherUser> {
  final Stream<QuerySnapshot> otherUser;
  final String hashtagSymbol = 'assets/svgs/flaticon/hashtag_symbol.svg';

  SearchUsers(this.otherUser);
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return Container(
      width: 0,
      height: 0,
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container(
      width: 0,
      height: 0,
      color: Theme.of(context).primaryColor,
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    showUserProfile(String userId) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => UserProfileView(
                    passedUserUid: userId,
                    // passedUsername: widget.gigOwnerUsername,
                    fromComment: false,
                    fromGig: true,
                  )));
    }

    // bool searchWithHashtag = query.startsWith('#');
    bool searchWithHashtag = query.startsWith(RegExp('#[a-zA-Z0-9]'));
    return StreamBuilder<QuerySnapshot>(

        // stream: DatabaseService().fetchUsersInSearch(),
        // stream: query.startsWith('#')
        stream: searchWithHashtag
            ? DatabaseService().fetchUsersInSearchByFavoriteHashtags(query)
            : DatabaseService().fetchUsersInSearch(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          final hashtagsResults = snapshot.data.documents;

          final handlesResults = snapshot.data.documents
              .where((u) => u['username'].contains(query));

          var searchCriteria =
              searchWithHashtag ? hashtagsResults : handlesResults;

          if (!snapshot.hasData) {
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
          if (searchCriteria.length > 0) {
            return Container(
              color: Theme.of(context).primaryColor,
              child: ListView(
                children: searchCriteria
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
                                leading: searchCriteria == hashtagsResults
                                    ? CircleAvatar(
                                        radius: 20,
                                        backgroundColor:
                                            Theme.of(context).accentColor,
                                        child: CircleAvatar(
                                          backgroundColor:
                                              Theme.of(context).primaryColor,
                                          radius: 18,
                                          child: SizedBox(
                                            width: 16,
                                            height: 16,
                                            child: SvgPicture.asset(
                                              hashtagSymbol,
                                              semanticsLabel: 'hashtag_symbol',
                                              color:
                                                  Theme.of(context).accentColor,
                                            ),
                                          ),
                                        ),
                                      )
                                    : CircleAvatar(
                                        backgroundColor:
                                            Theme.of(context).primaryColor,
                                        backgroundImage:
                                            NetworkImage(u['userAvatarUrl']),
                                        radius: 20,
                                      ),
                                title: Container(
                                  padding: EdgeInsets.only(left: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(u['username'],
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Theme.of(context)
                                                  .accentColor),
                                          overflow: TextOverflow.ellipsis),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      searchCriteria == hashtagsResults
                                          ? Text(
                                              u['lengthOfOngoingGigsByGigId']
                                                      .toString() +
                                                  ' gigs',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey[500],
                                              ),
                                              overflow: TextOverflow.ellipsis)
                                          : Text(u['name'],
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey[500],
                                              ),
                                              overflow: TextOverflow.ellipsis),
                                    ],
                                  ),
                                ),
                                trailing: Container(
                                  padding: EdgeInsets.only(left: 10),
                                  height: 43.0,
                                  width: MediaQuery.of(context).size.width / 2,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount:
                                              u['favoriteHashtags'].length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            final hashtagItem =
                                                u['favoriteHashtags'][index] +
                                                    ' ';
                                            return Text('$hashtagItem',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Theme.of(context)
                                                        .accentColor));
                                          },
                                        ),
                                      ),
                                      Text(
                                        u['location'],
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey[500],
                                        ),
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
                  'No results found',
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).accentColor,
                  ),
                ),
              ),
            );
          }
        });
  }
}
