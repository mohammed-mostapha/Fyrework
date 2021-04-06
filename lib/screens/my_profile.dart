import 'dart:async';
import 'package:Fyrework/ui/widgets/profileEditingSideMenu.dart';
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

  AuthFormType authFormType;
  bool profileEditingMenu = false;
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
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Container(
              padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: Text(
                MyUser.username,
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    .copyWith(color: Theme.of(context).accentColor),
              ),
            ),
          ),
          endDrawer: myProfileDrawer(),
          backgroundColor: Theme.of(context).primaryColor,
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
                                    "Ongoing",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .copyWith(
                                            color:
                                                Theme.of(context).accentColor),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Center(
                                  child: Text(
                                    MyUser.ongoingGigsByGigId != null
                                        ? '${MyUser.ongoingGigsByGigId.length}'
                                        : '0',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .copyWith(
                                            color:
                                                Theme.of(context).accentColor),
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
                                        .bodyText1
                                        .copyWith(
                                            color:
                                                Theme.of(context).accentColor),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Center(
                                  child: Text(
                                    "5",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .copyWith(
                                            color:
                                                Theme.of(context).accentColor),
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
                    padding: EdgeInsets.fromLTRB(10, 0, 0, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: [
                            Text(
                              // widget.passedUserFullName,
                              MyUser.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .copyWith(
                                      color: Theme.of(context).accentColor),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Container(
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    'no.',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .copyWith(
                                            color:
                                                Theme.of(context).accentColor),
                                  ),
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
                        Text(
                          MyUser.location,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              .copyWith(color: Theme.of(context).accentColor),
                        ),
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
                                Tab(
                                  child: FaIcon(
                                    FontAwesomeIcons.star,
                                    size: 16,
                                    color: Theme.of(context).primaryColor,
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

  Widget myProfileDrawer() {
    var platform = Theme.of(context).platform;

    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          border: Border(
            left: BorderSide(color: Colors.grey[50], width: 0.5),
          )),
      width: !profileEditingMenu
          ? MediaQuery.of(context).size.width / 1.5
          : MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          Expanded(
              child: !profileEditingMenu
                  ? generalSideMenu(platform)
                  : ProfileEditingSideMenu()),
          !profileEditingMenu ? showSignOut(context) : Container(),
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
            bottom: BorderSide(color: Colors.grey[50], width: 0.5),
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
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Profile',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(color: Theme.of(context).accentColor),
                  ),
                ],
              ),
            ),
            trailing: Icon(Icons.chevron_right, color: Colors.white),
          ),
          onTap: () {
            setState(() {
              profileEditingMenu = true;
            });
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
                      balanceScale,
                      semanticsLabel: 'terms',
                      color: Colors.white,
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
            trailing: Icon(Icons.chevron_right, color: Colors.white),
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
                      color: Colors.white,
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
            trailing: Icon(Icons.chevron_right, color: Colors.white),
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
                      color: Colors.white,
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
            trailing: Icon(Icons.chevron_right, color: Colors.white),
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
                      semanticsLabel: 'user',
                      color: Colors.white,
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
            trailing: Icon(Icons.chevron_right, color: Colors.white),
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
                      color: Colors.white,
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
            trailing: Icon(Icons.chevron_right, color: Colors.white),
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
                  child: Text("Ongoing gigs",
                      style: Theme.of(context).textTheme.bodyText1),
                ),
                Expanded(
                  child: Text(
                      MyUser.ongoingGigsByGigId != null
                          ? '${MyUser.ongoingGigsByGigId.length}'
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

  userOngoingGigs() {
    return FutureBuilder<QuerySnapshot>(
      future: DatabaseService().myOngoingGigsByGigOwnerId(MyUser.uid),
      builder: (context, snapshot) {
        // print('snapshot.data: ${snapshot.data.documents.length}');
        return !snapshot.hasData
            ? Text('')
            : snapshot.data.docs.length > 0
                ? ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot data = snapshot.data.docs[index];
                      Map getDocData = data.data();
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
                color: Colors.white,
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
