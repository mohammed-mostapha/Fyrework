import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:myApp/locator.dart';

import 'package:myApp/models/myUser.dart';
import 'package:myApp/screens/authenticate/app_start.dart';
import 'package:myApp/services/database.dart';
import 'package:myApp/services/places_autocomplete.dart';
import 'package:myApp/services/storage_repo.dart';
import 'package:myApp/ui/shared/constants.dart';
import 'package:myApp/ui/views/sign_up_view.dart';
import 'package:myApp/ui/shared/theme.dart';
import 'package:myApp/services/auth_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:myApp/ui/widgets/userRelated_gigItem.dart';
import 'package:myApp/view_controllers/myUser_controller.dart';
import 'package:photo_manager/photo_manager.dart';

import 'add_gig/assets_picker/constants/picker_model.dart';
import 'add_gig/assets_picker/src/widget/asset_picker.dart';
import 'package:myApp/services/popularHashtags.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class MyProfileView extends StatefulWidget {
  @override
  _MyProfileViewState createState() => _MyProfileViewState();
  static String myPhoneNumber;
}

class _MyProfileViewState extends State<MyProfileView> {
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

  final int maxAssetsCount = 1;

  List<AssetEntity> selectedProfilePictureList;
  File extractedProfilePictureFromList;
  File _myNewProfileImage;
  String _phoneNumberToVerify;

  final editMyProfileFormKey = GlobalKey<FormState>();
  String _updatedProfileAvatar;
  TextEditingController _myFavoriteHashtagsController = TextEditingController();
  TextEditingController _myNewUsername =
      TextEditingController(text: MyUser.username);
  TextEditingController _myNewName = TextEditingController(text: MyUser.name);
  TextEditingController _myNewEmailaddress =
      TextEditingController(text: MyUser.email);
  TextEditingController _myNewPhoneNumberController = TextEditingController(
      text: MyUser.phoneNumber == null ? '' : MyUser.phoneNumber);
  String myNewLocation = PlacesAutocomplete.placesAutoCompleteController.text;

  List _myFavoriteHashtags = List();

  String clientSideWarning;
  String serverSideWarning;

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

  navigateToSelectProfilePicture() async {
    ((BuildContext context, int index) async {
      final PickMethodModel model = pickMethods[index];

      final List<AssetEntity> retrievedAssets =
          await model.method(context, selectedProfilePictureList);
      print(
          'this is the type you are searching for: ${retrievedAssets.runtimeType}');
      if (retrievedAssets != null &&
          retrievedAssets != selectedProfilePictureList) {
        selectedProfilePictureList = retrievedAssets;
        () async {
          print('from the self executed function');
          extractedProfilePictureFromList =
              await selectedProfilePictureList.first.originFile;
          if (mounted) {
            setState(() {});
            _myNewProfileImage = extractedProfilePictureFromList;
          }
        }();
      }
    }(context, 0));
  }

  List<PickMethodModel> get pickMethods => <PickMethodModel>[
        PickMethodModel(
          // icon: '📹',
          // name: 'Common picker',
          // description: 'Pick images and videos.',
          method: (
            BuildContext context,
            List<AssetEntity> assets,
          ) async {
            return await AssetPicker.pickAssets(
              context,
              maxAssets: maxAssetsCount,
              selectedAssets: assets,
              requestType: RequestType.image,
            );
          },
        ),
      ];

