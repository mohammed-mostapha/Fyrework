import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:myApp/app_localizations.dart';
import 'package:myApp/screens/add_gig/assets_picker/src/constants/constants.dart';
import 'package:myApp/screens/authenticate/app_start.dart';
import 'package:myApp/screens/home/home.dart';
import 'package:myApp/services/auth_service.dart';
import 'package:myApp/ui/views/sign_up_view.dart';
import 'package:myApp/ui/widgets/provider_widget.dart';
import 'locator.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

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
            return MaterialApp(
              supportedLocales: [
                Locale('en', 'US'),
                Locale('fr', 'FR'),
                Locale('de', 'DE'),
                Locale('is', 'IS'),
              ],
              // these delegates make sure that the localiztion data for the proper language is loaded
              localizationsDelegates: [
                // A class which loads the translation from JSON files
                AppLocalizations.delegate,
                //Built-in localization of basic text for Material widgets
                GlobalMaterialLocalizations.delegate,
                // Built-in localization for text direction LTR/RTL
                GlobalWidgetsLocalizations.delegate,
              ],
              // Returns a locale which will be used by the app
              localeResolutionCallback: (locale, supportedLocales) {
                for (var supportedLocale in supportedLocales) {
                  if (supportedLocale.languageCode == locale?.languageCode ||
                      supportedLocale.countryCode == locale?.countryCode) {
                    return supportedLocale;
                  }
                }
                // I the locale of the device is not supported, use the first one from the list (English, in this case).
                return supportedLocales.first;
              },
              home: signedIn ? Home(passedSelectedIndex: 0) : StartPage(),
            );
            // return signedIn ? Home(passedSelectedIndex: 0) : StartPage();

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
