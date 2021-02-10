import 'package:flutter/material.dart';
import 'package:myApp/app_localizations.dart';
import 'package:myApp/screens/authenticate/app_start.dart';
import 'package:myApp/screens/home/home.dart';
import 'package:myApp/services/auth_service.dart';
import 'package:myApp/ui/shared/fyreworkTheme.dart';
import 'package:myApp/ui/views/sign_up_view.dart';
import 'package:myApp/view_controllers/myUser_controller.dart';
import 'locator.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var initializaitonSettingsAndroid =
      AndroidInitializationSettings('ic_notification');
  var initializaitonSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification:
          (int id, String title, String body, String payload) async {});
  var initializationSettings = InitializationSettings(
      android: initializaitonSettingsAndroid, iOS: initializaitonSettingsIOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String payload) async {
    if (payload != null) {
      debugPrint('notification payload $payload');
    }
  });

  setupLocator();
  //
  // runApp(MyApp());
  runApp(HomeController());
  configLoading();
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

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    // ..loadingStyle = EasyLoadingStyle.dark
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.white
    ..indicatorColor = Colors.black
    ..textColor = Colors.black
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = false
    ..dismissOnTap = false;
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
    //
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
        print('your uid is: $myUid');
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
      debugShowCheckedModeBanner: false,
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
      // theme: ThemeData(
      //   primaryColor: FyreworkrColors.fyreworkBlack,
      //   accentColor: Colors.white,
      // ),
      theme: fyreworkTheme(),
      builder: EasyLoading.init(),
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
  }
}
