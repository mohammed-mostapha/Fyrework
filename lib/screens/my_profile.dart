import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';

import 'package:myApp/models/myUser.dart';
import 'package:myApp/screens/authenticate/app_start.dart';
import 'package:myApp/services/database.dart';
import 'package:myApp/services/places_autocomplete.dart';
import 'package:myApp/ui/shared/constants.dart';
import 'package:myApp/ui/views/sign_up_view.dart';
import 'package:myApp/ui/shared/theme.dart';
import 'package:myApp/services/auth_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:myApp/ui/widgets/userRelated_gigItem.dart';

class MyProfileView extends StatefulWidget {
  @override
  _MyProfileViewState createState() => _MyProfileViewState();
}

class _MyProfileViewState extends State<MyProfileView> {
  // AuthService _authService = locator.get<AuthService>();
  // StorageRepo _storageRepo = locator.get<StorageRepo>();
  AuthFormType authFormType;
  bool profileEditingMenu = false;
  final String shieldCheck = 'assets/svgs/shield-check.svg';
  final String lock = 'assets/svgs/lock.svg';
  final String balanceScale = 'assets/svgs/balance-scale.svg';
  final String userIcon = 'assets/svgs/user.svg';
  final String legals = 'assets/svgs/file-contract.svg';
  final String signOut = 'assets/svgs/sign-out-alt.svg';
  final String policies = 'assets/svgs/file-signature.svg';

  TextEditingController _myNewHashtag = TextEditingController();
  TextEditingController _myNewUsername = TextEditingController();
  TextEditingController _myNewName = TextEditingController();
  TextEditingController _myNewEmailaddress = TextEditingController();
  TextEditingController _myNewPhoneNumber = TextEditingController();

  getUserLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemarks = await Geolocator()
        .placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark placemark = placemarks[0];
    // String completeAddress =
    //     '${placemark.subThoroughfare} ${placemark.thoroughfare}, ${placemark.subLocality} ${placemark.locality}, ${placemark.subAdministrativeArea}, ${placemark.administrativeArea} ${placemark.postalCode}, ${placemark.country}';
    // print(completeAddress);
    String formattedAddress = "${placemark.locality}, ${placemark.country}";
    setState(() {
      PlacesAutocomplete.placesAutoCompleteController.text = formattedAddress;
      print('${PlacesAutocomplete.placesAutoCompleteController.text}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Container(
              padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: Text(
                MyUser.username,
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.normal),
              ),
            ),
          ),
          endDrawer: myProfileDrawer(),
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

