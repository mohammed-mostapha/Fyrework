import 'dart:io';

import 'package:flutter/material.dart';
import 'package:myApp/locator.dart';
import 'package:myApp/main.dart';
import 'package:myApp/models/user.dart';
import 'package:myApp/ui/widgets/provider_widget.dart';
import 'package:myApp/services/auth_service.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:myApp/ui/shared/theme.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:international_phone_input/international_phone_input.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:myApp/services/places_autocomplete.dart';
import 'package:geolocator/geolocator.dart';
import 'package:myApp/vew_controllers/user_controller.dart';
import '../shared/constants.dart';
import 'package:image_picker/image_picker.dart';

enum AuthFormType { signIn, signUp, reset, anonymous, convert, phone }

class SignUpView extends StatefulWidget {
  final AuthFormType authFormType;
  SignUpView({Key key, @required this.authFormType}) : super(key: key);
  @override
  _SignUpViewState createState() =>
      _SignUpViewState(authFormType: this.authFormType);
}

String location = '';
dynamic userAvatarUrl;

TextEditingController locationController = TextEditingController();

class _SignUpViewState extends State<SignUpView> {
  PickedFile _profileImage;
  final ImagePicker _picker = ImagePicker();
  AuthFormType authFormType;
  AuthService _authService = locator.get<AuthService>();

  _SignUpViewState({this.authFormType});

  final formKey = GlobalKey<FormState>();
  String _email, _password, _name, location, _warning, _phone;
  final TextEditingController phoneNumberController = TextEditingController();

