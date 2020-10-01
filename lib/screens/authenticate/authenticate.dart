import 'package:flutter/material.dart';
import 'package:myApp/screens/authenticate/register.dart';
import 'package:myApp/screens/authenticate/sign_in.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showRegister = true;
  void toggleView() {
    setState(() => showRegister = !showRegister);
  }

  @override
  Widget build(BuildContext context) {
    // if (showRegister) {
    //   return Register(toggleView: toggleView);
    // } else {
    //   return SignIn(toggleView: toggleView);
    // }
  }
}
