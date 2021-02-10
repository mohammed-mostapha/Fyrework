import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:myApp/screens/trends/providerGigs_view.dart';
import 'package:myApp/ui/shared/fyreworkTheme.dart';
import 'package:myApp/screens/trends/AllGigs_view.dart';
import 'package:myApp/ui/widgets/badgeIcon.dart';

import 'clientGigs_view.dart';

class Trends extends StatefulWidget {
  @override
  _TrendsState createState() => _TrendsState();
}

class _TrendsState extends State<Trends> with AutomaticKeepAliveClientMixin {
  final String bell = 'assets/svgs/light/bell.svg';

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(50, 0, 0, 0),
                  child: Center(
                    child: Image.asset(
                      'assets/images/fyrework_logo.png',
                      width: 150,
                    ),
                  ),
                ),
              ),
              Container(
                width: 50,
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
            ],
          ),
          backgroundColor: Theme.of(context).accentColor,
        ),
        body: TabBarView(
          children: [
            AllGigsView(),
            ClientGigsView(),
            ProvierGigsView(),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
