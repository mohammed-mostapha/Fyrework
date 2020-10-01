import 'package:flutter/material.dart';
import 'package:myApp/screens/authenticate/app_start.dart';
import 'package:myApp/screens/authenticate/authenticate.dart';
import 'package:myApp/screens/home/home.dart';
import 'package:myApp/ui/views/first_view.dart';
import 'package:provider/provider.dart';
import 'package:myApp/models/user.dart';

import '../route_generator.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    // return either Home or Authenticate widget
    // if (user == null) {
    //   // return Authenticate();
    //   return StartPage();
    // } else {
    //   return Home();
    // }

    return MaterialApp(
      onGenerateRoute: RouteGenerator.generateRoute,
      home: user == null
          // ? StartPage()
          ? FirstView()
          : Home(
              passedSelectedIndex: 0,
            ),
    );
  }
}
