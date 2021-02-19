import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:Fyrework/main.dart';
import 'package:Fyrework/screens/add_gig/assets_picker/constants/picker_model.dart';
import 'package:Fyrework/screens/add_gig/assets_picker/src/widget/asset_picker.dart';
import 'package:Fyrework/services/auth_service.dart';
import 'package:Fyrework/services/popularHashtags.dart';
import 'package:Fyrework/services/takenHandles.dart';
import 'package:Fyrework/ui/shared/fyreworkTheme.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:Fyrework/services/places_autocomplete.dart';
import 'package:photo_manager/photo_manager.dart';
import '../shared/constants.dart';
import 'package:jiffy/jiffy.dart';
import 'package:intl/intl.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

// enum AuthFormType { signIn, signUp, reset, phone }
enum AuthFormType { signIn, signUp, reset }

class SignUpView extends StatefulWidget {
  final AuthFormType authFormType;
  SignUpView({Key key, @required this.authFormType}) : super(key: key);
  @override
  _SignUpViewState createState() =>
      _SignUpViewState(authFormType: this.authFormType);
}

String location = '';
dynamic userAvatarUrl;

// TextEditingController locationController = TextEditingController();
ScrollController scrollController = ScrollController();

class _SignUpViewState extends State<SignUpView> with TickerProviderStateMixin {
  // final auth = AuthService();
  AuthFormType authFormType;
  // AuthService _authService = locator.get<AuthService>();
  final int maxAssetsCount = 1;
  List<AssetEntity> selectedProfilePictureList;
  File extractedProfilePictureFromList;
  File _profileImage;
  AnimationController _cameraIconAnimationController;
  AnimationController _cameraColorAnimationController;
  Animation _cameraIconColorAnimation;

  List _myFavoriteHashtags = List();
  List _fetchedHandles = List();
  bool handleDuplicated = false;

  FocusNode handleFocus = FocusNode();

  _SignUpViewState({this.authFormType});

