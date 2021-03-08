import 'package:flutter/material.dart';
import 'package:Fyrework/screens/trends/appbar_textfield.dart';
import 'package:Fyrework/screens/trends/providerGigs_view.dart';
import 'package:Fyrework/screens/trends/AllGigs_view.dart';
import 'clientGigs_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:Fyrework/ui/widgets/badgeIcon.dart';
import 'package:provider/provider.dart';
import 'package:Fyrework/screens/trends/queryStringProvider.dart';
import 'package:Fyrework/screens/trends/gigIndexProvider.dart';

class Trends extends StatefulWidget {
  @override
  _TrendsState createState() => _TrendsState();
}

class _TrendsState extends State<Trends> with AutomaticKeepAliveClientMixin {
  final String bell = 'assets/svgs/light/bell.svg';
  final String search_thin = 'assets/svgs/flaticon/search_thin.svg';
  final String search_thick = 'assets/svgs/flaticon/search_thick.svg';
  TabController trendsController;
  TextEditingController searchController = TextEditingController();
  bool isSearchOpen = false;
  String queryString;
  var queryStringProvider;

  @override
  void initState() {
    super.initState();
    queryStringProvider =
        Provider.of<QueryStringProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(100),
          child: AppBarTextField(
            leading: Container(
              padding: EdgeInsets.fromLTRB(15, 10, 0, 0),
              width: 50,
              child: StreamBuilder(
                  // stream: 'notifications stream',
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
            searchContainerColor: Theme.of(context).accentColor,
            iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
            title: Container(
              padding: EdgeInsets.only(top: 10),
              child: Row(
                  // contentPadding: EdgeInsets.zero,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/fyrework_logo.png',
                      width: 150,
                      height: 40,
                    ),
                  ]
                  // ],
                  ),
            ),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(50),
              child: isSearchOpen
                  ? Container()
                  : TabBar(
                      indicatorColor: Theme.of(context).primaryColor,
                      indicatorWeight: 2,
                      tabs: [
                        Tab(
                          child: Text('All',
                              style: Theme.of(context).textTheme.bodyText1,
                              maxLines: 1),
                        ),
                        Tab(
                          child: Text(
                            'Gigs',
                            style: Theme.of(context).textTheme.bodyText1,
                            maxLines: 1,
                          ),
                        ),
                        Tab(
                          child: Text(
                            'Providers',
                            style: Theme.of(context).textTheme.bodyText1,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
            ),
            autofocus: false,
            defaultHintText: 'Search Fyrework',
            backgroundColor: Theme.of(context).accentColor,
            controller: searchController,
            onChanged: (query) {
              setState(() {
                queryStringProvider.updateQueryString(query);
              });
            },
            onOpenSearchPressed: () {
              setState(() {
                isSearchOpen = true;
              });
            },
            onBackPressed: () {
              setState(() {
                queryStringProvider.updateQueryString('');
                isSearchOpen = false;
              });
            },
          ),
        ),
        body: TabBarView(
          controller: trendsController,
          children: [
            ChangeNotifierProvider(
              create: (context) => GigIndexProvider(),
              child: AllGigsView(),
            ),
            ClientGigsView(),
            ProviderGigsView(),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
