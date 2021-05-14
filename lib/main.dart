import 'package:Fyrework/services/connectivity_provider.dart';
import 'package:Fyrework/services/mobileAds_provider.dart';
import 'package:Fyrework/ui/shared/fyreworkDarkTheme.dart';
import 'package:Fyrework/ui/widgets/network_sensor.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:Fyrework/app_localizations.dart';
import 'package:Fyrework/screens/authenticate/app_start.dart';
import 'package:Fyrework/screens/home/home.dart';
import 'package:Fyrework/services/auth_service.dart';
import 'package:Fyrework/ui/shared/fyreworkLightTheme.dart';
import 'package:Fyrework/ui/views/sign_up_view.dart';
import 'package:Fyrework/view_controllers/myUser_controller.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'locator.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final initMobileAdsFuture = MobileAds.instance.initialize();
  final mobileAdsState = MobileAdsState(initMobileAdsFuture);

  await Firebase.initializeApp();

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
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(Provider.value(
        value: mobileAdsState, builder: (context, child) => MyApp()));
  });
  //
  // runApp(MyApp());
  // runApp(HomeController());
  configLoading();
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeController(),
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
    super.initState();
    checkAuthenticity();
  }

  Future checkAuthenticity() async {
    authService.getCurrentUser().then((user) async {
      if (user != null) {
        String myUid = await authService.getCurrentUID();
        await MyUserController().getCurrentUserFromFirebase(myUid);
        if (mounted)
          setState(() {
            isAuthenticated = true;
          });
      } else {
        if (mounted)
          setState(() {
            isAuthenticated = false;
          });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // var brightness = MediaQuery.of(context).platformBrightness;
    // bool darkModeOn = brightness == Brightness.dark;
    // ThemeData themeOfContext =
    //     darkModeOn ? fyreworkDarkTheme() : fyreworkLightTheme();

    return ChangeNotifierProvider(
      create: (context) => ConnectivityProvider(),
      child: NetworkSensor(
        child: MaterialApp(
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

          themeMode: ThemeMode.system,
          theme: fyreworkLightTheme(),
          darkTheme: fyreworkDarkTheme(),
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
            // If the locale of the device is not supported, use the first one from the list (English, in this case).
            return supportedLocales.first;
          },

          home: isAuthenticated ? Home(passedSelectedIndex: 0) : StartPage(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
