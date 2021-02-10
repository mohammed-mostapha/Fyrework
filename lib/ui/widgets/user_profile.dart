import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:myApp/locator.dart';
import 'package:myApp/services/database.dart';
import 'package:myApp/ui/shared/fyreworkTheme.dart';
import 'package:myApp/ui/views/sign_up_view.dart';
import 'package:myApp/services/auth_service.dart';
import 'package:myApp/services/storage_repo.dart';
import 'package:myApp/ui/widgets/userRelated_gigItem.dart';

import 'gig_item.dart';

class UserProfileView extends StatefulWidget {
  final String passedUserUid;
  // final String passedUsername;
  bool fromGig = false;
  bool fromComment = false;
  UserProfileView({
    Key key,
    @required this.passedUserUid,
    // @required this.passedUsername,
    @required this.fromGig,
    @required this.fromComment,
  }) : super(key: key);
  @override
  _UserProfileViewState createState() => _UserProfileViewState();
}

class _UserProfileViewState extends State<UserProfileView> {
  AuthService _authService = locator.get<AuthService>();
  StorageRepo _storageRepo = locator.get<StorageRepo>();
  AuthFormType authFormType;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: StreamBuilder(
          stream: DatabaseService().fetchUserData(widget.passedUserUid),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Scaffold(
                backgroundColor: FyreworkrColors.fyreworkBlack,
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  title: Container(
                    padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child: Text(
                      snapshot.data.username,
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.normal),
                    ),
                  ),
                ),
                body: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CircleAvatar(
                            backgroundImage:
                                NetworkImage(snapshot.data.userAvatarUrl),
                            radius: 50,
                          ),
                          SizedBox(
                            height: 50,
                            child: Column(
                              children: <Widget>[
                                Expanded(
                                  child: Center(
                                    child: Text(
                                      "Ongoing",
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.white),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Center(
                                    child: Text(
                                      snapshot.data.ongoingGigsByGigId != null
                                          ? '${snapshot.data.ongoingGigsByGigId.length}'
                                          : '0',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 50,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  child: Center(
                                    child: Text(
                                      "Completed",
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.white),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Center(
                                    child: Text(
                                      "5",
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 0, 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: [
                                Text(
                                  // widget.passedUserFullName,
                                  snapshot.data.name,
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Container(
                                  child: Row(
                                    children: <Widget>[
                                      Text('no.',
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.white)),
                                      FaIcon(
                                        FontAwesomeIcons.solidStar,
                                        size: 16,
                                        color: Colors.yellow,
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            Text(snapshot.data.location,
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white)),
                          ],
                        ),
                      ),
                      Expanded(
                        child: DefaultTabController(
                          length: 4,
                          child: Scaffold(
                            appBar: AppBar(
                                toolbarHeight: 50,
                                primary: false,
                                leading: Container(),
                                title: Container(),
                                bottom: TabBar(
                                  indicatorColor: FyreworkrColors.fyreworkBlack,
                                  tabs: [
                                    Tab(
                                        child: FaIcon(
                                      FontAwesomeIcons.borderAll,
                                      size: 16,
                                      color: FyreworkrColors.fyreworkBlack,
                                    )),
                                    Tab(
                                      child: FaIcon(
                                        FontAwesomeIcons.checkCircle,
                                        size: 16,
                                        color: FyreworkrColors.fyreworkBlack,
                                      ),
                                    ),
                                    Tab(
                                      child: FaIcon(
                                        FontAwesomeIcons.thumbsUp,
                                        size: 16,
                                        color: FyreworkrColors.fyreworkBlack,
                                      ),
                                    ),
                                    Tab(
                                      child: FaIcon(
                                        FontAwesomeIcons.star,
                                        size: 16,
                                        color: FyreworkrColors.fyreworkBlack,
                                      ),
                                    ),
                                  ],
                                ),
                                elevation: 0,
                                backgroundColor: Color(0xFFfafafa)),
                            // backgroundColor: FyreworkrColors.fyreworkBlack),
                            body: TabBarView(
                              children: [
                                userOngoingGigs(),
                                Container(
                                  child: Center(child: Text('Done goes here')),
                                ),
                                Container(
                                  child: Center(
                                      child: Text('Liked gigs gies here')),
                                ),
                                Container(
                                  child:
                                      Center(child: Text('Rating goes here')),
                                ),
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
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          }),
    );
  }

  userOngoingGigs() {
    return StreamBuilder<QuerySnapshot>(
      stream: widget.fromGig
          ? DatabaseService().userOngoingGigsByGigOwnerId(widget.passedUserUid)
          : DatabaseService()
              .userOngoingGigsByAppointedUserId(widget.passedUserUid),
      builder: (context, snapshot) {
        print('snapshot.data: ${snapshot.data}');
        return !snapshot.hasData
            ? Text('')
            : snapshot.data.documents.length > 0
                ? ListView.builder(
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot data = snapshot.data.documents[index];
                      Map getDocData = data.data;
                      return GestureDetector(
                        // onTap: () => model.editGig(index),
                        child: UserRelatedGigItem(
                          gigId: getDocData['gigId'],
                          gigOwnerId: getDocData['gigOwnderId'],
                          userProfilePictureDownloadUrl:
                              getDocData['userProfilePictureDownloadUrl'],
                          userFullName: getDocData['userFullName'],
                          gigHashtags: getDocData['gigHashtags'],
                          gigMediaFilesDownloadUrls:
                              getDocData['gigMediaFilesDownloadUrls'],
                          gigPost: getDocData['gigPost'],
                          gigDeadline: getDocData['gigDeadline'],
                          gigCurrency: getDocData['gigCurrency'],
                          gigBudget: getDocData['gigBudget'],
                          gigValue: getDocData['gigValue'],
                          gigLikes: getDocData['gigLikes'],
                          adultContentText: getDocData['adultContentText'],
                          adultContentBool: getDocData['adultContentBool'],
                          // onDeleteItem: () => model.deleteGig(index),
                        ),
                      );
                    })
                : Center(child: Text('This user hasn\'t posted any gigs yet'));
      },
    );
  }
}
