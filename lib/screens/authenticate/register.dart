import 'dart:async';
import 'package:flutter/material.dart';
import 'package:myApp/services/places_autocomplete.dart';
import 'package:myApp/services/authh.dart';
import 'package:myApp/ui/shared/constants.dart';
import 'package:myApp/ui/shared/loading.dart';
import 'package:myApp/ui/shared/theme.dart';
import 'package:geolocator/geolocator.dart';
import 'package:myApp/credentials.dart';
import 'package:myApp/ui/shared/loading.dart';
import 'package:myApp/ui/shared/theme.dart';

import '../../route_generator.dart';
import '../../ui/shared/theme.dart';

class Register extends StatefulWidget {
  // final Function toggleView;
  // Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

TextEditingController locationController = TextEditingController();
final AuthService _auth = AuthService();
final _formKey = GlobalKey<FormState>();
bool loading = false;

// text field state
String email = '';
String name = '';
String password = '';
String location = '';
String error = '';

class _RegisterState extends State<Register> {
  getUserLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemarks = await Geolocator()
        .placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark placemark = placemarks[0];
    String completeAddress =
        '${placemark.subThoroughfare} ${placemark.thoroughfare}, ${placemark.subLocality} ${placemark.locality}, ${placemark.subAdministrativeArea}, ${placemark.administrativeArea} ${placemark.postalCode}, ${placemark.country}';
    print(completeAddress);
    String formattedAddress = "${placemark.locality}, ${placemark.country}";
    locationController.text = formattedAddress;
  }

  @override
  Widget build(BuildContext context) {
    // var signUpLocation = _currentAddress;

    return SafeArea(
      child: loading
          ? Loading()
          : MaterialApp(
              onGenerateRoute: RouteGenerator.generateRoute,
              home: Scaffold(
                  backgroundColor: Colors.white,
                  appBar: AppBar(
                    backgroundColor: FyreworkrColors.fyreworkBlack,
                    elevation: 0.0,
                    leading: IconButton(
                      icon: Icon(Icons.arrow_back),
                      color: Colors.white,
                      onPressed: () {
                        // Navigator.of(context).pushNamed('/');
                        Navigator.of(context).pop();
                      },
                    ),
                    title: Text('Sign up to FyreWork'),
                    actions: <Widget>[
                      FlatButton.icon(
                        icon: Icon(Icons.person),
                        label: Text(
                          'Sign In',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          // widget.toggleView();
                          Navigator.of(context).popAndPushNamed('/signIn');
                        },
                      )
                    ],
                  ),
                  body: SingleChildScrollView(
                    child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: <Widget>[
                              SizedBox(height: 20.0),
                              TextFormField(
                                decoration: textInputDecoration.copyWith(
                                    hintText: 'Name'),
                                validator: (val) =>
                                    val.isEmpty ? 'Enter your name' : null,
                                onChanged: (val) {
                                  setState(() => name = val);
                                },
                              ),
                              TextFormField(
                                decoration: textInputDecoration.copyWith(
                                    hintText: 'Email'),
                                validator: (val) =>
                                    val.isEmpty ? 'Enter you email' : null,
                                onChanged: (val) {
                                  setState(() => email = val);
                                },
                              ),
                              SizedBox(height: 20.0),
                              TextFormField(
                                decoration: textInputDecoration.copyWith(
                                    hintText: 'Password'),
                                obscureText: true,
                                validator: (val) => val.length < 6
                                    ? 'Enter a password 6+ chars long'
                                    : null,
                                onChanged: (val) {
                                  setState(() => password = val);
                                },
                              ),
                              SizedBox(height: 20.0),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                              SizedBox(height: 20.0),
                              RaisedButton(
                                color: FyreworkrColors.fyreworkBlack,
                                child: Text(
                                  'Register',
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () async {
                                  if (_formKey.currentState.validate()) {
                                    location = locationController.text;
                                    setState(() => loading = true);
                                    dynamic result = await _auth
                                        .registerWithEmailAndPassword(
                                            name.trim(),
                                            email.trim(),
                                            password.trim(),
                                            location);
                                    loading = false;
                                    if (result != null) {
                                      Navigator.of(context)
                                          .popAndPushNamed('/');
                                    }
                                    if (result == null) {
                                      setState(() {
                                        error =
                                            'Invalid or already registered email';
                                        loading = false;
                                      });
                                    }
                                  }
                                },
                              ),
                              SizedBox(height: 12.0),
                              Text(
                                error,
                                style: TextStyle(
                                    color: Colors.red, fontSize: 14.0),
                              )
                            ],
                          ),
                        )),
                  )),
            ),
    );
  }
}
