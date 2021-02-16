import 'package:flutter/material.dart';
import 'package:myApp/screens/trends/providerGigs_view.dart';
import 'package:myApp/services/searchScreen.dart';
import 'package:myApp/screens/trends/AllGigs_view.dart';
import 'clientGigs_view.dart';
import 'package:myApp/ui/widgets/appbar_textfield.dart';
// import 'package:circular_reveal_animation/circular_reveal_animation.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:myApp/ui/widgets/badgeIcon.dart';

class Trends extends StatefulWidget {
  @override
  _TrendsState createState() => _TrendsState();
}

class _TrendsState extends State<Trends> with AutomaticKeepAliveClientMixin {
  final String bell = 'assets/svgs/light/bell.svg';
  final String search_thin = 'assets/svgs/flaticon/search_thin.svg';
  final String search_thick = 'assets/svgs/flaticon/search_thick.svg';

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        // appBar: AppBar(
        //   title: Row(
        //     children: [
        //       Container(
        //         width: 40,
        //         child: StreamBuilder(
        //             builder: (_, snapshot) => GestureDetector(
        //                   child: BadgeIcon(
        //                     icon: SizedBox(
        //                       width: 20,
        //                       height: 40,
        //                       child: SvgPicture.asset(
        //                         bell,
        //                         semanticsLabel: 'bell_notifications',
        //                       ),
        //                     ),
        //                     badgeCount: 999,
        //                     badgeColor: Theme.of(context).primaryColor,
        //                     badgeTextStyle: TextStyle(
        //                       fontSize: 12,
        //                       // color: Theme.of(context).primaryColor,
        //                       color: Colors.white,
        //                     ),
        //                   ),
        //                   onTap: () {},
        //                 )),
        //       ),
        //       Expanded(
        //         child: Center(
        //           child: Image.asset(
        //             'assets/images/fyrework_logo.png',
        //             width: 150,
        //           ),
        //         ),
        //       ),
        //     ],
        //   ),
        //   bottom: TabBar(
        //     indicatorColor: Theme.of(context).primaryColor,
        //     tabs: [
        //       Tab(
        //         child: Text('All',
        //             style: TextStyle(
        //               color: Theme.of(context).primaryColor,
        //             ),
        //             maxLines: 1),
        //       ),
        //       Tab(
        //         child: Text(
        //           'Gigs',
        //           style: TextStyle(
        //             color: Theme.of(context).primaryColor,
        //           ),
        //           maxLines: 1,
        //         ),
        //       ),
        //       Tab(
        //         child: Text('Providers',
        //             style: TextStyle(
        //               color: Theme.of(context).primaryColor,
        //             ),
        //             maxLines: 1),
        //       ),
        //       Tab(
        //         child: SizedBox(
        //           width: 20,
        //           height: 40,
        //           child: SvgPicture.asset(
        //             search_thick,
        //             semanticsLabel: 'search',
        //             color: Theme.of(context).primaryColor,
        //           ),
        //         ),
        //       ),
        //     ],
        //   ),
        //   backgroundColor: Theme.of(context).accentColor,

        appBar: AppBarTextField(
          // title: Text("Contacts"),
          title: Row(
            children: [
              Container(
                width: 40,
                child: StreamBuilder(
                    builder: (_, snapshot) => GestureDetector(
                          child: BadgeIcon(
                            icon: SizedBox(
                              width: 20,
                              height: 40,
                              child: SvgPicture.asset(
                                bell,
                                semanticsLabel: 'bell_notifications',
                              ),
                            ),
                            badgeCount: 999,
                            badgeColor: Theme.of(context).primaryColor,
                            badgeTextStyle: TextStyle(
                              fontSize: 12,
                              // color: Theme.of(context).primaryColor,
                              color: Colors.white,
                            ),
                          ),
                          onTap: () {},
                        )),
              ),
              Expanded(
                child: Center(
                  child: Image.asset(
                    'assets/images/fyrework_logo.png',
                    width: 150,
                  ),
                ),
              ),
            ],
          ),
          bottom: TabBar(
            indicatorColor: Theme.of(context).primaryColor,
            tabs: [
              Tab(
                child: Text('All',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                    maxLines: 1),
              ),
              Tab(
                child: Text(
                  'Gigs',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
                  maxLines: 1,
                ),
              ),
              Tab(
                child: Text('Providers',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                    maxLines: 1),
              ),
              Tab(
                child: SizedBox(
                  width: 20,
                  height: 40,
                  child: SvgPicture.asset(
                    search_thick,
                    semanticsLabel: 'search',
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: Theme.of(context).accentColor,
          // onBackPressed: _onRestoreAllData,
          // onClearPressed: _onRestoreAllData,
          // onChanged: _onSearchChanged,
        ),
        body: TabBarView(
          children: [
            AllGigsView(),
            ClientGigsView(),
            ProvierGigsView(),
            SearchScreen(),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
