import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:myApp/locator.dart';
import 'package:myApp/models/myUser.dart';
import 'package:myApp/services/database.dart';
import 'package:myApp/ui/views/sign_up_view.dart';
// import 'package:myApp/ui/widgets/provider_widget.dart';
import 'package:myApp/ui/shared/theme.dart';
import 'package:myApp/services/auth_service.dart';
import 'package:myApp/services/storage_repo.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:myApp/ui/widgets/userRelated_gigItem.dart';

class MyProfileView extends StatefulWidget {
  @override
  _MyProfileViewState createState() => _MyProfileViewState();
}

class _MyProfileViewState extends State<MyProfileView> {
  AuthService _authService = locator.get<AuthService>();
  StorageRepo _storageRepo = locator.get<StorageRepo>();
  AuthFormType authFormType;
  // dynamic userProfilePictureUrl;

  // Future<String> getProfilePictureDownloadUrl() async {
  //   print('fetching profile picture url');
  //   return userProfilePictureUrl = await _storageRepo
  //       .getUserProfilePictureDownloadUrl(await _authService.getCurrentUID());
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: FyreworkrColors.fyreworkBlack,
          body: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CachedNetworkImage(
                        imageBuilder: (context, imageProvider) => Container(
                          width: 90.0,
                          height: 90.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: imageProvider, fit: BoxFit.cover),
                          ),
                        ),
                        imageUrl: MyUser.userAvatarUrl,
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
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
                                  MyUser.ongoingGigsByGigId != null
                                      ? '${MyUser.ongoingGigsByGigId.length}'
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
                              MyUser.name,
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Container(
                              child: Row(
                                children: <Widget>[
                                  Text('no.',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.white)),
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
                        Text(MyUser.location,
                            style:
                                TextStyle(fontSize: 16, color: Colors.white)),
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
                            // Container(
                            //   child: Center(child: Text('Ongoing goes here')),
                            // ),
                            Container(
                              child: Center(child: Text('Done goes here')),
                            ),
                            Container(
                              child:
                                  Center(child: Text('Liked gigs gies here')),
                            ),
                            Container(
                              child: Center(child: Text('Rating goes here')),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ))),
    );
  }

  // Widget displayUserMetadata(context) {
  //   return Container(
  //     width: MediaQuery.of(context).size.width,
  //     child: Column(
  //       children: <Widget>[
  //         Padding(
  //           padding: const EdgeInsets.all(8.0),
  //           child: Flexible(
  //             child: Text(
  //               MyUser.email,
  //               style: TextStyle(fontSize: 18),
  //             ),
  //           ),
  //         ),
  //         // showSignOut(context)
  //       ],
  //     ),
  //   );
  // }

  Widget displayUserInformation(
    context,
  ) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CachedNetworkImage(
            imageBuilder: (context, imageProvider) => Container(
              width: 90.0,
              height: 90.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
              ),
            ),
            imageUrl: MyUser.userAvatarUrl,
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
          SizedBox(
            height: 100,
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Text(
                    "Ongoing gigs",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                Expanded(
                  child: Text(
                    MyUser.ongoingGigsByGigId != null
                        ? '${MyUser.ongoingGigsByGigId.length}'
                        : '0',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 100,
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Text(
                    "Completed gigs",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                Expanded(
                  child: Text(
                    "5",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  userOngoingGigs() {
    return FutureBuilder<QuerySnapshot>(
      future: DatabaseService().myOngoingGigsByGigOwnerId(MyUser.uid),
      builder: (context, snapshot) {
        // print('snapshot.data: ${snapshot.data.documents.length}');
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
                : Center(child: Text('You haven\'t posted any gigs yet'));
      },
    );
  }

  Widget showSignOut(context) {
    return RaisedButton(
      child: AutoSizeText("Sign out"),
      onPressed: () async {
        try {
          // await Provider.of(context).auth.signOut();
          await AuthService().signOut();
        } catch (e) {
          print(e);
        }
      },
    );
  }
}