  @override
  void initState() {
    super.initState();
    _cameraIconAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 125),
      value: 1.0,
      lowerBound: 1.0,
      upperBound: 1.75,
    );

    _cameraColorAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 125),
    );

    _cameraIconColorAnimation = ColorTween(
      begin: Colors.white,
      end: Colors.red,
    ).animate(_cameraColorAnimationController)
      ..addListener(() {
        setState(() {});
      });
  }

  final _signupScaffoldKey = GlobalKey<ScaffoldState>();
  final signupFormKey = GlobalKey<FormState>();
  String _email,
      _password,
      // _myHashtag,
      _name,
      // _username,
      _userAvatarUrl,
      location,
      clientSideWarning,
      serverSideWarning,
      _phone;
  bool _isMinor = false;
  bool _showPassword = false;
  bool _showConfirmPassword = false;
  bool _shouldAddHashtag = false;
  dynamic _ongoingGigsByGigId;
  int _lengthOfOngoingGigsByGigId;
  final TextEditingController phoneNumberController = TextEditingController();
  TextEditingController _ageOfUserController = TextEditingController();
  TextEditingController _myFavoriteHashtagsController = TextEditingController();
  TextEditingController _myHandleController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  DateTime _defaultAge = Jiffy().subtract(years: 19);
  // DateTime _defaultAge = new DateTime.now();
  final _myFavoriteHashtagsControllerNotEmpty = SnackBar(
    content: Text(
      'need to add that hashtag!',
      style: TextStyle(fontSize: 16),
    ),
  );
  final _passwordConfirmPasswordSnackBar = SnackBar(
    content: Text(
      'Password & Confirm password are not identical!',
      style: TextStyle(fontSize: 16),
    ),
  );
  final _duplicateHandleSnackBar = SnackBar(
    content: Text(
      'Duplicate Handles are not allowed!',
      style: TextStyle(fontSize: 16),
    ),
  );

  void switchFormState(String state) {
    signupFormKey.currentState.reset();
    if (state == 'signUp') {
      setState(() {
        authFormType = AuthFormType.signUp;
      });
    } else if (state == 'home') {
      Navigator.of(context).pop();
    } else if (state == 'signIn') {
      setState(() {
        authFormType = AuthFormType.signIn;
      });
    }
  }

  bool validate() {
    final form = signupFormKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  void submit() async {
    // checking whether the user picked a profile pic or not

    switch (authFormType) {
      case AuthFormType.signIn:
        if (validate()) {
          try {
            EasyLoading.show();
            await AuthService()
                .signInWithEmailAndPassword(_email.trim(), _password.trim());
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => HomeController()),
                ModalRoute.withName('/'));
            EasyLoading.dismiss();
          } catch (e) {
            setState(() {
              serverSideWarning = 'Wrong email address or password';
            });
            break;
          }
        }
        break;
      case AuthFormType.signUp:
        if (_profileImage == null) {
          scrollController.animateTo(0,
              duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
          _cameraIconAnimationController.forward().then((value) {
            _cameraColorAnimationController.forward();
            _cameraIconAnimationController.reverse();
          });
        }
        //leaving hashtag input field with a value within
        else if (_myFavoriteHashtagsController.text.isNotEmpty) {
          scrollController.animateTo(0,
              duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
          _signupScaffoldKey.currentState
              .showSnackBar(_myFavoriteHashtagsControllerNotEmpty);
        } else if (_passwordController.text !=
            _confirmPasswordController.text) {
          _signupScaffoldKey.currentState
              .showSnackBar(_passwordConfirmPasswordSnackBar);
        }
        //check if password & confirm password are identical
        else if (_passwordController.text != _confirmPasswordController.text) {
          _signupScaffoldKey.currentState
              .showSnackBar(_passwordConfirmPasswordSnackBar);
        } else if (handleDuplicated) {
          _signupScaffoldKey.currentState
              .showSnackBar(_duplicateHandleSnackBar);
        } else if (_profileImage != null &&
            validate() &&
            _myHandleController.text.isNotEmpty &&
            !handleDuplicated &&
            _passwordController.text == _confirmPasswordController.text) {
          print('shouldAddHashtag: $_shouldAddHashtag');
          try {
            EasyLoading.show();
            location = PlacesAutocomplete.placesAutoCompleteController.text;
            // uploading a profile pic for the user signing up
            File profilePictureToUpload = File(_profileImage.path);
            await AuthService().createUserWithEmailAndPassword(
              _myFavoriteHashtags,
              _name.trim(),
              _myHandleController.text,
              _email.trim(),
              _password.trim(),
              _userAvatarUrl,
              profilePictureToUpload,
              location,
              _isMinor,
              _ongoingGigsByGigId,
              _lengthOfOngoingGigsByGigId,
            );
            PlacesAutocomplete.placesAutoCompleteController.clear();

            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => HomeController()),
                ModalRoute.withName('/'));
            EasyLoading.dismiss();
          } catch (e) {
            setState(() {
              serverSideWarning = 'This email address is already taken';
            });
          }
        }
        break;

      case AuthFormType.reset:
        try {
          await AuthService().sendPasswordResetEmail(_email.trim());
        } catch (e) {
          setState(() {
            serverSideWarning =
                'A password reset link has been sent to $_email';
            authFormType = AuthFormType.signIn;
          });
        }
        break;
    }
  }

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

  void onPhoneNumberChange(
      String number, String internationalizedPhoneNumber, String isoCode) {
    print(number);
    setState(() {
      _phone = internationalizedPhoneNumber;
      print(_phone);
    });
  }

  navigateToSelectProfilePicture() async {
    (BuildContext context, int index) async {
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
            _profileImage = extractedProfilePictureFromList;
          }
        }();
      }
    }(context, 0);
  }

  List<PickMethodModel> get pickMethods => <PickMethodModel>[
        PickMethodModel(
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

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;

    String _formattedDate = new DateFormat.yMMMd().format(_defaultAge);
    _ageOfUserController.value = new TextEditingValue(
      // text: _formattedDate == null ? _defaultAge : '$_formattedDate',
      text: _formattedDate,
      selection: TextSelection.fromPosition(
        TextPosition(offset: _formattedDate.length),
      ),
    );
    return Scaffold(
      key: _signupScaffoldKey,
      // resizeToAvoidBottomInset: true,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                children: [
                  serverSideAlert(),
                  clientSideAlert(),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 20),
                    child: Column(
                      children: <Widget>[
                        buildHeaderText(),
                        SizedBox(height: _height * 0.05),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Form(
                            key: signupFormKey,
                            child: Column(
                              children: buildInputs() + buildButtons(),
                            ),
                          ),
                        ),
                      ],
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

  @override
  void dispose() {
    // _cameraColorAnimationController.dispose();
    // _cameraIconAnimationController.dispose();
    // locationController.dispose();
    // scrollController.dispose();
    super.dispose();
  }

  // adding a profile image from camera or gallery
  Widget profileImagePicker() {
    return Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(blurRadius: 5, color: Colors.black54, spreadRadius: 2.5)
            ],
          ),
          child: CircleAvatar(
            radius: 70.0,
            backgroundColor: Theme.of(context).primaryColor,
            backgroundImage: _profileImage == null
                ? AssetImage("assets/images/black_placeholder.png")
                : FileImage(File(_profileImage.path)),
          ),
        ),
        Positioned(
          bottom: 30.0,
          right: 20.0,
          child: GestureDetector(
            onTap: navigateToSelectProfilePicture,
            child: ScaleTransition(
              scale: _cameraIconAnimationController,
              child: Icon(
                Icons.camera_alt,
                // color:
                //     _profileImage == null ? Colors.grey : FyreworkrColors.white,
                color: _profileImage == null
                    ? _cameraIconColorAnimation.value
                    : Colors.white,
                size: 30.0,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget serverSideAlert() {
    EasyLoading.dismiss();
    if (serverSideWarning != null) {
      scrollController.animateTo(0,
          duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
      return Container(
        color: Theme.of(context).primaryColor,
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 8.0),
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
      EasyLoading.dismiss();
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

  Text buildHeaderText() {
    String _headerText;
    if (authFormType == AuthFormType.signIn) {
      _headerText = "Sign In";
    } else if (authFormType == AuthFormType.reset) {
      _headerText = "Reset Password";
    }
    //  else if (authFormType == AuthFormType.phone) {
    //   _headerText = "Phone Sign In";
    // }
    else {
      _headerText = "Register";
    }
    return Text(
      _headerText,
      maxLines: 1,
      textAlign: TextAlign.center,
      style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 25),
    );
  }

  List<Widget> buildInputs() {
    List<Widget> textFields = [];

    if (authFormType == AuthFormType.reset) {
      textFields.add(
        Container(
          // width: MediaQuery.of(context).size.width * 0.8,
          width: double.infinity,
          child: TextFormField(
            validator: EmailValidator.validate,
            style: TextStyle(fontSize: 16.0),
            decoration: buildSignUpInputDecoration(context, 'Email'),
            onChanged: (val) {
              setState(() => _email = val);
            },
            onSaved: (val) => _email = val,
          ),
        ),
      );
      textFields.add(
        SizedBox(height: 20),
      );
      return textFields;
    }

    // if were in the sign up state add name
    if ([AuthFormType.signUp].contains(authFormType)) {
      textFields.add(
        Column(
          children: <Widget>[
            profileImagePicker(),
            SizedBox(
              height: 20,
            ),
            Container(
              width: double.infinity,
              child: Wrap(
                children: _myFavoriteHashtags
                    .map((e) => Padding(
                          padding: const EdgeInsets.all(2.5),
                          child: Chip(
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            backgroundColor: Colors.black,
                            label: Text(
                              '$e',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                            onDeleted: () {
                              setState(() {
                                _myFavoriteHashtags
                                    .removeWhere((item) => item == e);
                                print(_myFavoriteHashtags.length);
                              });
                            },
                            deleteIconColor: Colors.white,
                          ),
                        ))
                    .toList(),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TypeAheadFormField(
                    validator: (value) =>
                        _myFavoriteHashtags.length < 1 ? '' : null,
                    // onSaved: (value) => _myHashtag = value,
                    textFieldConfiguration: TextFieldConfiguration(
                      controller: _myFavoriteHashtagsController,
                      inputFormatters: [
                        new LengthLimitingTextInputFormatter(20),
                        FilteringTextInputFormatter.allow(RegExp("[a-z0-9_]")),
                      ],
                      decoration: buildSignUpInputDecoration(
                          context, 'Favorite #Hashtags'),
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
                      // _myHashtagController.text = suggestion;
                      // _myHashtag = suggestion;
                      if (_myFavoriteHashtags.length < 20 != true) {
                        setState(() {
                          clientSideWarning = 'Only 20 #Hashtags allowed';
                        });
                      } else if (_myFavoriteHashtags.contains(suggestion)) {
                        setState(() {
                          clientSideWarning =
                              'Duplicate #Hashtags are not allowed';
                        });
                        _myFavoriteHashtagsController.clear();
                      } else if (!_myFavoriteHashtags.contains(suggestion) &&
                          _myFavoriteHashtags.length < 20) {
                        setState(() {
                          _myFavoriteHashtags.add(suggestion);
                          _myFavoriteHashtagsController.clear();
                          print(_myFavoriteHashtags);
                        });
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 10, 0),
                  child: GestureDetector(
                    child: Text(
                      'Add',
                      style: TextStyle(
                        shadows: [
                          Shadow(
                              color: Theme.of(context).primaryColor,
                              offset: Offset(0, -2.5))
                        ],
                        fontSize: 16,
                        color: Colors.transparent,
                        decoration: TextDecoration.underline,
                        decorationThickness: 2,
                        decorationColor: Theme.of(context).primaryColor,
                        decorationStyle: TextDecorationStyle.dotted,
                      ),
                    ),
                    onTap: () {
                      if (_myFavoriteHashtags.length < 20 != true) {
                        setState(() {
                          clientSideWarning = 'Only 20 #Hashtags allowed';
                          _myFavoriteHashtagsController.clear();
                        });
                      } else if (_myFavoriteHashtags
                          .contains('#' + _myFavoriteHashtagsController.text)) {
                        setState(() {
                          clientSideWarning =
                              'Duplicate #Hashtags are not allowed';
                        });
                        _myFavoriteHashtagsController.clear();
                      } else if (_myFavoriteHashtagsController
                              .text.isNotEmpty &&
                          !_myFavoriteHashtags.contains(
                              '#' + _myFavoriteHashtagsController.text) &&
                          _myFavoriteHashtags.length < 20) {
                        setState(() {
                          _myFavoriteHashtags
                              .add('#' + _myFavoriteHashtagsController.text);
                          _myFavoriteHashtagsController.clear();
                          FocusScope.of(context).unfocus();
                          print(_myFavoriteHashtags);
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
            TextFormField(
              validator: NameValidator.validate,
              enableSuggestions: false,
              style: TextStyle(
                fontSize: 16.0,
              ),
              decoration: buildSignUpInputDecoration(context, 'Name'),
              // onChanged: (val) {
              //   setState(() => _name = val);
              // },
              onSaved: (val) => _name = val,
            ),
            //2nd TypeAhead for Handles goes here
            Row(
              children: [
                Expanded(
                  child: TypeAheadFormField(
                    validator: (value) => (_myHandleController.text.isEmpty ||
                            _myHandleController.text.length < 5)
                        ? ''
                        : null,
                    // onSaved: (value) => _my = value,
                    textFieldConfiguration: TextFieldConfiguration(
                      controller: _myHandleController,
                      style: TextStyle(fontSize: 16.0),
                      inputFormatters: [
                        new LengthLimitingTextInputFormatter(20),
                        FilteringTextInputFormatter.allow(RegExp("[a-z0-9_]")),
                      ],
                      decoration:
                          buildSignUpInputDecoration(context, '@handle'),
                      focusNode: handleFocus,
                    ),
                    suggestionsCallback: (pattern) async {
                      _fetchedHandles.clear();
                      print('fetchedHandles: $_fetchedHandles');
                      _fetchedHandles =
                          await TakenHandlesService.fetchTakenHandles(pattern);
                      print('fetchedHandles: $_fetchedHandles');
                      if (_fetchedHandles.contains(_myHandleController.text)) {
                        setState(() {
                          handleDuplicated = true;
                        });
                      } else {
                        setState(() {
                          handleDuplicated = false;
                        });
                      }

                      return _fetchedHandles;
                    },
                    itemBuilder: (context, suggestions) {
                      return ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              suggestions,
                              style:
                                  TextStyle(fontSize: 16, color: Colors.black),
                            ),
                            Text(
                              '(Taken)',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.black),
                            ),
                          ],
                        ),
                        // trailing: Text(
                        //   '(Taken)',
                        //   style: TextStyle(fontSize: 16, color: Colors.black),
                        // ),
                      );
                    },
                    onSuggestionSelected: (suggestion) {
                      handleFocus.requestFocus();
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                  child: _myHandleController.text.isEmpty
                      ? Container(
                          width: 0,
                          height: 0,
                        )
                      : handleDuplicated
                          ? FaIcon(
                              FontAwesomeIcons.timesCircle,
                              size: 18,
                              color: Colors.red,
                            )
                          : FaIcon(
                              FontAwesomeIcons.checkCircle,
                              size: 18,
                              color: Theme.of(context).primaryColor,
                            ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                  child: GestureDetector(
                    child: Text(
                      'Add',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                    onTap: () {
                      FocusScope.of(context).unfocus();
                    },
                  ),
                ),
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                PlacesAutocomplete(
                  signUpDecoraiton: true,
                ),
                IconButton(
                  color: Theme.of(context).primaryColor,
                  onPressed: () {
                    getUserLocation();
                  },
                  icon: Icon(Icons.gps_fixed),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 8.0, 0, 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                      child: Text(
                    "Tick this box if you are under 18 years old.",
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  )),
                  Checkbox(
                    value: _isMinor,
                    onChanged: (bool value) {
                      setState(() {
                        _isMinor = !_isMinor;
                        print(_isMinor);
                      });
                    },
                    activeColor: Theme.of(context).primaryColor,
                    checkColor: Theme.of(context).accentColor,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
      textFields.add(
        SizedBox(
          height: 20,
        ),
      );
    }

    // add email & password
    if ([AuthFormType.signUp, AuthFormType.reset, AuthFormType.signIn]
        .contains(authFormType)) {
      textFields.add(
        TextFormField(
          validator: EmailValidator.validate,
          style: TextStyle(fontSize: 16.0),
          decoration: buildSignUpInputDecoration(context, 'Email'),
          onSaved: (val) => _email = val,
        ),
      );
      textFields.add(SizedBox(height: 20));
    }

    if (authFormType != AuthFormType.reset) {
      String _submitButtonText;
      if (authFormType == AuthFormType.signUp) {
        _submitButtonText = 'Sign Up';
      } else {
        _submitButtonText = 'Sign In';
      }
      textFields.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width / 2.5,
                  child: TextFormField(
                    controller: _passwordController,
                    validator: PasswordValidator.validate,
                    style: TextStyle(fontSize: 16.0),
                    decoration: buildSignUpInputDecoration(context, 'Password'),
                    obscureText: !_showPassword,
                    onSaved: (val) => _password = val,
                  ),
                ),
                // SizedBox(
                //   width: 20,
                // ),
                GestureDetector(
                  child: _showPassword
                      ? Icon(Icons.visibility)
                      : Icon(Icons.visibility_off),
                  onTap: () {
                    setState(() {
                      _showPassword = !_showPassword;
                    });
                  },
                ),
              ],
            ),

            // SizedBox(
            //   width: 20,
            // ),
            authFormType == AuthFormType.signIn
                ? Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [
                        BoxShadow(color: Colors.white, spreadRadius: 8),
                      ],
                    ),
                    child: FlatButton(
                      color: Theme.of(context).primaryColor,
                      textColor: Theme.of(context).accentColor,
                      child: Text(
                        _submitButtonText,
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                        maxLines: 1,
                      ),
                      onPressed: submit,
                    ),
                  )
                : Container(
                    width: 0,
                    height: 0,
                  ),
          ],
        ),
      );
      if (authFormType == AuthFormType.signUp) {
        textFields.add(
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width / 2.5,
                    child: TextFormField(
                      controller: _confirmPasswordController,
                      validator: PasswordValidator.validate,
                      style: TextStyle(fontSize: 16.0),
                      decoration: buildSignUpInputDecoration(
                          context, 'Confirm Password'),
                      obscureText: !_showConfirmPassword,
                      // onSaved: (val) => _password = val,
                    ),
                  ),
                  // SizedBox(
                  //   width: 20,
                  // ),
                  GestureDetector(
                    child: _showConfirmPassword
                        ? Icon(Icons.visibility)
                        : Icon(Icons.visibility_off),
                    onTap: () {
                      setState(() {
                        _showConfirmPassword = !_showConfirmPassword;
                      });
                    },
                  ),
                ],
              ),
              // SizedBox(
              //   width: 20,
              // ),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: [
                    BoxShadow(color: Colors.white, spreadRadius: 8),
                  ],
                ),
                child: FlatButton(
                  color: Theme.of(context).primaryColor,
                  textColor: Theme.of(context).accentColor,
                  child: Text(
                    _submitButtonText,
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                    maxLines: 1,
                  ),
                  onPressed: submit,
                ),
              )
            ],
          ),
        );
      }

      textFields.add(
        SizedBox(
          height: 20,
        ),
      );
    }

    return textFields;
  }

  List<Widget> buildButtons() {
    String _switchButtonText, _newformState, _submitButtonText;
    bool _showForgotPassword = false;
    bool _showSocial = true;

    if (authFormType == AuthFormType.signIn) {
      _submitButtonText = 'Sign In';
      // _switchButtonText = 'New User? Create Account';
      _switchButtonText = 'Register';
      _newformState = 'signUp';
      _showForgotPassword = true;
    } else if (authFormType == AuthFormType.reset) {
      _submitButtonText = 'Submit';
      _switchButtonText = 'cancel';
      _newformState = 'signIn';
      _showSocial = false;
    } else {
      _submitButtonText = 'Sign Up';
      _switchButtonText = 'Have an account? Sign In';
      _newformState = 'signIn';
    }

    return [
      (authFormType != AuthFormType.signIn &&
              authFormType != AuthFormType.signUp)
          ? Container(
              // width: MediaQuery.of(context).size.width * 0.8,
              width: double.infinity,
              child: RaisedButton(
                color: Theme.of(context).primaryColor,
                textColor: Theme.of(context).accentColor,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    _submitButtonText,
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                ),
                onPressed: submit,
              ),
            )
          : SizedBox(
              height: 0,
            ),
      authFormType == AuthFormType.signIn
          ? SizedBox(height: 50)
          : SizedBox(
              width: 0,
              height: 0,
            ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          showForgotPassword(_showForgotPassword),
          GestureDetector(
            child: Text(
              _switchButtonText,
              style: TextStyle(
                  color: Theme.of(context).primaryColor, fontSize: 16),
              // maxLines: 1,
            ),
            onTap: () {
              switchFormState(_newformState);
              _passwordController.clear();
            },
          ),
        ],
      ),
      buildSocialIcons(_showSocial),
    ];
  }

  Widget showForgotPassword(bool visible) {
    return GestureDetector(
        child: Text(
          'Forgotten?',
          style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 16),
          maxLines: 1,
        ),
        onTap: () {
          setState(() {
            authFormType = AuthFormType.reset;
          });
        });
  }

  Widget buildSocialIcons(bool visible) {
    return Visibility(
      child: Column(
        children: <Widget>[
          Divider(color: Colors.white),
          Container(
            width: double.infinity,
            child: GoogleSignInButton(
              onPressed: () async {
                try {
                  await AuthService().signInWithGoogle();
                  Navigator.of(context).pushReplacementNamed('/home');
                } catch (e) {
                  setState(() {
                    serverSideWarning = e.message;
                  });
                }
              },
            ),
          ),
        ],
      ),
      visible: visible,
    );
  }
}