  Widget myProfileDrawer() {
    var platform = Theme.of(context).platform;

    return Container(
      decoration: BoxDecoration(
          color: FyreworkrColors.fyreworkBlack,
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
                : profileEditingSideMenu(platform),
          ),
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
            leading: Text('${MyUser.name}',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                )),
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
                    style: TextStyle(fontSize: 16, color: Colors.white),
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
                    style: TextStyle(fontSize: 16, color: Colors.white),
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
                    style: TextStyle(fontSize: 16, color: Colors.white),
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
                  // FaIcon(
                  //   FontAwesomeIcons.shieldAlt,
                  //   color: Colors.white,
                  //   size: 16,
                  // ),
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
                    style: TextStyle(fontSize: 16, color: Colors.white),
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
                    style: TextStyle(fontSize: 16, color: Colors.white),
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
                    style: TextStyle(fontSize: 16, color: Colors.white),
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

  ListView profileEditingSideMenu(TargetPlatform platform) {
    return ListView(
      children: <Widget>[
        ListTile(
          contentPadding: EdgeInsets.fromLTRB(8.0, 0, 0, 0),
          leading: Icon(
            Icons.chevron_left,
            color: Colors.white,
          ),
          onTap: () {
            setState(() {
              profileEditingMenu = false;
            });
          },
        ),
        ListTile(
          contentPadding: EdgeInsets.fromLTRB(8.0, 0, 0, 0),
          leading: Container(
            padding: EdgeInsets.fromLTRB(0, 1.5, 0, 0),
            child: Text(
              'Profile Picture',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
          trailing: Container(
            width: MediaQuery.of(context).size.width / 1.5,
            child: Row(
              children: <Widget>[
                CachedNetworkImage(
                  imageBuilder: (context, imageProvider) => Container(
                    width: 50.0,
                    height: 50.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: imageProvider, fit: BoxFit.cover),
                    ),
                  ),
                  imageUrl: MyUser.userAvatarUrl,
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
                SizedBox(
                  width: 20,
                ),
                GestureDetector(
                  child: Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 25,
                  ),
                  onTap: () {
                    print('camera clicked');
                  },
                )
              ],
            ),
          ),
        ),
        GestureDetector(
          child: ListTile(
            contentPadding: EdgeInsets.fromLTRB(8.0, 0, 0, 0),
            leading: Container(
              padding: EdgeInsets.fromLTRB(0, 1.5, 0, 0),
              child: Text('#Hashtag',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  )),
            ),
            trailing: Container(
              width: MediaQuery.of(context).size.width / 1.5,
              child: TextFormField(
                validator: EmailValidator.validate,
                style: TextStyle(fontSize: 16.0, color: Colors.white),
                decoration: profileEditingInputDecoration('#Hashtag'),
                onChanged: (val) {
                  setState(() => _myNewHashtag.text = val);
                },
                onSaved: (val) => _myNewHashtag.text = val,
              ),
            ),
          ),
          onTap: () {},
        ),
        GestureDetector(
          child: ListTile(
            contentPadding: EdgeInsets.fromLTRB(8.0, 0, 0, 0),
            leading: Container(
              padding: EdgeInsets.fromLTRB(0, 1.5, 0, 0),
              child: Text('Username',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  )),
            ),
            trailing: Container(
              width: MediaQuery.of(context).size.width / 1.5,
              child: TextFormField(
                validator: EmailValidator.validate,
                style: TextStyle(fontSize: 16.0, color: Colors.white),
                decoration: profileEditingInputDecoration('Username'),
                onChanged: (val) {
                  setState(() => _myNewUsername.text = val);
                },
                onSaved: (val) => _myNewUsername.text = val,
              ),
            ),
          ),
          onTap: () {},
        ),
        GestureDetector(
          child: ListTile(
            contentPadding: EdgeInsets.fromLTRB(8.0, 0, 0, 0),
            leading: Container(
              padding: EdgeInsets.fromLTRB(0, 1.5, 0, 0),
              child: Text('Name',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  )),
            ),
            trailing: Container(
              width: MediaQuery.of(context).size.width / 1.5,
              child: TextFormField(
                validator: EmailValidator.validate,
                style: TextStyle(fontSize: 16.0, color: Colors.white),
                decoration: profileEditingInputDecoration('Name'),
                onChanged: (val) {
                  setState(() => _myNewName.text = val);
                },
                onSaved: (val) => _myNewName.text = val,
              ),
            ),
          ),
          onTap: () {},
        ),
        GestureDetector(
          child: ListTile(
            contentPadding: EdgeInsets.fromLTRB(8.0, 0, 0, 0),
            leading: Container(
              padding: EdgeInsets.fromLTRB(0, 1.5, 0, 0),
              child: Text('Email address',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  )),
            ),
            trailing: Container(
              width: MediaQuery.of(context).size.width / 1.5,
              child: TextFormField(
                validator: EmailValidator.validate,
                style: TextStyle(fontSize: 16.0, color: Colors.white),
                decoration: profileEditingInputDecoration('Email address'),
                onChanged: (val) {
                  setState(() => _myNewEmailaddress.text = val);
                },
                onSaved: (val) => _myNewEmailaddress.text = val,
              ),
            ),
          ),
          onTap: () {},
        ),
        GestureDetector(
          child: ListTile(
            contentPadding: EdgeInsets.fromLTRB(8.0, 0, 0, 0),
            leading: Container(
              padding: EdgeInsets.fromLTRB(0, 1.5, 0, 0),
              child: Text('location',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  )),
            ),
            trailing: Container(
              padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
              width: MediaQuery.of(context).size.width / 1.5,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
                    child: PlacesAutocomplete(
                      signUpDecoraiton: false,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    child: Icon(
                      Icons.gps_fixed,
                      color: Colors.white,
                      size: 25,
                    ),
                    onTap: () {
                      getUserLocation();
                    },
                  ),
                ],
              ),
            ),
          ),
          onTap: () {},
        ),
        GestureDetector(
          child: ListTile(
            contentPadding: EdgeInsets.fromLTRB(8.0, 0, 0, 0),
            leading: Container(
              padding: EdgeInsets.fromLTRB(0, 1.5, 0, 0),
              child: Text('Mobile number',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  )),
            ),
            trailing: Container(
              width: MediaQuery.of(context).size.width / 1.5,
              child: TextFormField(
                decoration: profileEditingInputDecoration('Mobile number'),
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
                // Only numbers can be entered
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  WhitelistingTextInputFormatter.digitsOnly
                ],
                onChanged: (val) {
                  setState(() => _myNewPhoneNumber.text = val);
                },
                onSaved: (value) => _myNewPhoneNumber.text = value,
                validator: (value) => value.isEmpty ? '*' : null,
              ),
            ),
          ),
          onTap: () {},
        ),
        ListTile(
          contentPadding: EdgeInsets.fromLTRB(0, 0, 10, 0),
          trailing: FlatButton(
            color: Colors.white,
            onPressed: () {},
            child: Text(
              'Save',
              style: TextStyle(fontSize: 16),
            ),
          ),
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
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              onTap: () async {
                try {
                  // await Provider.of(context).auth.signOut();
                  await AuthService().signOut();
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => StartPage()));
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
