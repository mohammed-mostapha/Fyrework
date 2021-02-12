import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myApp/screens/add_gig/assets_picker/src/constants/constants.dart';

import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:myApp/models/myUser.dart';
import 'package:myApp/models/otherUser.dart';
import 'package:myApp/ui/widgets/user_profile.dart';

import 'database.dart';

class SearchUsersScreen extends StatefulWidget {
  String query;
  SearchUsersScreen({this.query});
  @override
  _SearchUsersScreenState createState() => _SearchUsersScreenState();
}

class _SearchUsersScreenState extends State<SearchUsersScreen> {
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => showSearch(
          query: widget.query,
          context: context,
          delegate:
              SearchUsers(otherUser: DatabaseService().fetchUsersInSearch()),
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
  String currentUserId = MyUser.uid;
  final String hourglassStart = 'assets/svgs/light/hourglass-start.svg';
  final String mapMarkerAlt = 'assets/svgs/light/map-marker-alt.svg';
  final Stream<QuerySnapshot> otherUser;
  final String hashtagSymbol = 'assets/svgs/flaticon/hashtag_symbol.svg';

  SearchUsers({this.otherUser});

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
                    fromComment: false,
                    fromGig: true,
                  )));
    }

    // bool searchWithHashtag = query.startsWith(RegExp('#[a-zA-Z0-9]'));
    bool searchWithHashtag = query.startsWith(RegExp('#'));

    return StreamBuilder<QuerySnapshot>(
        // stream: DatabaseService().fetchUsersInSearch(),
        stream: DatabaseService().listenToAllGigs(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          final hashtagsResults = snapshot.data.documents
              .where((g) => g['gigHashtags'].contains(query));

          final handlesResults = snapshot.data.documents
              .where((u) => u['username'].contains(query));

          // var searchCriteria =
          //     searchWithHashtag ? hashtagsResults : handlesResults;
          var searchCriteria =
              searchWithHashtag ? hashtagsResults : hashtagsResults;

          // if (!snapshot.hasData) {
          //   return Container(
          //     color: Theme.of(context).primaryColor,
          //     child: Center(
          //       child: Text(
          //         '',
          //         style: TextStyle(
          //             fontSize: 16, color: Theme.of(context).primaryColor),
          //       ),
          //     ),
          //   );
          // }
          // if (searchCriteria.length > 0) {
          //   return Container(
          //     color: Theme.of(context).primaryColor,
          //     child: ListView(
          //       children: searchCriteria
          //           .map<Widget>((u) => GestureDetector(
          //                 child: Padding(
          //                   padding: const EdgeInsets.all(0.1),
          //                   child: Container(
          //                     padding: EdgeInsets.symmetric(vertical: 5),
          //                     decoration: BoxDecoration(
          //                         color: Theme.of(context).primaryColor,
          //                         border: Border(
          //                             bottom: BorderSide(
          //                                 width: 0.3, color: Colors.grey[50]))),
          //                     child: ListTile(
          //                       leading: searchCriteria == hashtagsResults
          //                           ? CircleAvatar(
          //                               radius: 20,
          //                               backgroundColor:
          //                                   Theme.of(context).accentColor,
          //                               child: CircleAvatar(
          //                                 backgroundColor:
          //                                     Theme.of(context).primaryColor,
          //                                 radius: 18,
          //                                 child: SizedBox(
          //                                   width: 16,
          //                                   height: 16,
          //                                   child: SvgPicture.asset(
          //                                     hashtagSymbol,
          //                                     semanticsLabel: 'hashtag_symbol',
          //                                     color:
          //                                         Theme.of(context).accentColor,
          //                                   ),
          //                                 ),
          //                               ),
          //                             )
          //                           : CircleAvatar(
          //                               backgroundColor:
          //                                   Theme.of(context).hintColor,
          //                               backgroundImage: NetworkImage(
          //                                 u['userAvatarUrl'],
          //                               ),
          //                               radius: 20,
          //                             ),
          //                       title: Container(
          //                         padding: EdgeInsets.only(left: 10),
          //                         child: Column(
          //                           crossAxisAlignment:
          //                               CrossAxisAlignment.start,
          //                           children: [
          //                             Text(u['username'],
          //                                 style: Theme.of(context)
          //                                     .textTheme
          //                                     .bodyText1
          //                                     .copyWith(
          //                                         color: Theme.of(context)
          //                                             .accentColor),
          //                                 overflow: TextOverflow.ellipsis),
          //                             SizedBox(
          //                               height: 5,
          //                             ),
          //                             searchCriteria == hashtagsResults
          //                                 ? Text(
          //                                     u['lengthOfOngoingGigsByGigId']
          //                                             .toString() +
          //                                         ' gigs',
          //                                     style: Theme.of(context)
          //                                         .textTheme
          //                                         .bodyText2
          //                                         .copyWith(
          //                                             color: Theme.of(context)
          //                                                 .hintColor),
          //                                     overflow: TextOverflow.ellipsis)
          //                                 : Text(u['name'],
          //                                     // style: TextStyle(
          //                                     //   fontSize: 12,
          //                                     //   color:
          //                                     //       Theme.of(context).hintColor,
          //                                     // ),
          //                                     style: Theme.of(context)
          //                                         .textTheme
          //                                         .bodyText2
          //                                         .copyWith(
          //                                             color: Theme.of(context)
          //                                                 .hintColor),
          //                                     overflow: TextOverflow.ellipsis),
          //                           ],
          //                         ),
          //                       ),
          //                       trailing: Container(
          //                         padding: EdgeInsets.only(left: 10),
          //                         height: 43.0,
          //                         width: MediaQuery.of(context).size.width / 2,
          //                         child: Column(
          //                           crossAxisAlignment:
          //                               CrossAxisAlignment.start,
          //                           children: [
          //                             Expanded(
          //                               child: ListView.builder(
          //                                 scrollDirection: Axis.horizontal,
          //                                 itemCount:
          //                                     u['favoriteHashtags'].length,
          //                                 itemBuilder: (BuildContext context,
          //                                     int index) {
          //                                   final hashtagItem =
          //                                       u['favoriteHashtags'][index] +
          //                                           ' ';
          //                                   return Text(
          //                                     '$hashtagItem',
          //                                     style: Theme.of(context)
          //                                         .textTheme
          //                                         .bodyText1
          //                                         .copyWith(
          //                                             color: Theme.of(context)
          //                                                 .accentColor),
          //                                   );
          //                                 },
          //                               ),
          //                             ),
          //                             Text(
          //                               u['location'],
          //                               style: Theme.of(context)
          //                                   .textTheme
          //                                   .bodyText2
          //                                   .copyWith(
          //                                       color: Theme.of(context)
          //                                           .hintColor),
          //                               overflow: TextOverflow.ellipsis,
          //                             ),
          //                           ],
          //                         ),
          //                       ),
          //                     ),
          //                   ),
          //                 ),
          //                 onTap: () {
          //                   showUserProfile(u['id']);
          //                 },
          //               ))
          //           .toList(),
          //     ),
          //   );
          // }

          if (searchCriteria.length > 0) {
            return Container(
              color: Theme.of(context).primaryColor,
              child: ListView(
                children: searchCriteria
                    .map<Widget>((g) => GestureDetector(
                          child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: Container(
                              child: GestureDetector(
                                child: Container(
                                  child: Column(
                                    children: [
                                      Container(
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              8, 8, 8, 8),
                                          child: Column(
                                            children: <Widget>[
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  GestureDetector(
                                                    child: Flexible(
                                                      child: Container(
                                                        width: 200,
                                                        child: Row(
                                                          children: [
                                                            CircleAvatar(
                                                              maxRadius: 20,
                                                              backgroundColor:
                                                                  Theme.of(
                                                                          context)
                                                                      .primaryColor,
                                                              backgroundImage:
                                                                  NetworkImage(
                                                                g['gigOwnerAvatarUrl'],
                                                              ),
                                                            ),
                                                            Container(
                                                              width: 10,
                                                              height: 0,
                                                            ),
                                                            Flexible(
                                                              child: Text(
                                                                "${g['gigOwnerUsername']}"
                                                                    .capitalize(),
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    // onTap: showUserProfile,
                                                  ),
                                                ],
                                              ),
                                              // SizedBox(height: 10),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            8, 0, 8, 16.0),
                                        child: Column(
                                          children: <Widget>[
                                            Container(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                "${g['gigPost']}".capitalize(),
                                                style: TextStyle(
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 5),
                                            Container(
                                              width: double.infinity,
                                              child: Wrap(
                                                children: g['gigHashtags']
                                                    .map<Widget>((h) => Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .fromLTRB(
                                                                  0, 0, 5, 2.5),
                                                          child:
                                                              GestureDetector(
                                                            child: Text(
                                                              '$h',
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  color: Theme.of(
                                                                          context)
                                                                      .primaryColor),
                                                            ),
                                                            onTap: () {
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) =>
                                                                          SearchUsersScreen(
                                                                            query:
                                                                                h,
                                                                          )));
                                                            },
                                                          ),
                                                        ))
                                                    .toList(),
                                              ),
                                            ),
                                            SizedBox(height: 5),
                                            Row(
                                              children: [
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      2.5,
                                                  child: Row(
                                                    children: [
                                                      SizedBox(
                                                        width: 16,
                                                        height: 16,
                                                        child: SvgPicture.asset(
                                                          mapMarkerAlt,
                                                          semanticsLabel:
                                                              'location',
                                                          color:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                        ),
                                                      ),
                                                      Flexible(
                                                        child: Text(
                                                          g['gigLocation'],
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyText2,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Row(
                                                  children: <Widget>[
                                                    SizedBox(
                                                      width: 16,
                                                      height: 16,
                                                      child: SvgPicture.asset(
                                                        hourglassStart,
                                                        semanticsLabel:
                                                            'hourglass-start',
                                                        // color: Theme.of(context).primaryColor,
                                                        // color: Theme.of(context).primaryColor,
                                                      ),
                                                    ),
                                                    Container(
                                                      width: 5.0,
                                                      height: 0,
                                                    ),
                                                    Container(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: FittedBox(
                                                        fit: BoxFit.scaleDown,
                                                        child: Text(
                                                          // "${widget.gigDeadline.gigDeadline}",
                                                          g['gigDeadlineInUnixMilliseconds'] !=
                                                                  null
                                                              // ? "${widget.gigDeadline.gigDeadline}"
                                                              ? DateFormat(
                                                                      'yyyy-MM-dd')
                                                                  .format(DateTime
                                                                      .fromMillisecondsSinceEpoch(
                                                                          g['gigDeadlineInUnixMilliseconds']))
                                                              : "Book Gig",
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 5),
                                                Row(
                                                  children: <Widget>[
                                                    Container(
                                                      child: FittedBox(
                                                        fit: BoxFit.scaleDown,
                                                        child: Text(
                                                          g['gigCurrency'],
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      width: 2.5,
                                                      height: 0,
                                                    ),
                                                    Container(
                                                      child: FittedBox(
                                                        fit: BoxFit.scaleDown,
                                                        child: Text(
                                                          g['gigBudget'],
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            // SizedBox(height: 10.0),
                                            g['adultContentBool']
                                                ? Container(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Column(
                                                      children: [
                                                        SizedBox(height: 5),
                                                        Row(
                                                          children: [
                                                            FaIcon(
                                                              FontAwesomeIcons
                                                                  .asterisk,
                                                              size: 12,
                                                            ),
                                                            Container(
                                                              width: 5.0,
                                                            ),
                                                            Expanded(
                                                              child: Text(
                                                                g['adultContentText'],
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 12,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                : Container(
                                                    width: 0,
                                                    height: 0,
                                                  ),
                                            SizedBox(height: 5),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5),
                                      boxShadow: [
                                        // BoxShadow(
                                        //     blurRadius: 8,
                                        //     color: Colors.grey[200],
                                        //     spreadRadius: 3)
                                      ]),
                                ),
                              ),
                            ),
                          ),
                          onTap: () {
                            showUserProfile(g['id']);
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
                  'No gigs found under this creiteria',
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
