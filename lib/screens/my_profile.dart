import 'dart:async';
import 'package:Fyrework/ui/widgets/profileEditingSideMenu.dart';
import 'package:Fyrework/ui/widgets/profile_rating_stars.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:Fyrework/models/myUser.dart';
import 'package:Fyrework/screens/authenticate/app_start.dart';
import 'package:Fyrework/services/database.dart';
import 'package:Fyrework/ui/views/sign_up_view.dart';
import 'package:Fyrework/services/auth_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:Fyrework/ui/widgets/userRelated_gigItem.dart';
import 'package:url_launcher/url_launcher.dart';

class MyProfileView extends StatefulWidget {
  @override
  _MyProfileViewState createState() => _MyProfileViewState();
  static String myPhoneNumber;
}

class _MyProfileViewState extends State<MyProfileView> {
  @override
  void initState() {
    super.initState();
  }

  final String currentUserId = MyUser.uid;
  AuthFormType authFormType;
  final String shieldCheck = 'assets/svgs/light/shield-check.svg';
  final String lock = 'assets/svgs/light/lock.svg';
  final String balanceScale = 'assets/svgs/light/balance-scale.svg';
  final String userIcon = 'assets/svgs/light/user.svg';
  final String legals = 'assets/svgs/light/file-contract.svg';
  final String signOut = 'assets/svgs/light/sign-out-alt.svg';
  final String policies = 'assets/svgs/light/file-signature.svg';
  final String grid = 'assets/svgs/light/th.svg';

