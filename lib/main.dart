import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myApp/app_localizations.dart';
import 'package:myApp/screens/authenticate/app_start.dart';
import 'package:myApp/screens/home/home.dart';
import 'package:myApp/services/auth_service.dart';
import 'package:myApp/ui/shared/theme.dart';
import 'package:myApp/ui/views/sign_up_view.dart';
// import 'package:myApp/ui/widgets/provider_widget.dart';
import 'package:myApp/view_controllers/myUser_controller.dart';
import 'locator.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();

  // runApp(MyApp());
  runApp(HomeController());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // return Provider(
    //   auth: AuthService(),
    //   child:
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeController(),
      routes: <String, WidgetBuilder>{
        '/home': (BuildContext context) => HomeController(),
        '/signUp': (BuildContext context) => SignUpView(
              authFormType: AuthFormType.signUp,
            ),
        '/signIn': (BuildContext context) => SignUpView(
              authFormType: AuthFormType.signIn,
            ),
        '/addGig': (BuildContext context) => Home(passedSelectedIndex: 1),
      },
      // ),
    );
  }
}

class HomeController extends StatefulWidget {
  @override
  _HomeControllerState createState() => _HomeControllerState();
}

bool isAuthenticated = false;

class _HomeControllerState extends State<HomeController> {
  AuthService authService = locator.get<AuthService>();
  @override
  void initState() {
    // FirebaseAuth.instance.currentUser().then((user) => user != null
    // FirebaseAuth.instance.currentUser().then((user) => user != null
    // authService.getCurrentUser().then((user) => user != null
    //     ? MyUserController()
    //         .getCurrentUserFromFirebase()
    //         .then((value) => setState(() {
    //               isAuthenticated = true;
    //             }))
    //     : setState(() {
    //         print('print from main => user null: $user');
    //         isAuthenticated = false;
    //       }));
    authService.getCurrentUser().then((user) async {
      if (user != null) {
        String myUid = await authService.getCurrentUID();
        MyUserController()
            .getCurrentUserFromFirebase(myUid)
            .then((value) => setState(() {
                  isAuthenticated = true;
                }));
      } else {
        setState(() {
          print('print from main => user null: $user');
          isAuthenticated = false;
        });
      }
    });
    super.initState();
  }

  // Function checkAuthenticity() {
  // FirebaseAuth.instance.currentUser().then((user) => user != null
  //     ? setState(() {
  //         print('user: $user');
  //         isAuthenticated = true;
  //       })
  //     : setState(() {
  //         print('user null: $user');
  //         isAuthenticated = false;
  //       }));
  //   FirebaseAuth.instance.onAuthStateChanged.listen((user) {
  //     if (user != null) {
  //       print('user: $user');
  //       setState(() {
  //         isAuthenticated = true;
  //       });
  //     } else {
  //       print('user null: $user');

  //       setState(() {
  //         isAuthenticated = false;
  //       });
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    // FirebaseAuth.instance.onAuthStateChanged.listen((user) {
    //   if (user != null) {
    //     print('user: $user');
    //     setState(() {
    //       isAuthenticated = true;
    //     });
    //   } else {
    //     print('user null: $user');

    //     setState(() {
    //       isAuthenticated = false;
    //     });
    //   }
    // });
    return MaterialApp(
      routes: <String, WidgetBuilder>{
        '/home': (BuildContext context) => HomeController(),
        '/signUp': (BuildContext context) => SignUpView(
              authFormType: AuthFormType.signUp,
            ),
        '/signIn': (BuildContext context) => SignUpView(
              authFormType: AuthFormType.signIn,
            ),
        '/addGig': (BuildContext context) => Home(passedSelectedIndex: 1),
      },
      theme: ThemeData(
        primaryColor: FyreworkrColors.fyreworkBlack,
        accentColor: Colors.white,
      ),
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
      home: isAuthenticated ? Home(passedSelectedIndex: 0) : StartPage(),
    );
    // return Container(
    //   color: Colors.white,
    //   child: Center(
    //     child: !isAuthenticated
    //         ? CircularProgressIndicator(
    //             valueColor: new AlwaysStoppedAnimation<Color>(Colors.black),
    //           )
    //         : Home(passedSelectedIndex: 0),
    //   ),
    // );
    //         return FutureBuilder(
    //           future: UserController().getCurrentUser(),
    //           builder: (BuildContext context, AsyncSnapshot snapshot) {
    //             if (snapshot.hasData) {
    //               return MaterialApp(
    //                 routes: <String, WidgetBuilder>{
    //                   '/home': (BuildContext context) => HomeController(),
    //                   '/signUp': (BuildContext context) => SignUpView(
    //                         authFormType: AuthFormType.signUp,
    //                       ),
    //                   '/signIn': (BuildContext context) => SignUpView(
    //                         authFormType: AuthFormType.signIn,
    //                       ),
    //                   '/addGig': (BuildContext context) =>
    //                       Home(passedSelectedIndex: 1),
    //                 },
    //                 theme: ThemeData(
    //                   primaryColor: FyreworkrColors.fyreworkBlack,
    //                   accentColor: FyreworkrColors.fyreworkBlack,
    //                 ),
    //                 supportedLocales: [
    //                   Locale('en', 'US'),
    //                   Locale('fr', 'FR'),
    //                   Locale('de', 'DE'),
    //                   Locale('is', 'IS'),
    //                 ],
    //                 // these delegates make sure that the localiztion data for the proper language is loaded
    //                 localizationsDelegates: [
    //                   // A class which loads the translation from JSON files
    //                   AppLocalizations.delegate,
    //                   //Built-in localization of basic text for Material widgets
    //                   GlobalMaterialLocalizations.delegate,
    //                   // Built-in localization for text direction LTR/RTL
    //                   GlobalWidgetsLocalizations.delegate,
    //                 ],
    //                 // Returns a locale which will be used by the app
    //                 localeResolutionCallback: (locale, supportedLocales) {
    //                   for (var supportedLocale in supportedLocales) {
    //                     if (supportedLocale.languageCode ==
    //                             locale?.languageCode ||
    //                         supportedLocale.countryCode ==
    //                             locale?.countryCode) {
    //                       return supportedLocale;
    //                     }
    //                   }
    //                   // I the locale of the device is not supported, use the first one from the list (English, in this case).
    //                   return supportedLocales.first;
    //                 },
    //                 home: signedIn ? Home(passedSelectedIndex: 0) : StartPage(),
    //               );
    //             }
    //             return Container(
    //               color: Colors.white,
    //               child: Center(
    //                 child: CircularProgressIndicator(
    //                   valueColor:
    //                       new AlwaysStoppedAnimation<Color>(Colors.black),
    //                 ),
    //               ),
    //             );
    //           },
    //         );

