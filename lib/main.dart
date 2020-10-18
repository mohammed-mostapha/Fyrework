import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:myApp/screens/authenticate/app_start.dart';
import 'package:myApp/screens/home/home.dart';
import 'package:myApp/services/auth_service.dart';
import 'package:myApp/ui/views/sign_up_view.dart';
import 'package:myApp/ui/widgets/provider_widget.dart';
import 'locator.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Provider(
      auth: AuthService(),
      child: MaterialApp(
        home: HomeController(),
        routes: <String, WidgetBuilder>{
          '/home': (BuildContext context) => HomeController(),
          '/signUp': (BuildContext context) => SignUpView(
                authFormType: AuthFormType.signUp,
              ),
          '/signIn': (BuildContext context) => SignUpView(
                authFormType: AuthFormType.signIn,
              ),
          '/anonymousSignIn': (BuildContext context) => SignUpView(
                authFormType: AuthFormType.anonymous,
              ),
          '/convertUser': (BuildContext context) => SignUpView(
                authFormType: AuthFormType.convert,
              ),
          '/addGig': (BuildContext context) => Home(passedSelectedIndex: 1),
        },
      ),
    );
  }
}

class HomeController extends StatefulWidget {
  @override
  _HomeControllerState createState() => _HomeControllerState();
}

class _HomeControllerState extends State<HomeController> {
  @override
  Widget build(BuildContext context) {
    print("this is from the build method");
    final AuthService auth = Provider.of(context).auth;
    return StreamBuilder<String>(
        stream: auth.onAuthStateChanged,
        builder: (context, AsyncSnapshot<String> snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            bool signedIn = snapshot.hasData;
            return signedIn ? Home(passedSelectedIndex: 0) : StartPage();
          }

          return Container(
            color: Colors.white,
            child: Center(
              child: CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(Colors.black),
              ),
            ),
          );
        });
  }
}