  // signing up with phone number
  Future verifyPhoneNumber(String phone, BuildContext context) async {
    final _codeController = TextEditingController();
    FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: Duration(seconds: 30),
        verificationCompleted: (AuthCredential authCredential) {
          setState(() {
            MyProfileView.myPhoneNumber = phone;
            MyUser.phoneNumber = phone;
          });
        },
        verificationFailed: (FirebaseAuthException exception) {
          // return "error";
        },
        codeSent: (String verificationId, [int forceResendingToken]) {
          return;
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          verificationId = verificationId;
          print(verificationId);
          print("Timeout");
        });
  }

  // Widget phoneVerifyer() {
  //   return Container(
  //     child: InternationalPhoneNumberInput(
  //       onInputChanged: (PhoneNumber number) {
  //         print(number.phoneNumber);
  //         setState(() {
  //           _phoneNumberToVerify = number.toString();
  //         });
  //       },
  //       onInputValidated: (bool value) {
  //         print(value);
  //       },
  //       ignoreBlank: false,
  //       autoValidateMode: AutovalidateMode.always,
  //       // autoValidate: false,
  //       selectorTextStyle: TextStyle(color: Colors.black),
  //       textFieldController: _myNewPhoneNumberController,
  //       keyboardType: TextInputType.number,
  //       // selectorType: PhoneInputSelectorType.DIALOG,
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    // _myFavoriteHashtagsController.text =
    //     '${MyUser.favoriteHashtags.map((h) => h.toString())}';
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Scaffold(
            appBar: AppBar(
              elevation: 0.0,
              automaticallyImplyLeading: false,
              titleSpacing: 0,
              leadingWidth: 0,
              leading: Container(
                width: 0,
                height: 0,
              ),
              title: Row(
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                    child: Text(
                      MyUser.username,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                ],
              ),
            ),
            endDrawer: myProfileDrawer(),
            body: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child: StreamBuilder(
                      stream:
                          DatabaseService().fetchUserData(userId: MyUser.uid),
                      builder: (context, snapshot) {
                        return Row(
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
                                      image: imageProvider, fit: BoxFit.cover),
                                ),
                              ),
                              imageUrl: MyUser.userAvatarUrl,
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
                                              snapshot.data.openGigsByGigId !=
                                                      null
                                                  ? '${snapshot.data.lengthOfOpenGigsByGigId}'
                                                  : '0',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1,
                                            ),
                                          )
                                        : Container(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 1,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
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
                                crossAxisAlignment: CrossAxisAlignment.center,
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
                                                  ? '${snapshot.data.lengthOfCompletedGigsByGigId}'
                                                  : '0',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1,
                                            ),
                                          )
                                        : Container(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 1,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                      Theme.of(context)
                                                          .primaryColor),
                                            ),
                                          ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 0, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          MyUser.name,
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: 100,
                          // height: 20,
                          child: ProfileRatingStars(userId: MyUser.uid),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          MyUser.location,
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
                            indicatorColor: Theme.of(context).primaryColor,
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
                        // backgroundColor: FyreworkrColors.fyreworkBlack),
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
          ),
        ),
      ),
    );
  }

  Widget myProfileDrawer() {
    var platform = Theme.of(context).platform;

    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          border: Border(
            left: BorderSide(color: Colors.grey[50], width: 0.5),
          )),
      width: MediaQuery.of(context).size.width / 1.5,
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          Expanded(child: generalSideMenu(platform)),
          showSignOut(context)
        ],
      ),
    );
  }

  ListView generalSideMenu(TargetPlatform platform) {
    return ListView(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
              border: Border(
            bottom: BorderSide(color: Theme.of(context).hintColor, width: 0.5),
          )),
          child: ListTile(
            contentPadding: EdgeInsets.fromLTRB(8.0, 0, 0, 0),
            leading: Text(
              '${MyUser.name}',
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  .copyWith(color: Theme.of(context).accentColor),
            ),
          ),
        ),
        GestureDetector(
            child: ListTile(
              contentPadding: EdgeInsets.fromLTRB(8.0, 0, 0, 0),
              leading: Container(
                width: 100,
                child: Row(
                  children: [
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: SvgPicture.asset(
                        userIcon,
                        semanticsLabel: 'user',
                        color: Theme.of(context).accentColor,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Profile',
                      style: Theme.of(context).textTheme.bodyText1.copyWith(
                            color: Theme.of(context).accentColor,
                          ),
                    ),
                  ],
                ),
              ),
              trailing: Icon(Icons.chevron_right,
                  color: Theme.of(context).accentColor),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProfileEditingSideMenu()));
            }),
        GestureDetector(
          child: ListTile(
            contentPadding: EdgeInsets.fromLTRB(8.0, 0, 0, 0),
            leading: Container(
              width: 100,
              child: Row(
                children: [
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: SvgPicture.asset(
                      balanceScale,
                      semanticsLabel: 'terms',
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Terms',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(color: Theme.of(context).accentColor),
                  ),
                ],
              ),
            ),
            trailing:
                Icon(Icons.chevron_right, color: Theme.of(context).accentColor),
          ),
          onTap: () async {
            const url = 'http://districthive.com/terms.php';
            if (await canLaunch(url)) {
              await launch(url, forceWebView: true, enableJavaScript: true);
            } else {
              // throw 'Could not launch $url';
              showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                        title: Text(
                          "Something went wrong",
                          style: TextStyle(fontSize: 16),
                        ),
                        content: FlatButton(
                          color: Theme.of(context).primaryColor,
                          onPressed: () {
                            Navigator.of(context, rootNavigator: true).pop();
                          },
                          child: Text(
                            'Dismiss',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(color: Theme.of(context).accentColor),
                          ),
                        ),
                      ));
            }
          },
        ),
        GestureDetector(
          child: ListTile(
            contentPadding: EdgeInsets.fromLTRB(8.0, 0, 0, 0),
            leading: Container(
              width: 100,
              child: Row(
                children: [
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: SvgPicture.asset(
                      lock,
                      semanticsLabel: 'lock',
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Privacy',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(color: Theme.of(context).accentColor),
                  ),
                ],
              ),
            ),
            trailing:
                Icon(Icons.chevron_right, color: Theme.of(context).accentColor),
          ),
          onTap: () async {
            // const url = 'http://districthive.com/privacy.php';
            const url = 'https://google.com';
            if (await canLaunch(url)) {
              await launch(url, forceWebView: true, enableJavaScript: true);
            } else {
              // throw 'Could not launch $url';
              showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                        title: Text(
                          "Something went wrong",
                          style: TextStyle(fontSize: 16),
                        ),
                        content: FlatButton(
                          color: Theme.of(context).primaryColor,
                          onPressed: () {
                            Navigator.of(context, rootNavigator: true).pop();
                          },
                          child: Text(
                            'Dismiss',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(color: Theme.of(context).accentColor),
                          ),
                        ),
                      ));
            }
          },
        ),
        GestureDetector(
          child: ListTile(
            contentPadding: EdgeInsets.fromLTRB(8.0, 0, 0, 0),
            leading: Container(
              width: 200,
              child: Row(
                children: [
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: SvgPicture.asset(
                      shieldCheck,
                      semanticsLabel: 'shield-check',
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Safety & Security',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(color: Theme.of(context).accentColor),
                  ),
                ],
              ),
            ),
            trailing:
                Icon(Icons.chevron_right, color: Theme.of(context).accentColor),
          ),
          onTap: () {},
        ),
        GestureDetector(
          child: ListTile(
            contentPadding: EdgeInsets.fromLTRB(8.0, 0, 0, 0),
            leading: Container(
              width: 200,
              child: Row(
                children: [
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: SvgPicture.asset(
                      policies,
                      semanticsLabel: 'Rules & Policies',
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Rules & Policies',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(color: Theme.of(context).accentColor),
                  ),
                ],
              ),
            ),
            trailing:
                Icon(Icons.chevron_right, color: Theme.of(context).accentColor),
          ),
          onTap: () {},
        ),
        GestureDetector(
          child: ListTile(
            contentPadding: EdgeInsets.fromLTRB(8.0, 0, 0, 0),
            leading: Container(
              width: 100,
              child: Row(
                children: [
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: SvgPicture.asset(
                      legals,
                      semanticsLabel: 'legals',
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Legals',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(color: Theme.of(context).accentColor),
                  ),
                ],
              ),
            ),
            trailing:
                Icon(Icons.chevron_right, color: Theme.of(context).accentColor),
          ),
          onTap: () {},
        ),
      ],
    );
  }

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
                  child: Text("Open gigs",
                      style: Theme.of(context).textTheme.bodyText1),
                ),
                Expanded(
                  child: Text(
                      MyUser.openGigsByGigId != null
                          ? '${MyUser.openGigsByGigId.length}'
                          : '0',
                      style: Theme.of(context).textTheme.bodyText1),
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
                  child:
                      Text("5", style: Theme.of(context).textTheme.bodyText1),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  userOpenGigs() {
    return StreamBuilder<QuerySnapshot>(
      stream: DatabaseService().openGigsByGigRelatedUsers(userId: MyUser.uid),
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
                          "You have no open gigs",
                          style: Theme.of(context).textTheme.bodyText1,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ));
      },
    );
  }

  userCompletedGigs() {
    return StreamBuilder<QuerySnapshot>(
      stream:
          DatabaseService().completedGigsByGigRelatedUsers(userId: MyUser.uid),
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
                          "You have no completed gigs",
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
      stream: DatabaseService().likedGigsByLikersByUserId(userId: MyUser.uid),
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
                          "You have no liked gigs",
                          style: Theme.of(context).textTheme.bodyText1,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ));
      },
    );
  }

  Widget showSignOut(context) {
    return ListTile(
      contentPadding: EdgeInsets.fromLTRB(8.0, 0, 0, 0),
      leading: Container(
        width: 200,
        child: Row(
          children: [
            SizedBox(
              width: 16,
              height: 16,
              child: SvgPicture.asset(
                signOut,
                semanticsLabel: 'sign out',
                color: Theme.of(context).accentColor,
              ),
            ),
            Container(
              width: 5.0,
            ),
            GestureDetector(
              child: Text(
                'Log out',
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    .copyWith(color: Theme.of(context).accentColor),
              ),
              onTap: () async {
                try {
                  await AuthService().signOut();
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => StartPage()),
                      (Route<dynamic> route) => false);
                } catch (e) {
                  print(e);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
