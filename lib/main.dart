import 'package:flutter/material.dart';
import 'package:myApp/models/user.dart';
import 'package:myApp/screens/add_gig/assets_picker/pages/multi_assets_picker.dart';
import 'package:myApp/screens/add_gig/assets_picker/src/widget/asset_picker.dart';
import 'package:myApp/screens/authenticate/app_start.dart';
import 'package:myApp/screens/home/home.dart';
import 'package:myApp/screens/wrapper.dart';
// import 'package:myApp/services/auth.dart';
import 'package:myApp/new_services/auth_service.dart';
import 'package:myApp/ui/views/first_view.dart';
import 'package:myApp/ui/views/sign_up_view.dart';
// import 'package:provider/provider.dart';
import 'package:myApp/ui/widgets/provider_widget.dart';
import 'package:flutter/material.dart';
import 'package:myApp/services/navigation_service.dart';
import 'package:myApp/services/dialog_service.dart';
import 'managers/dialog_manager.dart';
import 'ui/router.dart';
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
    // return StreamProvider<User>.value(
    //   value: AuthService().user,
    //   child: MaterialApp(
    //     builder: (context, child) => Navigator(
    //       key: locator<DialogService>().dialogNavigationKey,
    //       onGenerateRoute: (settings) => MaterialPageRoute(
    //           builder: (context) => DialogManager(child: child)),
    //     ),
    //     routes: {
    //       '/addGig': (context) => Home(passedSelectedIndex: 1),
    //     },
    //     home: Wrapper(),
    //   ),
    // );
    return Provider(
      auth: AuthService(),
      child: MaterialApp(
        home: HomeController(),
        // builder: (context, child) => Navigator(
        //   key: locator<DialogService>().dialogNavigationKey,
        //   onGenerateRoute: (settings) => MaterialPageRoute(
        //       builder: (context) => DialogManager(child: child)),
        // ),
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

class HomeController extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthService auth = Provider.of(context).auth;
    return StreamBuilder<String>(
        stream: auth.onAuthStateChanged,
        builder: (context, AsyncSnapshot<String> snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            final bool signedIn = snapshot.hasData;
            return signedIn ? Home(passedSelectedIndex: 0) : StartPage();
          }
          return CircularProgressIndicator();
        });
  }
}
