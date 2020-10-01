import 'package:myApp/models/gig.dart';
import 'package:myApp/ui/views/create_gig_view.dart';
import 'package:myApp/ui/views/AllGigs_view.dart';
import 'package:flutter/material.dart';
import 'package:myApp/constants/route_names.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case HomeViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: AllGigsView(),
      );
    case CreateGigViewRoute:
      var gigToEdit = settings.arguments as Gig;
      return _getPageRoute(
        routeName: settings.name,
        // viewToShow: CreateGigView(
        //   edittinGig: gigToEdit,
        // ),
      );
    default:
      return MaterialPageRoute(
          builder: (_) => Scaffold(
                body: Center(
                    child: Text('No route defined for ${settings.name}')),
              ));
  }
}

PageRoute _getPageRoute({String routeName, Widget viewToShow}) {
  return MaterialPageRoute(
      settings: RouteSettings(
        name: routeName,
      ),
      builder: (_) => viewToShow);
}