  void switchFormState(String state) {
    formKey.currentState.reset();
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
    final form = formKey.currentState;
    if (authFormType == AuthFormType.anonymous) {
      return true;
    }
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  void submit() async {
    if (validate()) {
      try {
        final auth = Provider.of(context).auth;
        switch (authFormType) {
          case AuthFormType.signIn:
            // await auth.signInWithEmailAndPassword(
            //     _email.trim(), _password.trim());
            await locator.get<UserController>().signInWithEmailAndPassword(
                email: _email.trim(), password: _password.trim());

            // Navigator.of(context).pushReplacementNamed('/home');
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => HomeController()));
            break;
          case AuthFormType.signUp:
            location = locationController.text;

            // uploading a profile pic for the user signing up
            File profilePictureToUpload = File(_profileImage.path);

            await auth.createUserWithEmailAndPassword(
                _email.trim(), _password.trim(), _name.trim(), location);

            await locator
                .get<UserController>()
                .uploadProfilePicture(profilePictureToUpload);

            // await locator.get<UserController>().getProfilePictureDownloadUrl();

            Navigator.of(context).pushReplacementNamed('/home');
            break;
          case AuthFormType.convert:
            File profilePictureToUpload = File(_profileImage.path);
            await auth.convertUserWithEmail(
                _email.trim(), _password.trim(), _name.trim(), location);

            // locator
            //     .get<UserController>()
            //     .setCurrentUserUid(_authService.getCurrentUID());

            await locator
                .get<UserController>()
                .uploadProfilePicture(profilePictureToUpload);

            // await locator.get<UserController>().setAvatarUrlAndUserFullName(
            //     profilePictureToUpload, _name.trim());

            Navigator.push(context,
                MaterialPageRoute(builder: (context) => HomeController()));
            break;
          case AuthFormType.reset:
            await auth.sendPasswordResetEmail(_email.trim());
            _warning = 'A password reset link has been sent to $_email';
            setState(() {
              authFormType = AuthFormType.signIn;
            });
            break;
          case AuthFormType.anonymous:
            await auth.signInAnonymously();
            Navigator.of(context).pushReplacementNamed('/home');
            break;

          case AuthFormType.phone:
            var result = await auth.createUserWithPhone(_phone.trim(), context);
            if (_phone == "" || result == "error") {
              setState(() {
                _warning = "Your phone number could not be validated";
              });
            }
            break;
        }
      } catch (e) {
        print(e);
        setState(() {
          _warning = e.message;
        });
      }
    }
  }

  getUserLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemarks = await Geolocator()
        .placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark placemark = placemarks[0];
    String completeAddress =
        '${placemark.subThoroughfare} ${placemark.thoroughfare}, ${placemark.subLocality} ${placemark.locality}, ${placemark.subAdministrativeArea}, ${placemark.administrativeArea} ${placemark.postalCode}, ${placemark.country}';
    // print(completeAddress);
    String formattedAddress = "${placemark.locality}, ${placemark.country}";
    setState(() {
      locationController.text = formattedAddress;
      print(location);
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

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    if (authFormType == AuthFormType.anonymous) {
      submit();
      return Scaffold(
        backgroundColor: FyreworkrColors.fyreworkBlack,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SpinKitDoubleBounce(color: Colors.white),
            Text(
              'Loading',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      );
    } else {
      return Scaffold(
        body: Container(
          // color: FyreworkrColors.fyreworkBlack,
          color: FyreworkrColors.white,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: SafeArea(
              child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: <Widget>[
                  SizedBox(height: _height * 0.025),
                  showAlert(),
                  SizedBox(height: _height * 0.025),
                  buildHeaderText(),
                  SizedBox(height: _height * 0.05),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: buildInputs() + buildButtons(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )),
        ),
      );
    }
  }

  // adding a profile image from camera or gallery
  Widget profileImagePicker() {
    return Stack(
      children: <Widget>[
        CircleAvatar(
          radius: 80.0,
          backgroundImage: _profileImage == null
              ? AssetImage("assets/images/black_placeholder.png")
              : FileImage(File(_profileImage.path)),
        ),
        Positioned(
          bottom: 30.0,
          right: 30.0,
          child: InkWell(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: ((builder) => profileImagePickerBottomSheet()),
              );
            },
            child: Icon(
              Icons.camera_alt,
              color: _profileImage == null
                  ? FyreworkrColors.fyreworkGrey
                  : FyreworkrColors.white,
              size: 28.0,
            ),
          ),
        ),
      ],
    );
  }

  Widget profileImagePickerBottomSheet() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: <Widget>[
          AutoSizeText(
            "Choose Profile image",
            style: TextStyle(fontSize: 20.0),
          ),
          SizedBox(
            height: 20.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FlatButton.icon(
                onPressed: () {
                  takePhoto(ImageSource.camera);
                },
                icon: Icon(Icons.camera),
                label: AutoSizeText("Camera"),
              ),
              FlatButton.icon(
                onPressed: () {
                  takePhoto(ImageSource.gallery);
                },
                icon: Icon(Icons.image),
                label: AutoSizeText("Gallery"),
              )
            ],
          )
        ],
      ),
    );
  }

  void takePhoto(ImageSource source) async {
    final pickedFile = await _picker.getImage(
      source: source,
    );
    setState(() {
      _profileImage = pickedFile;
    });
  }

  Widget showAlert() {
    if (_warning != null) {
      return Container(
        color: Colors.amberAccent,
        width: double.infinity,
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(Icons.error_outline),
            ),
            Expanded(
              child: AutoSizeText(
                _warning,
                maxLines: 3,
                style: TextStyle(fontSize: 20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  setState(() {
                    _warning = null;
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

  AutoSizeText buildHeaderText() {
    String _headerText;
    if (authFormType == AuthFormType.signIn) {
      _headerText = "Sign In";
    } else if (authFormType == AuthFormType.reset) {
      _headerText = "Reset Password";
    } else if (authFormType == AuthFormType.phone) {
      _headerText = "Phone Sign In";
    } else {
      _headerText = "Create New Account";
    }
    return AutoSizeText(
      _headerText,
      maxLines: 1,
      textAlign: TextAlign.center,
      style: TextStyle(color: FyreworkrColors.black, fontSize: 35),
    );
  }

  List<Widget> buildInputs() {
    List<Widget> textFields = [];

    if (authFormType == AuthFormType.reset) {
      textFields.add(
        TextFormField(
          validator: EmailValidator.validate,
          style: TextStyle(fontSize: 22.0),
          decoration: buildSignUpInputDecoration('Email'),
          onChanged: (val) {
            setState(() => _email = val);
          },
          onSaved: (val) => _name = val,
        ),
      );
      textFields.add(
        SizedBox(height: 20),
      );
      return textFields;
    }

    // if were in the sign up state add name
    if ([AuthFormType.signUp, AuthFormType.convert].contains(authFormType)) {
      textFields.add(
        Column(
          children: <Widget>[
            profileImagePicker(),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              validator: NameValidator.validate,
              style: TextStyle(fontSize: 22.0),
              decoration: buildSignUpInputDecoration('Name'),
              onChanged: (val) {
                setState(() => _name = val);
              },
              onSaved: (val) => _name = val,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  color: FyreworkrColors.fyreworkBlack,
                  onPressed: () {
                    getUserLocation();
                  },
                  icon: Icon(Icons.gps_fixed),
                ),
                Flexible(
                  // child: TextFormField(
                  //   controller: locationController,
                  //   decoration: textInputDecoration.copyWith(
                  //       hintText: 'loaction'),
                  //   validator: (val) => val.isEmpty
                  //       ? 'please click location button'
                  //       : null,
                  //   onChanged: (val) {
                  //     // setState(() => location = val);
                  //   },
                  // ),
                  child: PlacesAutocomplete(),
                ),
              ],
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
    if ([
      AuthFormType.signUp,
      AuthFormType.convert,
      AuthFormType.reset,
      AuthFormType.signIn
    ].contains(authFormType)) {
      textFields.add(
        TextFormField(
          validator: EmailValidator.validate,
          style: TextStyle(fontSize: 22.0),
          decoration: buildSignUpInputDecoration('Email'),
          onChanged: (val) {
            setState(() => _email = val);
          },
          onSaved: (val) => _email = val,
        ),
      );
      textFields.add(SizedBox(height: 20));
    }
    if (authFormType != AuthFormType.reset &&
        authFormType != AuthFormType.phone) {
      String _submitButtonText;
      if (authFormType == AuthFormType.signUp ||
          authFormType == AuthFormType.convert) {
        _submitButtonText = 'Sign Up';
      } else {
        _submitButtonText = 'Sign In';
      }
      textFields.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width * 0.6,
              child: TextFormField(
                validator: PasswordValidator.validate,
                style: TextStyle(fontSize: 22.0),
                decoration: buildSignUpInputDecoration('Password'),
                obscureText: true,
                onChanged: (val) {
                  setState(() => _password = val);
                },
                onSaved: (val) => _password = val,
              ),
            ),
            Container(
              child: RaisedButton(
                color: FyreworkrColors.fyreworkBlack,
                textColor: FyreworkrColors.white,
                child: AutoSizeText(
                  _submitButtonText,
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                  maxLines: 1,
                ),
                onPressed: submit,
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

    // Phone authentication
    if (authFormType == AuthFormType.phone) {
      textFields.add(
        // TextFormField(
        //   style: TextStyle(fontSize: 22.0),
        //   decoration: buildSignUpInputDecoration('Enter Phone'),
        //   onChanged: (val) {
        //     setState(() => _phone = val);
        //   },
        //   onSaved: (val) => _password = val,
        // ),
        Container(
          width: MediaQuery.of(context).size.width * 0.7,
          // child: InternationalPhoneInput(
          //   decoration: buildSignUpInputDecoration('Enter Phone Number'),
          //   onPhoneNumberChange: onPhoneNumberChange,
          //   initialPhoneNumber: _phone,
          //   initialSelection: 'US',
          //   showCountryCodes: true,
          //   showCountryFlags: true,
          // ),
          child: InternationalPhoneNumberInput(
            onInputChanged: (PhoneNumber number) {
              print(number.phoneNumber);
              setState(() {
                _phone = number.toString();
              });
            },
            onInputValidated: (bool value) {
              print(value);
            },
            ignoreBlank: false,
            autoValidate: false,
            selectorTextStyle: TextStyle(color: Colors.black),
            textFieldController: phoneNumberController,
            inputBorder: OutlineInputBorder(),
            selectorType: PhoneInputSelectorType.DIALOG,
          ),
        ),
      );
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
      _switchButtonText = 'New User? Create Account';
      _newformState = 'signUp';
      _showForgotPassword = true;
    } else if (authFormType == AuthFormType.reset) {
      _submitButtonText = 'Submit';
      _switchButtonText = 'cancel';
      _newformState = 'signIn';
      _showSocial = false;
    } else if (authFormType == AuthFormType.convert) {
      _submitButtonText = 'Sign Up';
      _switchButtonText = 'have an account? Sign In';
      _newformState = 'signIn';
    } else if (authFormType == AuthFormType.phone) {
      _submitButtonText = 'Continue';
      _switchButtonText = 'Cancel';
      _newformState = 'SignIn';
      _showSocial = false;
    } else {
      _submitButtonText = 'Sign Up';
      _switchButtonText = 'have an account? Sign In';
      _newformState = 'signIn';
    }

    return [
      (authFormType != AuthFormType.signIn &&
              authFormType != AuthFormType.signUp &&
              authFormType != AuthFormType.convert)
          ? Container(
              width: MediaQuery.of(context).size.width * 0.7,
              child: RaisedButton(
                color: FyreworkrColors.fyreworkBlack,
                textColor: FyreworkrColors.white,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    _submitButtonText,
                    style: TextStyle(
                      fontSize: 20.0,
                    ),
                  ),
                ),
                onPressed: submit,
              ),
            )
          : SizedBox(
              height: 0,
            ),
      showForgotPassword(_showForgotPassword),
      Container(
        width: MediaQuery.of(context).size.width * 0.7,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            FlatButton(
              child: AutoSizeText(
                _switchButtonText,
                style: TextStyle(
                    color: FyreworkrColors.fyreworkGrey, fontSize: 20),
                maxLines: 1,
              ),
              onPressed: () {
                switchFormState(_newformState);
              },
            ),
          ],
        ),
      ),
      buildSocialIcons(_showSocial),

      // splitting authFormType.convert from all other authFormTypes

      (authFormType == AuthFormType.convert)
          ? SizedBox(
              height: 0,
            )
          : SizedBox(
              height: 0,
            )
    ];
  }

  Widget showForgotPassword(bool visible) {
    return Visibility(
      child: FlatButton(
        child: AutoSizeText(
          'Forgotten Password?',
          style: TextStyle(color: FyreworkrColors.fyreworkGrey, fontSize: 20),
          maxLines: 1,
        ),
        onPressed: () {
          setState(() {
            authFormType = AuthFormType.reset;
          });
        },
      ),
      visible: visible,
    );
  }

  Widget buildSocialIcons(bool visible) {
    final _auth = Provider.of(context).auth;
    return Visibility(
      child: Column(
        children: <Widget>[
          Divider(color: Colors.white),
          SizedBox(height: 10),
          Container(
            width: double.infinity,
            child: GoogleSignInButton(
              onPressed: () async {
                try {
                  if (authFormType == AuthFormType.convert) {
                    await _auth.convertWithGoogle();
                    Navigator.of(context).pop();
                  } else {
                    await _auth.signInWithGoogle();
                    Navigator.of(context).pushReplacementNamed('/home');
                  }
                } catch (e) {
                  setState(() {
                    _warning = e.message;
                  });
                }
              },
            ),
          ),
          RaisedButton(
            color: FyreworkrColors.black,
            textColor: Colors.white,
            child: Row(
              children: <Widget>[
                Icon(Icons.phone),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 8.0, top: 10.0, bottom: 10.0),
                  child: Text(
                    'Sign in with Phone',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
            onPressed: () {
              setState(() {
                authFormType = AuthFormType.phone;
              });
            },
          )
        ],
      ),
      visible: visible,
    );
  }
}
