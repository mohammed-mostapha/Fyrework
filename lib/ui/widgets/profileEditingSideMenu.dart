import 'dart:io';

import 'package:Fyrework/models/myUser.dart';
import 'package:Fyrework/screens/add_gig/assets_picker/constants/picker_model.dart';
import 'package:Fyrework/screens/add_gig/assets_picker/src/widget/asset_picker.dart';
import 'package:Fyrework/services/auth_service.dart';
import 'package:Fyrework/services/database.dart';
import 'package:Fyrework/services/places_autocomplete.dart';
import 'package:Fyrework/services/popularHashtags.dart';
import 'package:Fyrework/services/storage_repo.dart';
import 'package:Fyrework/ui/shared/constants.dart';
import 'package:Fyrework/ui/shared/fyreworkLightTheme.dart';
import 'package:Fyrework/view_controllers/myUser_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../locator.dart';

class ProfileEditingSideMenu extends StatefulWidget {
  @override
  _ProfileEditingSideMenuState createState() => _ProfileEditingSideMenuState();
}

class _ProfileEditingSideMenuState extends State<ProfileEditingSideMenu> {
  @override
  void initState() {
    super.initState();
    _myFavoriteHashtagsList = List.from(MyUser.favoriteHashtags);
  }

  ScrollController scrollController = ScrollController();
  final _editMyProfileScaffoldKey = GlobalKey<ScaffoldState>();
  final _editMyProfileFormKey = GlobalKey<FormState>();
  String clientSideWarning;
  String serverSideWarning;
  List<String> _myFavoriteHashtagsList = List();
  File _myNewProfileImage;
  String _updatedProfileAvatar;
  final int maxAssetsCount = 1;
  List<AssetEntity> selectedProfilePictureList;
  File extractedProfilePictureFromList;
  TextEditingController _myFavoriteHashtagsController = TextEditingController();
  TextEditingController _myNewName = TextEditingController(text: MyUser.name);
  TextEditingController _myNewUsername =
      TextEditingController(text: MyUser.username);
  TextEditingController _myNewEmailaddress =
      TextEditingController(text: MyUser.email);
  TextEditingController _myNewPhoneNumberController = TextEditingController(
      text: MyUser.phoneNumber == null ? '' : MyUser.phoneNumber);
  String myNewLocation = PlacesAutocomplete.placesAutoCompleteController.text;
  String _phoneNumberToVerify;
  final _myFavoriteHashtagsListEmpty = SnackBar(
    // backgroundColor: Theme.of(context).accentColor,
    content: Text(
      'At least one #Hashtag is required!',
      // style: Theme.of(context).textTheme.bodyText1,
    ),
  );

