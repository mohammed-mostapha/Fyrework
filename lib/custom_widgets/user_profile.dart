import 'package:Fyrework/custom_widgets/profile_rating_stars.dart';
import 'package:Fyrework/custom_widgets/userRelated_gigItem.dart';
import 'package:Fyrework/models/myUser.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:Fyrework/firebase_database/firestore_database.dart';
import 'package:Fyrework/screens/sign_up_view.dart';

class UserProfileView extends StatefulWidget {
  final String passedUserUid;
  UserProfileView({
    Key key,
    @required this.passedUserUid,
  }) : super(key: key);
  @override
  _UserProfileViewState createState() => _UserProfileViewState();
}

class _UserProfileViewState extends State<UserProfileView> {
  final String grid = 'assets/svgs/light/th.svg';
  final String currentUserId = MyUser.uid;
  AuthFormType authFormType;
  String profileUsername;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        child: StreamBuilder(
            stream:
                FirestoreDatabase().fetchUserData(userId: widget.passedUserUid),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                  child: Center(
                      child: Text(
                    'Loading Profile...',
                    style: Theme.of(context).textTheme.bodyText1,
                  )),
                );
              }
              if (snapshot.hasError) {
                return Container(
                  child: Center(
                      child: Text(
                    'Profile not available',
                    style: Theme.of(context).textTheme.bodyText1,
                    textAlign: TextAlign.center,
                  )),
                );
              }
              if (!snapshot.hasData) {
                return Container(
                  child: Center(
                      child: Text(
                    'Profile not available',
                    style: Theme.of(context).textTheme.bodyText1,
                    textAlign: TextAlign.center,
                  )),
                );
              } else {
                if (snapshot.data != null) {
                  profileUsername = snapshot.data.username;
                  return Scaffold(
                    appBar: AppBar(
                      elevation: 0.0,
                      automaticallyImplyLeading: false,
                      title: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                            child: Text(
                              snapshot.data.username,
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    body: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CachedNetworkImage(
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    width: 90.0,
                                    height: 90.0,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover),
                                    ),
                                  ),
                                  imageUrl: snapshot.data.userAvatarUrl,
                                  placeholder: (context, url) =>
                                      CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                ),
                                SizedBox(
                                  height: 50,
                                  child: Column(
                                    children: <Widget>[
                                      Expanded(
                                        child: Center(
                                          child: Text(
                                            "Open",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: snapshot.data != null
                                            ? Center(
                                                child: Text(
                                                  snapshot.data
                                                              .openGigsByGigId !=
                                                          null
                                                      ? '${snapshot.data.openGigsByGigId.length}'
                                                      : '0',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1,
                                                ),
                                              )
                                            : Container(
                                                width: 20,
                                                height: 20,
                                                child:
                                                    CircularProgressIndicator(
                                                  strokeWidth: 1,
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                              Color>(
                                                          Theme.of(context)
                                                              .primaryColor),
                                                ),
                                              ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 50,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Expanded(
                                        child: Center(
                                          child: Text(
                                            "Completed",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: snapshot.data != null
                                            ? Center(
                                                child: Text(
                                                  snapshot.data
                                                              .completedGigsByGigId !=
                                                          null
                                                      ? '${snapshot.data.completedGigsByGigId.length}'
                                                      : '0',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1,
                                                ),
                                              )
                                            : Container(
                                                width: 20,
                                                height: 20,
                                                child:
                                                    CircularProgressIndicator(
                                                  strokeWidth: 1,
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                              Color>(
                                                          Theme.of(context)
                                                              .primaryColor),
                                                ),
                                              ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 0, 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  snapshot.data.name,
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  width: 100,
                                  child: ProfileRatingStars(
                                    userId: widget.passedUserUid,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  snapshot.data.location,
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: DefaultTabController(
                              length: 3,
                              child: Scaffold(
                                appBar: AppBar(
                                  toolbarHeight: 50,
                                  primary: false,
                                  leading: Container(width: 0, height: 0),
                                  title: Container(width: 0, height: 0),
                                  bottom: TabBar(
                                    indicatorColor:
                                        Theme.of(context).primaryColor,
                                    tabs: [
                                      Tab(
                                          child: SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: SvgPicture.asset(
                                          grid,
                                          semanticsLabel: 'grid',
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      )),
                                      Tab(
                                        child: FaIcon(
                                          FontAwesomeIcons.checkCircle,
                                          size: 16,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                      Tab(
                                        child: FaIcon(
                                          FontAwesomeIcons.thumbsUp,
                                          size: 16,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                  elevation: 0,
                                  backgroundColor:
                                      Theme.of(context).scaffoldBackgroundColor,
                                ),
                                body: TabBarView(
                                  children: [
                                    userOpenGigs(),
                                    userCompletedGigs(),
                                    userLikedGigs(),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return Container(
                    child: Center(
                        child: Text(
                      'Profile not available',
                      style: Theme.of(context).textTheme.bodyText1,
                      textAlign: TextAlign.center,
                    )),
                  );
                }
              }
            }),
      ),
    );
  }

  userOpenGigs() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirestoreDatabase()
          .openGigsByGigRelatedUsers(userId: widget.passedUserUid),
      builder: (context, snapshot) {
        return snapshot.hasError
            ? Center(
                child: Text(
                "Gigs are not available right now",
                style: Theme.of(context).textTheme.bodyText1,
              ))
            : !snapshot.hasData
                ? Text(
                    "Gigs are not available right now",
                    style: Theme.of(context).textTheme.bodyText1,
                  )
                : snapshot.data.docs.length > 0
                    ? ListView.builder(
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot data = snapshot.data.docs[index];
                          Map getDocData = data.data();
                          return GestureDetector(
                            // onTap: () => model.editGig(index),
                            child: UserRelatedGigItem(
                              index: index,
                              appointed: getDocData['appointed'],
                              appointedusername:
                                  getDocData['appointedUserFullName'],
                              appliersOrHirersByUserId:
                                  getDocData['appliersOrHirersByUserId'],
                              gigRelatedUsersByUserId:
                                  getDocData['gigRelatedUsersByUserId'],
                              gigId: getDocData['gigId'],
                              currentUserId: currentUserId,
                              gigOwnerId: getDocData['gigOwnerId'],
                              gigOwnerAvatarUrl:
                                  getDocData['gigOwnerAvatarUrl'],
                              gigOwnerUsername: getDocData['gigOwnerUsername'],
                              createdAt: getDocData['createdAt'],
                              gigOwnerLocation: getDocData['gigOwnerLocation'],
                              gigLocation: getDocData['gigLocation'],
                              gigHashtags: getDocData['gigHashtags'],
                              gigMediaFilesDownloadUrls:
                                  getDocData['gigMediaFilesDownloadUrls'],
                              gigPost: getDocData['gigPost'],
                              gigCurrency: getDocData['gigCurrency'],
                              gigBudget: getDocData['gigBudget'],
                              gigValue: getDocData['gigValue'],
                              adultContentText: getDocData['adultContentText'],
                              adultContentBool: getDocData['adultContentBool'],
                              appointedUserId: getDocData['appointedUserId'],
                              hidden: getDocData['hidden'],
                              gigActions: getDocData['gigActions'],
                              paymentReleased: getDocData['paymentReleased'],
                              markedAsComplete: getDocData['markedAsComplete'],
                              clientLeftReview: getDocData['clientLeftReview'],
                              likesCount: getDocData['likesCount'],
                              likersByUserId: getDocData['likersByUserId'],
                            ),
                          );
                        })
                    : Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width / 2,
                          child: Text(
                            "$profileUsername has no open gigs",
                            style: Theme.of(context).textTheme.bodyText1,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      );
      },
    );
  }

  userCompletedGigs() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirestoreDatabase()
          .completedGigsByGigRelatedUsers(userId: widget.passedUserUid),
      builder: (context, snapshot) {
        // print('snapshot.data: ${snapshot.data.documents.length}');
        return snapshot.hasError
            ? Center(
                child: Text(
                "Gigs are not available right now",
                style: Theme.of(context).textTheme.bodyText1,
              ))
            : !snapshot.hasData
                ? Text(
                    "Gigs are not available right now",
                    style: Theme.of(context).textTheme.bodyText1,
                  )
                : snapshot.data.docs.length > 0
                    ? ListView.builder(
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot data = snapshot.data.docs[index];
                          Map getDocData = data.data();
                          return GestureDetector(
                            // onTap: () => model.editGig(index),
                            child: UserRelatedGigItem(
                              index: index,
                              appointed: getDocData['appointed'],
                              appointedusername:
                                  getDocData['appointedUserFullName'],
                              appliersOrHirersByUserId:
                                  getDocData['appliersOrHirersByUserId'],
                              gigRelatedUsersByUserId:
                                  getDocData['gigRelatedUsersByUserId'],
                              gigId: getDocData['gigId'],
                              currentUserId: currentUserId,
                              gigOwnerId: getDocData['gigOwnerId'],
                              gigOwnerAvatarUrl:
                                  getDocData['gigOwnerAvatarUrl'],
                              gigOwnerUsername: getDocData['gigOwnerUsername'],
                              createdAt: getDocData['createdAt'],
                              gigOwnerLocation: getDocData['gigOwnerLocation'],
                              gigLocation: getDocData['gigLocation'],
                              gigHashtags: getDocData['gigHashtags'],
                              gigMediaFilesDownloadUrls:
                                  getDocData['gigMediaFilesDownloadUrls'],
                              gigPost: getDocData['gigPost'],
                              gigCurrency: getDocData['gigCurrency'],
                              gigBudget: getDocData['gigBudget'],
                              gigValue: getDocData['gigValue'],
                              adultContentText: getDocData['adultContentText'],
                              adultContentBool: getDocData['adultContentBool'],
                              appointedUserId: getDocData['appointedUserId'],
                              hidden: getDocData['hidden'],
                              gigActions: getDocData['gigActions'],
                              paymentReleased: getDocData['paymentReleased'],
                              markedAsComplete: getDocData['markedAsComplete'],
                              clientLeftReview: getDocData['clientLeftReview'],
                              likesCount: getDocData['likesCount'],
                              likersByUserId: getDocData['likersByUserId'],
                            ),
                          );
                        })
                    : Center(
                        child: Container(
                        width: MediaQuery.of(context).size.width / 2,
                        child: Text(
                          "$profileUsername has no completed gigs",
                          style: Theme.of(context).textTheme.bodyText1,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ));
      },
    );
  }

  userLikedGigs() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirestoreDatabase()
          .likedGigsByLikersByUserId(userId: widget.passedUserUid),
      builder: (context, snapshot) {
        // print('snapshot.data: ${snapshot.data.documents.length}');
        return snapshot.hasError
            ? Center(
                child: Text(
                "Gigs are not available right now",
                style: Theme.of(context).textTheme.bodyText1,
              ))
            : !snapshot.hasData
                ? Text(
                    "Gigs are not available right now",
                    style: Theme.of(context).textTheme.bodyText1,
                  )
                : snapshot.data.docs.length > 0
                    ? ListView.builder(
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot data = snapshot.data.docs[index];
                          Map getDocData = data.data();
                          return GestureDetector(
                            // onTap: () => model.editGig(index),
                            child: UserRelatedGigItem(
                              index: index,
                              appointed: getDocData['appointed'],
                              appointedusername:
                                  getDocData['appointedUserFullName'],
                              appliersOrHirersByUserId:
                                  getDocData['appliersOrHirersByUserId'],
                              gigRelatedUsersByUserId:
                                  getDocData['gigRelatedUsersByUserId'],
                              gigId: getDocData['gigId'],
                              currentUserId: currentUserId,
                              gigOwnerId: getDocData['gigOwnerId'],
                              gigOwnerAvatarUrl:
                                  getDocData['gigOwnerAvatarUrl'],
                              gigOwnerUsername: getDocData['gigOwnerUsername'],
                              createdAt: getDocData['createdAt'],
                              gigOwnerLocation: getDocData['gigOwnerLocation'],
                              gigLocation: getDocData['gigLocation'],
                              gigHashtags: getDocData['gigHashtags'],
                              gigMediaFilesDownloadUrls:
                                  getDocData['gigMediaFilesDownloadUrls'],
                              gigPost: getDocData['gigPost'],
                              gigCurrency: getDocData['gigCurrency'],
                              gigBudget: getDocData['gigBudget'],
                              gigValue: getDocData['gigValue'],
                              adultContentText: getDocData['adultContentText'],
                              adultContentBool: getDocData['adultContentBool'],
                              appointedUserId: getDocData['appointedUserId'],
                              hidden: getDocData['hidden'],
                              gigActions: getDocData['gigActions'],
                              paymentReleased: getDocData['paymentReleased'],
                              markedAsComplete: getDocData['markedAsComplete'],
                              clientLeftReview: getDocData['clientLeftReview'],
                              likesCount: getDocData['likesCount'],
                              likersByUserId: getDocData['likersByUserId'],
                            ),
                          );
                        })
                    : Center(
                        child: Container(
                        width: MediaQuery.of(context).size.width / 2,
                        child: Text(
                          "$profileUsername has no liked gigs",
                          style: Theme.of(context).textTheme.bodyText1,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ));
      },
    );
  }
}