  bool validate() {
    final form = editMyProfileFormKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  void editMyProfile() async {
    try {
      if (validate() && _myNewProfileImage != null) {
        EasyLoading.show();
        //deleting current profile picture
        await StorageRepo().deleteProfilePicture(MyUser.userAvatarUrl);

        // then upload the new pic
        _updatedProfileAvatar = await locator
            .get<StorageRepo>()
            .uploadProfilePicture(_myNewProfileImage, MyUser.uid);

        await DatabaseService()
            .updateMyProfilePicture(MyUser.uid, _updatedProfileAvatar);
        EasyLoading.dismiss().then(
          (value) => EasyLoading.showSuccess(''),
        );
      }

      if (validate()) {
        EasyLoading.show();
        await DatabaseService().updateMyProfileData(
          MyUser.uid,
          _myFavoriteHashtagsController.text,
          _myNewUsername.text,
          _myNewName.text,
          _myNewEmailaddress.text,
          PlacesAutocomplete.placesAutoCompleteController.text,
          // _myNewPhoneNumberController.text,
          _phoneNumberToVerify,
        );
        EasyLoading.dismiss().then(
          (value) => EasyLoading.showSuccess(''),
        );
      }
    } catch (e) {
      print(e);
      EasyLoading.dismiss().then(
        (value) => EasyLoading.showError(''),
      );
    }

    await MyUserController().getCurrentUserFromFirebase(MyUser.uid);

    setState(() {});
  }

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

          // showDialog(
          //     context: context,
          //     builder: (context) => Container(
          //           child: Center(
          //             child: AlertDialog(
          //               title: Text('Verification completed'),
          //               content: FlatButton(
          //                 color: Theme.of(context).primaryColor,
          //                 onPressed: () {
          //                   print(
          //                       'verification completed - MyUser.phoneNumber: ${MyUser.phoneNumber}');
          //                   Navigator.of(context, rootNavigator: true).pop();
          //                 },
          //                 child: Text(
          //                   'Dismiss',
          //                   style: TextStyle(
          //                     fontSize: 16,
          //                     color: Colors.white,
          //                   ),
          //                 ),
          //               ),
          //             ),
          //           ),
          //         ));
          // _firebaseAuth
          //     .signInWithCredential(authCredential)
          //     .then((AuthResult result) {
          //   Navigator.of(context).pushReplacementNamed('/home');
          // }).catchError((e) {
          //   return "error";
          // });
        },
        verificationFailed: (AuthException exception) {
          // return "error";
          showDialog(
              context: context,
              builder: (context) => Container(
                    // height: 200,
                    child: Center(
                      child: AlertDialog(
                        title: Text('Verification failed'),
                        content: FlatButton(
                          color: Theme.of(context).primaryColor,
                          onPressed: () {
                            Navigator.of(context, rootNavigator: true).pop();
                          },
                          child: Text(
                            'Dismiss',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ));
        },
        codeSent: (String verificationId, [int forceResendingToken]) {
          return;
          // showDialog(
          //     context: context,
          //     barrierDismissible: true,
          //     builder: (context) => Container(
          //           child: Center(
          //             child: AlertDialog(
          //               title: Text('Enter code from sms'),
          //               content: Column(
          //                 mainAxisSize: MainAxisSize.min,
          //                 children: <Widget>[
          //                   TextField(
          //                     controller: _codeController,
          //                   )
          //                 ],
          //               ),
          //               actions: <Widget>[
          //                 FlatButton(
          //                   child: Text("submit"),
          //                   textColor: FyreworkrColors.white,
          //                   color: Theme.of(context).primaryColor,
          //                   onPressed: () async {
          //                     // try {
          //                     //   await _firebaseAuth
          //                     //       .signInWithCredential(
          //                     //           PhoneAuthProvider.getCredential(
          //                     //               verificationId: verificationId,
          //                     //               smsCode:
          //                     //                   _codeController.text.trim()))
          //                     //       .then((value) async {
          //                     //     if (value.user != null) {
          //                     //       MyUser.phoneNumber = phone;
          //                     //       MyProfileView.myPhoneNumber = phone;
          //                     //     }
          //                     //     print('print: all good');
          //                     //     Navigator.of(context).pop();
          //                     //   });

          //                     //   // }).catchError((e) {
          //                     //   //   return "error";
          //                     //   // });
          //                     // } catch (e) {
          //                     //   FocusScope.of(context).unfocus();
          //                     //   showDialog(
          //                     //       context: context,
          //                     //       builder: (context) => Container(
          //                     //             child: Center(
          //                     //               child: AlertDialog(
          //                     //                 title:
          //                     //                     Text('Verification failed'),
          //                     //                 content: FlatButton(
          //                     //                   color: Theme.of(context)
          //                     //                       .primaryColor,
          //                     //                   onPressed: () {
          //                     //                     Navigator.of(context).pop();
          //                     //                   },
          //                     //                   child: Text(
          //                     //                     'Dismiss',
          //                     //                     style: TextStyle(
          //                     //                       fontSize: 16,
          //                     //                       color: Colors.white,
          //                     //                     ),
          //                     //                   ),
          //                     //                 ),
          //                     //               ),
          //                     //             ),
          //                     //           ));
          //                     // }
          //                   },
          //                 )
          //               ],
          //             ),
          //           ),
          //         ));
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          verificationId = verificationId;
          print(verificationId);
          print("Timeout");
        });
  }

  Widget phoneVerifyer() {
    return Container(
      child: InternationalPhoneNumberInput(
        onInputChanged: (PhoneNumber number) {
          print(number.phoneNumber);
          setState(() {
            _phoneNumberToVerify = number.toString();
          });
        },
        onInputValidated: (bool value) {
          print(value);
        },
        ignoreBlank: false,
        autoValidate: false,
        selectorTextStyle: TextStyle(color: Colors.black),
        textFieldController: _myNewPhoneNumberController,
        // inputBorder: OutlineInputBorder(),
        selectorType: PhoneInputSelectorType.DIALOG,
      ),
    );
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
                                    child: SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: SvgPicture.asset(
                                    grid,
                                    semanticsLabel: 'grid',
                                    color: FyreworkrColors.fyreworkBlack,
                                  ),
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

  Widget serverSideAlert() {
    if (serverSideWarning != null) {
      scrollController.animateTo(0,
          duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
      return Container(
        color: FyreworkrColors.fyreworkBlack,
        width: double.infinity,
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(
                Icons.error_outline,
                color: Colors.white,
              ),
            ),
            Expanded(
              child: Text(
                serverSideWarning,
                maxLines: 3,
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: IconButton(
                icon: Icon(
                  Icons.close,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    serverSideWarning = null;
                  });
                },
              ),
            )
          ],
        ),
      );
    }
    return SizedBox(
      height: 0,
    );
  }

