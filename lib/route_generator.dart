import 'package:flutter/material.dart';
import 'package:myApp/screens/authenticate/register.dart';
import 'package:myApp/screens/authenticate/sign_in.dart';
import 'package:myApp/screens/wrapper.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    // final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => Wrapper());

      case '/signIn':
        // Validation of correct data type

        return MaterialPageRoute(
          builder: (_) => SignIn(),
        );

      case '/register':
        // Validation of correct data type

        return MaterialPageRoute(
          builder: (_) => Register(),
        );

      // If args is not of the correct type, return an error page.
      // You can also throw an exception while in development.

      default:
        // If there is no such named route in the switch statement,
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