    // final AuthService auth = Provider.of(context).auth;
    // return StreamBuilder<String>(
    //     stream: auth.onAuthStateChanged,
    //     builder: (context, AsyncSnapshot<String> snapshot) {
    //       // if (snapshot.connectionState == ConnectionState.active) {
    //       if (snapshot.hasData) {
    //         // print('Stream ${snapshot.data}');
    //         bool signedIn = snapshot.hasData;
    //         return FutureBuilder(
    //           future: UserController().getCurrentUser(),
    //           builder: (BuildContext context, AsyncSnapshot snapshot) {
    //             if (snapshot.hasData) {
    //               return MaterialApp(
    //                 routes: <String, WidgetBuilder>{
    //                   '/home': (BuildContext context) => HomeController(),
    //                   '/signUp': (BuildContext context) => SignUpView(
    //                         authFormType: AuthFormType.signUp,
    //                       ),
    //                   '/signIn': (BuildContext context) => SignUpView(
    //                         authFormType: AuthFormType.signIn,
    //                       ),
    //                   '/addGig': (BuildContext context) =>
    //                       Home(passedSelectedIndex: 1),
    //                 },
    //                 theme: ThemeData(
    //                   primaryColor: FyreworkrColors.fyreworkBlack,
    //                   accentColor: FyreworkrColors.fyreworkBlack,
    //                 ),
    //                 supportedLocales: [
    //                   Locale('en', 'US'),
    //                   Locale('fr', 'FR'),
    //                   Locale('de', 'DE'),
    //                   Locale('is', 'IS'),
    //                 ],
    //                 // these delegates make sure that the localiztion data for the proper language is loaded
    //                 localizationsDelegates: [
    //                   // A class which loads the translation from JSON files
    //                   AppLocalizations.delegate,
    //                   //Built-in localization of basic text for Material widgets
    //                   GlobalMaterialLocalizations.delegate,
    //                   // Built-in localization for text direction LTR/RTL
    //                   GlobalWidgetsLocalizations.delegate,
    //                 ],
    //                 // Returns a locale which will be used by the app
    //                 localeResolutionCallback: (locale, supportedLocales) {
    //                   for (var supportedLocale in supportedLocales) {
    //                     if (supportedLocale.languageCode ==
    //                             locale?.languageCode ||
    //                         supportedLocale.countryCode ==
    //                             locale?.countryCode) {
    //                       return supportedLocale;
    //                     }
    //                   }
    //                   // I the locale of the device is not supported, use the first one from the list (English, in this case).
    //                   return supportedLocales.first;
    //                 },
    //                 home: signedIn ? Home(passedSelectedIndex: 0) : StartPage(),
    //               );
    //             }
    //             return Container(
    //               color: Colors.white,
    //               child: Center(
    //                 child: CircularProgressIndicator(
    //                   valueColor:
    //                       new AlwaysStoppedAnimation<Color>(Colors.black),
    //                 ),
    //               ),
    //             );
    //           },
    //         );

    //         // return signedIn ? Home(passedSelectedIndex: 0) : StartPage();

    //       }
    //       return MaterialApp(
    //         routes: <String, WidgetBuilder>{
    //           '/home': (BuildContext context) => HomeController(),
    //           '/signUp': (BuildContext context) => SignUpView(
    //                 authFormType: AuthFormType.signUp,
    //               ),
    //           '/signIn': (BuildContext context) => SignUpView(
    //                 authFormType: AuthFormType.signIn,
    //               ),
    //           '/addGig': (BuildContext context) => Home(passedSelectedIndex: 1),
    //         },
    //         supportedLocales: [
    //           Locale('en', 'US'),
    //           Locale('fr', 'FR'),
    //           Locale('de', 'DE'),
    //           Locale('is', 'IS'),
    //         ],
    //         // these delegates make sure that the localiztion data for the proper language is loaded
    //         localizationsDelegates: [
    //           // A class which loads the translation from JSON files
    //           AppLocalizations.delegate,
    //           //Built-in localization of basic text for Material widgets
    //           GlobalMaterialLocalizations.delegate,
    //           // Built-in localization for text direction LTR/RTL
    //           GlobalWidgetsLocalizations.delegate,
    //         ],
    //         // Returns a locale which will be used by the app
    //         localeResolutionCallback: (locale, supportedLocales) {
    //           for (var supportedLocale in supportedLocales) {
    //             if (supportedLocale.languageCode == locale?.languageCode ||
    //                 supportedLocale.countryCode == locale?.countryCode) {
    //               return supportedLocale;
    //             }
    //           }
    //           // I the locale of the device is not supported, use the first one from the list (English, in this case).
    //           return supportedLocales.first;
    //         },
    //         home: StartPage(),
    //       );
    //     });
  }
}