  bool validate() {
    final form = _editMyProfileFormKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
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

  selectProfilePicture() async {
    (BuildContext context, int index) async {
      final PickMethodModel model = pickMethods[index];

      final List<AssetEntity> retrievedAssets = await model.method(
        context,
        selectedProfilePictureList,
      );

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
    }(context, 0);
  }

  getUserLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
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

  void editMyProfile() async {
    if (_myFavoriteHashtagsList.length > 0 != true) {
      _editMyProfileScaffoldKey.currentState
          .showSnackBar(_myFavoriteHashtagsListEmpty);
    } else {
      try {
        if (validate() && _myNewProfileImage != null) {
          EasyLoading.show();
          //deleting current profile picture
          await StorageRepo().deleteProfilePicture(MyUser.userAvatarUrl);

          // then upload the new pic
          _updatedProfileAvatar = await locator
              .get<StorageRepo>()
              .uploadProfilePicture(
                  profilePictureToUpload: _myNewProfileImage,
                  userId: MyUser.uid);

          await DatabaseService()
              .updateMyProfilePicture(MyUser.uid, _updatedProfileAvatar);
          await DatabaseService().addToPopularHashtags(_myFavoriteHashtagsList);
          EasyLoading.dismiss().then(
            (value) => EasyLoading.showSuccess(''),
          );
        }

        if (validate()) {
          EasyLoading.show();
          await DatabaseService().updateMyProfileData(
            uid: MyUser.uid, myNewFavoriteHashtag: _myFavoriteHashtagsList,
            myNewUsername: _myNewUsername.text,
            myNewName: _myNewName.text,
            myNewEmailaddress: _myNewEmailaddress.text,
            myNewLocation: PlacesAutocomplete.placesAutoCompleteController.text,
            // // _myNewPhoneNumberController.text,
            // _phoneNumberToVerify,
          );
          await DatabaseService().addToPopularHashtags(_myFavoriteHashtagsList);
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
  }

  Widget serverSideAlert() {
    if (serverSideWarning != null) {
      scrollController.animateTo(0,
          duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
      return Container(
        color: Theme.of(context).primaryColor,
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
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    .copyWith(color: Theme.of(context).accentColor),
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
        color: Theme.of(context).primaryColor,
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
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    .copyWith(color: Theme.of(context).accentColor),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _editMyProfileScaffoldKey,
      backgroundColor: Theme.of(context).primaryColor,
      body: Form(
        key: _editMyProfileFormKey,
        child: ListView(
          children: <Widget>[
            ListTile(
              contentPadding: EdgeInsets.fromLTRB(8.0, 0, 0, 0),
              leading: GestureDetector(
                child: Icon(
                  Icons.chevron_left,
                  color: Theme.of(context).accentColor,
                ),
                onTap: () {
                  setState(() {
                    Navigator.of(context).pop();
                    _myNewProfileImage = null;
                  });
                },
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(8.0, 0, 0, 0),
              width: double.infinity,
              child: Wrap(
                spacing: 2.5,
                children: _myFavoriteHashtagsList
                    .map((e) => Chip(
                          backgroundColor: Theme.of(context).accentColor,
                          label: Text(
                            '$e',
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          onDeleted: () {
                            setState(() {
                              _myFavoriteHashtagsList
                                  .removeWhere((item) => item == e);
                            });
                          },
                          deleteIconColor: Colors.black,
                        ))
                    .toList(),
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
              leading: Container(
                padding: EdgeInsets.fromLTRB(0, 1.5, 0, 0),
                child: Text(
                  'Profile Picture',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(color: Theme.of(context).accentColor),
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
                        selectProfilePicture();
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
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .copyWith(color: Theme.of(context).accentColor)),
                ),
                trailing: Container(
                  width: MediaQuery.of(context).size.width / 1.5,
                  child: Row(
                    children: [
                      Expanded(
                        child: TypeAheadFormField(
                          // initialValue: MyUser.favoriteHashtags.toString(),
                          // validator: (value) => value.isEmpty ? '' : null,
                          onSaved: (value) =>
                              _myFavoriteHashtagsController.text = value,
                          textFieldConfiguration: TextFieldConfiguration(
                            controller: _myFavoriteHashtagsController,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(color: Theme.of(context).accentColor),
                            decoration: profileEditingInputDecoration(
                                context, 'Favorite #Hashtags'),
                          ),
                          suggestionsCallback: (pattern) async {
                            return await PopularHashtagsService
                                .fetchPopularHashtags(pattern);
                          },
                          itemBuilder: (context, suggestions) {
                            return ListTile(
                              title: Text(suggestions),
                            );
                          },
                          onSuggestionSelected: (suggestion) {
                            if (_myFavoriteHashtagsList.length < 20 != true) {
                              setState(() {
                                clientSideWarning = 'Only 20 #Hashtags allowed';
                              });
                            } else if (_myFavoriteHashtagsController
                                    .text.isNotEmpty &&
                                !_myFavoriteHashtagsList.contains(suggestion) &&
                                _myFavoriteHashtagsList.length < 20) {
                              setState(() {
                                _myFavoriteHashtagsList.add('#' + suggestion);
                                _myFavoriteHashtagsController.clear();
                                print('list: $_myFavoriteHashtagsList');
                              });
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: GestureDetector(
                          child: Text(
                            'Add',
                            style: TextStyle(
                              shadows: [
                                Shadow(
                                    color: Theme.of(context).accentColor,
                                    offset: Offset(0, -2.5))
                              ],
                              fontSize: 14,
                              color: Colors.transparent,
                              decoration: TextDecoration.underline,
                              decorationThickness: 2,
                              decorationColor: Theme.of(context).accentColor,
                              decorationStyle: TextDecorationStyle.dotted,
                            ),
                          ),
                          onTap: () {
                            if (_myFavoriteHashtagsList.length < 20 != true) {
                              setState(() {
                                clientSideWarning = 'Only 20 #Hashtags allowed';
                                _myFavoriteHashtagsController.clear();
                              });
                            } else if (_myFavoriteHashtagsList.contains(
                                '#' + _myFavoriteHashtagsController.text)) {
                              setState(() {
                                clientSideWarning =
                                    'Duplicate #Hashtags are not allowed';
                              });
                              _myFavoriteHashtagsController.clear();
                            } else if (_myFavoriteHashtagsController
                                    .text.isNotEmpty &&
                                !_myFavoriteHashtagsList.contains(
                                    '#' + _myFavoriteHashtagsController.text) &&
                                _myFavoriteHashtagsList.length < 20) {
                              setState(() {
                                _myFavoriteHashtagsList.add(
                                    '#' + _myFavoriteHashtagsController.text);
                                _myFavoriteHashtagsController.clear();
                                FocusScope.of(context).unfocus();
                                print(_myFavoriteHashtagsList);
                              });
                            }
                          },
                        ),
                      ),
                    ],
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
                  child: Text(
                    'Username',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(color: Theme.of(context).accentColor),
                  ),
                ),
                trailing: Container(
                  width: MediaQuery.of(context).size.width / 1.5,
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          child: TextFormField(
                            controller: _myNewUsername,
                            validator: UsernameValidator.validate,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(color: Theme.of(context).accentColor),
                            decoration: profileEditingInputDecoration(
                                context, 'Username'),
                            // onChanged: (val) {
                            //   setState(() => _myNewUsername.text = val);
                            // },
                            onSaved: (val) => _myNewUsername.text = val,
                          ),
                        ),
                      ),
                    ],
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
                  child: Text(
                    'Name',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(color: Theme.of(context).accentColor),
                  ),
                ),
                trailing: Container(
                  width: MediaQuery.of(context).size.width / 1.5,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _myNewName,
                          validator: NameValidator.validate,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              .copyWith(color: Theme.of(context).accentColor),
                          decoration:
                              profileEditingInputDecoration(context, 'Name'),
                          // onChanged: (val) {
                          //   setState(() => _myNewName.text = val);
                          // },
                          onSaved: (val) => _myNewName.text = val,
                        ),
                      ),
                    ],
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
                  child: Text(
                    'Email',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(color: Theme.of(context).accentColor),
                  ),
                ),
                trailing: Container(
                  width: MediaQuery.of(context).size.width / 1.5,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _myNewEmailaddress,
                          validator: EmailValidator.validate,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              .copyWith(color: Theme.of(context).accentColor),
                          decoration: profileEditingInputDecoration(
                              context, 'Email address'),
                          // onChanged: (val) {
                          //   setState(() => _myNewEmailaddress.text = val);
                          // },
                          onSaved: (val) => _myNewEmailaddress.text = val,
                        ),
                      ),
                    ],
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
                  child: Text(
                    'location',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(color: Theme.of(context).accentColor),
                  ),
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
            // GestureDetector(
            //     child: ListTile(
            //   contentPadding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
            //   leading: Container(
            //     padding: EdgeInsets.fromLTRB(0, 1.5, 0, 0),
            //     child: Text('Mobile',
            //         style: TextStyle(
            //           fontSize: 16,
            //           color: Colors.white,
            //         )),
            //   ),
            //   trailing: Container(
            //       // padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            //       width: MediaQuery.of(context).size.width / 1.5,
            //       child: (MyUser.phoneNumber == null || MyUser.phoneNumber == '')
            //           ? Row(
            //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //               children: [
            //                 Expanded(
            //                   child: phoneVerifyer(),
            //                 ),
            //                 GestureDetector(
            //                   onTap: () {
            //                     verifyPhoneNumber(_phoneNumberToVerify, context);
            //                   },
            //                   child: Text(
            //                     'Verify',
            //                     style:
            //                         TextStyle(fontSize: 16, color: Colors.white),
            //                   ),
            //                 )
            //               ],
            //             )
            //           : Row(
            //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //               children: <Widget>[
            //                 Container(
            //                   child: Text('${MyUser.phoneNumber}',
            //                       style: TextStyle(color: Colors.white)),
            //                 ),
            //                 FaIcon(
            //                   FontAwesomeIcons.checkCircle,
            //                   size: 22,
            //                   color: Colors.white,
            //                 ),
            //               ],
            //             )),
            // )),
            SizedBox(
              height: 40,
            ),
            ListTile(
              contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              title: Center(
                  child: GestureDetector(
                onTap: editMyProfile,
                child: Container(
                  width: 80,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Theme.of(context).accentColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text('Save',
                        style: Theme.of(context).textTheme.bodyText1),
                  ),
                ),
              )),
            ),
          ],
        ),
      ),
    );
  }
}
