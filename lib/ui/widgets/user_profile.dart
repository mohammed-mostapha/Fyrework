import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myApp/locator.dart';
import 'package:myApp/services/database.dart';
import 'package:myApp/ui/views/sign_up_view.dart';
import 'package:myApp/services/auth_service.dart';
import 'package:myApp/services/storage_repo.dart';
import 'package:myApp/ui/widgets/userRelated_gigItem.dart';

import 'gig_item.dart';

class UserProfileView extends StatefulWidget {
  final String passedUserUid;
  final String passedUserFullName;
  bool fromGig = false;
  bool fromComment = false;
  UserProfileView({
    Key key,
    @required this.passedUserUid,
    @required this.passedUserFullName,
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
  dynamic userProfilePictureDownloadUrl;

  Future<String> getProfilePictureDownloadUrl() async {
    print('from inside function: ${widget.passedUserUid}');
    return userProfilePictureDownloadUrl = await _storageRepo
        .getUserProfilePictureDownloadUrl(widget.passedUserUid);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: FutureBuilder(
            future: getProfilePictureDownloadUrl(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.connectionState == ConnectionState.done) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CircleAvatar(
                          backgroundImage:
                              NetworkImage(userProfilePictureDownloadUrl),
                          radius: 50,
                        ),
                        SizedBox(
                          height: 100,
                          child: Column(
                            children: <Widget>[
                              Expanded(
                                child: Center(
                                  child: Text(
                                    "Ongoing gigs",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              StreamBuilder(
                                stream: DatabaseService()
                                    .userData(widget.passedUserUid),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return Container(
                                      width: 0,
                                      height: 0,
                                    );
                                  } else if ((snapshot.hasData &&
                                      snapshot.data.ongoingGigsByGigId ==
                                          null)) {
                                    return Expanded(
                                      child: Center(
                                        child: Text(
                                          '0',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    );
                                  } else {
                                    return Expanded(
                                        child: Center(
                                      child: Text(
                                        '${snapshot.data.ongoingGigsByGigId.length}',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ));
                                  }
                                },
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 100,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                child: Center(
                                  child: Text(
                                    "Completed gigs",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Center(
                                  child: Text(
                                    "5",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
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
                    SizedBox(
                        height: 40,
                        child: Expanded(
                            child: Text(
                          widget.passedUserFullName,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ))),
                    Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                        stream: widget.fromGig
                            ? DatabaseService().userOngoingGigsByGigOwnerId(
                                widget.passedUserUid)
                            : DatabaseService()
                                .userOngoingGigsByAppointedUserId(
                                    widget.passedUserUid),
                        builder: (context, snapshot) {
                          print('snapshot.data: ${snapshot.data}');
                          return !snapshot.hasData
                              ? Text('This user hasn\'t posted any gigs yet')
                              : snapshot.data.documents.length > 0
                                  ? ListView.builder(
                                      itemCount: snapshot.data.documents.length,
                                      itemBuilder: (context, index) {
                                        DocumentSnapshot data =
                                            snapshot.data.documents[index];
                                        Map getDocData = data.data;
                                        return GestureDetector(
                                          // onTap: () => model.editGig(index),
                                          child: UserRelatedGigItem(
                                            gigId: getDocData['gigId'],
                                            gigOwnerId:
                                                getDocData['gigOwnderId'],
                                            userProfilePictureDownloadUrl:
                                                getDocData[
                                                    'userProfilePictureDownloadUrl'],
                                            userFullName:
                                                getDocData['userFullName'],
                                            gigHashtags:
                                                getDocData['gigHashtags'],
                                            gigMediaFilesDownloadUrls:
                                                getDocData[
                                                    'gigMediaFilesDownloadUrls'],
                                            gigPost: getDocData['gigPost'],
                                            gigDeadline:
                                                getDocData['gigDeadline'],
                                            gigCurrency:
                                                getDocData['gigCurrency'],
                                            gigBudget: getDocData['gigBudget'],
                                            gigValue: getDocData['gigValue'],
                                            gigLikes: getDocData['gigLikes'],
                                            adultContentText:
                                                getDocData['adultContentText'],
                                            adultContentBool:
                                                getDocData['adultContentBool'],
                                            // onDeleteItem: () => model.deleteGig(index),
                                          ),
                                        );
                                      })
                                  : Text(
                                      'This user hasn\'t posted any gigs yet');
                        },
                      ),
                    ),
                  ],
                );
              } else {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                );
              }
            },
          ),
        ),
      ),
    );
  }

  // Widget displayUserMetadata(context, snapshot) {
  //   final authData = snapshot.data;
  //   return Container(
  //     width: MediaQuery.of(context).size.width,
  //     child: Column(
  //       children: <Widget>[
  //         Padding(
  //           padding: const EdgeInsets.all(8.0),
  //           child: AutoSizeText(
  //             "${authData.email ?? 'Anonymous'}",
  //             style: TextStyle(fontSize: 20),
  //           ),
  //         ),
  //         showSignOut(context, authData.isAnonymous)
  //       ],
  //     ),
  //   );
  // }

  // Widget displayUserInformation(context, snapshot) {
  //   final authData = snapshot.data;
  //   return FutureBuilder(
  //       future: getProfilePictureDownloadUrl(),
  //       builder: (context, snapshot) {
  //         if (snapshot.connectionState == ConnectionState.done) {
  //           // return Container(
  //           //   width: 100,
  //           //   height: 100,
  //           //   child: Image.network(userProfilePictureUrl),
  //           // );
  //           return Padding(
  //             padding: const EdgeInsets.all(8.0),
  //             child: Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 CircleAvatar(
  //                   backgroundImage:
  //                       NetworkImage(userProfilePictureDownloadUrl),
  //                   radius: 50,
  //                 ),
  //                 SizedBox(
  //                   height: 100,
  //                   child: Column(
  //                     children: <Widget>[
  //                       Expanded(
  //                         child: Text(
  //                           "Ongoing gigs",
  //                           style: TextStyle(fontSize: 18),
  //                         ),
  //                       ),
  //                       StreamBuilder(
  //                         stream: DatabaseService().userData(authData.uid),
  //                         builder: (context, snapshot) {
  //                           if (!snapshot.hasData) {
  //                             return CircularProgressIndicator();
  //                           } else if ((snapshot.hasData &&
  //                               snapshot.data.ongoingGigsByGigId == null)) {
  //                             return Expanded(
  //                               child: Text(
  //                                 '0',
  //                                 style: TextStyle(fontSize: 18),
  //                               ),
  //                             );
  //                           } else {
  //                             return Expanded(
  //                                 child: Text(
  //                               '${snapshot.data.ongoingGigsByGigId.length}',
  //                               style: TextStyle(fontSize: 18),
  //                             ));
  //                           }
  //                         },
  //                       )
  //                     ],
  //                   ),
  //                 ),
  //                 SizedBox(
  //                   height: 100,
  //                   child: Column(
  //                     children: <Widget>[
  //                       Expanded(
  //                         child: Text(
  //                           "Completed gigs",
  //                           style: TextStyle(fontSize: 18),
  //                         ),
  //                       ),
  //                       Expanded(
  //                         child: Text(
  //                           "5",
  //                           style: TextStyle(fontSize: 18),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           );
  //         } else {
  //           return Container(
  //             width: 70,
  //             height: 70,
  //             child: CircularProgressIndicator(
  //               valueColor: AlwaysStoppedAnimation<Color>(
  //                   FyreworkrColors.fyreworkBlack),
  //             ),
  //           );
  //         }
  //       });
  // }

}