  Widget clientSideAlert() {
    if (clientSideWarning != null) {
      scrollController.animateTo(0,
          duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
      return Container(
        color: FyreworkrColors.fyreworkBlack,
        width: double.infinity,
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(
                Icons.error_outline,
                color: Colors.white,
              ),
            ),
            Expanded(
              child: Text(
                clientSideWarning,
                maxLines: 3,
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: IconButton(
                icon: Icon(
                  Icons.close,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    clientSideWarning = null;
                  });
                },
              ),
            )
          ],
        ),
      );
    }
    return SizedBox(
      height: 0,
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
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
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
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ],
              ),
            ),
            trailing: Icon(Icons.chevron_right, color: Colors.white),
          ),
          onTap: () async {
            const url = 'http://districthive.com/privacy.php';
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
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
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

  Form profileEditingSideMenu(TargetPlatform platform) {
    return Form(
      key: editMyProfileFormKey,
      child: ListView(
        children: <Widget>[
          Container(
            width: double.infinity,
            child: Wrap(
              spacing: 2.5,
              children: _myFavoriteHashtags
                  .map((e) => Chip(
                        backgroundColor: Colors.white,
                        label: Text(
                          '$e',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                        onDeleted: () {
                          setState(() {
                            _myFavoriteHashtags
                                .removeWhere((item) => item == e);
                            print(_myFavoriteHashtags.length);
                          });
                        },
                        deleteIconColor: Colors.black,
                      ))
                  .toList(),
            ),
          ),
          ListTile(
            contentPadding: EdgeInsets.fromLTRB(8.0, 0, 0, 0),
            leading: Icon(
              Icons.chevron_left,
              color: Colors.white,
            ),
            onTap: () {
              setState(() {
                profileEditingMenu = false;
                _myNewProfileImage = null;
              });
            },
          ),
          ListTile(
            contentPadding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
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
                  _myNewProfileImage == null
                      ? CachedNetworkImage(
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
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        )
                      : Container(
                          width: 50,
                          height: 50,
                          child: CircleAvatar(
                            // radius: 50.0,
                            backgroundColor: Theme.of(context).primaryColor,
                            backgroundImage:
                                FileImage(File(_myNewProfileImage.path)),
                          ),
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
                      navigateToSelectProfilePicture();
                    },
                  )
                ],
              ),
            ),
          ),
          GestureDetector(
            child: ListTile(
              contentPadding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
              leading: Container(
                padding: EdgeInsets.fromLTRB(0, 1.5, 0, 0),
                child: Text('#Hashtags',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    )),
              ),
              trailing: Container(
                width: MediaQuery.of(context).size.width / 1.5,
                child: Expanded(
                  child: TypeAheadFormField(
                    // initialValue: MyUser.hashtag,
                    validator: (value) => value.isEmpty ? '' : null,
                    onSaved: (value) =>
                        _myFavoriteHashtagsController.text = value,
                    textFieldConfiguration: TextFieldConfiguration(
                      controller: _myFavoriteHashtagsController,
                      style: DefaultTextStyle.of(context)
                          .style
                          .copyWith(fontSize: 16, color: Colors.white),
                      decoration:
                          profileEditingInputDecoration('Favorite #Hashtags'),
                    ),
                    suggestionsCallback: (pattern) async {
                      return await PopularHashtagsService.fetchPopularHashtags(
                          pattern);
                    },
                    itemBuilder: (context, suggestions) {
                      return ListTile(
                        title: Text(suggestions),
                      );
                    },
                    onSuggestionSelected: (suggestion) {
                      // _myFavoriteHashtagsController.text = suggestion;
                      if (_myFavoriteHashtags.length < 20 != true) {
                        setState(() {
                          clientSideWarning = 'Only 20 #Hashtags allowed';
                        });
                      } else if (_myFavoriteHashtagsController
                              .text.isNotEmpty &&
                          !_myFavoriteHashtags.contains(suggestion) &&
                          _myFavoriteHashtags.length < 20) {
                        setState(() {
                          _myFavoriteHashtags.add('#' + suggestion);
                          _myFavoriteHashtagsController.clear();
                          print(_myFavoriteHashtags);
                        });
                      }
                    },
                  ),
                ),
              ),
            ),
            onTap: () {},
          ),
          // TextFormField(
          //         initialValue: 'this is initial',
          //         validator: HashtagValidator.validate,
          //         style: TextStyle(fontSize: 16.0, color: Colors.white),
          //         decoration: profileEditingInputDecoration('#Hashtag'),
          //         // onChanged: (val) {
          //         //   setState(() => _myNewHashtag.text = val);
          //         // },
          //         onSaved: (val) => _myNewHashtag.text = val,
          //       ),

          GestureDetector(
            child: ListTile(
              contentPadding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
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
                child: Expanded(
                  child: Container(
                    child: TextFormField(
                      controller: _myNewUsername,
                      validator: UsernameValidator.validate,
                      style: TextStyle(fontSize: 16.0, color: Colors.white),
                      decoration: profileEditingInputDecoration('Username'),
                      // onChanged: (val) {
                      //   setState(() => _myNewUsername.text = val);
                      // },
                      onSaved: (val) => _myNewUsername.text = val,
                    ),
                  ),
                ),
              ),
            ),
            onTap: () {},
          ),
          GestureDetector(
            child: ListTile(
              contentPadding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
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
                child: Expanded(
                  child: TextFormField(
                    controller: _myNewName,
                    validator: NameValidator.validate,
                    style: TextStyle(fontSize: 16.0, color: Colors.white),
                    decoration: profileEditingInputDecoration('Name'),
                    // onChanged: (val) {
                    //   setState(() => _myNewName.text = val);
                    // },
                    onSaved: (val) => _myNewName.text = val,
                  ),
                ),
              ),
            ),
            onTap: () {},
          ),
          GestureDetector(
            child: ListTile(
              contentPadding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
              leading: Container(
                padding: EdgeInsets.fromLTRB(0, 1.5, 0, 0),
                child: Text('Email',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    )),
              ),
              trailing: Container(
                width: MediaQuery.of(context).size.width / 1.5,
                child: Expanded(
                  child: TextFormField(
                    controller: _myNewEmailaddress,
                    validator: EmailValidator.validate,
                    style: TextStyle(fontSize: 16.0, color: Colors.white),
                    decoration: profileEditingInputDecoration('Email address'),
                    // onChanged: (val) {
                    //   setState(() => _myNewEmailaddress.text = val);
                    // },
                    onSaved: (val) => _myNewEmailaddress.text = val,
                  ),
                ),
              ),
            ),
            onTap: () {},
          ),
          GestureDetector(
            child: ListTile(
              contentPadding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
              leading: Container(
                padding: EdgeInsets.fromLTRB(0, 1.5, 0, 0),
                child: Text('location',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    )),
              ),
              trailing: Container(
                // padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                width: MediaQuery.of(context).size.width / 1.5,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    PlacesAutocomplete(
                      signUpDecoraiton: false,
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
          ),
          // GestureDetector(
          //   child: ListTile(
          //     contentPadding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
          //     leading: Container(
          //       padding: EdgeInsets.fromLTRB(0, 1.5, 0, 0),
          //       child: Text('Mobile number',
          //           style: TextStyle(
          //             fontSize: 16,
          //             color: Colors.white,
          //           )),
          //     ),
          //     trailing: Container(
          //       width: MediaQuery.of(context).size.width / 1.5,
          //       child: Expanded(
          //         child: TextFormField(
          //           controller: _myNewPhoneNumber,
          //           decoration: profileEditingInputDecoration('Mobile number'),
          //           style: TextStyle(
          //             fontSize: 16,
          //             color: Colors.white,
          //           ),
          //           // Only numbers can be entered
          //           keyboardType: TextInputType.number,
          //           inputFormatters: <TextInputFormatter>[
          //             WhitelistingTextInputFormatter.digitsOnly
          //           ],
          //           // onChanged: (val) {
          //           //   setState(() => _myNewPhoneNumber.text = val);
          //           // },
          //           onSaved: (value) => _myNewPhoneNumber.text = value,
          //           // validator: (value) => value.isEmpty ? '' : null,
          //         ),
          //       ),
          //     ),
          //   ),
          //   onTap: () {},
          // ),
          GestureDetector(
              child: ListTile(
            contentPadding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
            leading: Container(
              padding: EdgeInsets.fromLTRB(0, 1.5, 0, 0),
              child: Text('Mobile',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  )),
            ),
            trailing: Container(
                // padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                width: MediaQuery.of(context).size.width / 1.5,
                child: (MyUser.phoneNumber == null || MyUser.phoneNumber == '')
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: phoneVerifyer(),
                          ),
                          GestureDetector(
                            onTap: () {
                              verifyPhoneNumber(_phoneNumberToVerify, context);
                            },
                            child: Text(
                              'Verify',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          )
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            child: Text('${MyUser.phoneNumber}',
                                style: TextStyle(color: Colors.white)),
                          ),
                          FaIcon(
                            FontAwesomeIcons.checkCircle,
                            size: 22,
                            color: Colors.white,
                          ),
                        ],
                      )),
          )),
          SizedBox(
            height: 40,
          ),
          ListTile(
            contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            title: Center(
              child: FlatButton(
                color: Colors.white,
                onPressed: () {
                  editMyProfile();
                },
                child: Text(
                  'Save',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
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
