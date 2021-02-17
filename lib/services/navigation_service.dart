import 'package:flutter/material.dart';
import 'package:Fyrework/screens/home/home.dart';

class NavigationService {
  GlobalKey<NavigatorState> _navigationKey = GlobalKey<NavigatorState>();

  GlobalKey<NavigatorState> get navigationKey => _navigationKey;

  // bool pop() {
  void pop() {
    return _navigationKey.currentState.pop();
  }

  void previewAllGigs() {
    MaterialPage(
      builder: (BuildContext context) => Home(passedSelectedIndex: 0),
    );
  }

  Future<dynamic> navigateTo(String routeName, {dynamic arguments}) {
    return _navigationKey.currentState
        .pushNamed(routeName, arguments: arguments);
  }
}
