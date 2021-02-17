import 'package:flutter/material.dart';
import 'package:Fyrework/screens/trends/appbar_textfield.dart';
import 'package:Fyrework/screens/trends/providerGigs_view.dart';
// import 'package:myApp/services/searchScreen.dart';
import 'package:Fyrework/screens/trends/AllGigs_view.dart';
import 'clientGigs_view.dart';
// import 'package:circular_reveal_animation/circular_reveal_animation.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:Fyrework/ui/widgets/badgeIcon.dart';
// import 'package:myApp/screens/search/usersByHandle.dart';
// import 'package:provider/provider.dart';
// import 'package:myApp/screens/trends/queryStringProvider.dart';

class Trends extends StatefulWidget {
  @override
  _TrendsState createState() => _TrendsState();
}

class _TrendsState extends State<Trends> with AutomaticKeepAliveClientMixin {
  final String bell = 'assets/svgs/light/bell.svg';
  final String search_thin = 'assets/svgs/flaticon/search_thin.svg';
  final String search_thick = 'assets/svgs/flaticon/search_thick.svg';
  TextEditingController searchController = TextEditingController();
  bool isSearchOpen = false;
  String queryString;
  var queryStringProvider;

  // @override
  // void initState() {
  //   super.initState();
  //   queryStringProvider =
  //       Provider.of<QueryStringProvider>(context, listen: false);
  // }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBarTextField(
          // title: Text("Contacts"),
          searchContainerColor: Theme.of(context).accentColor,
          iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
          title: Container(
            width: MediaQuery.of(context).size.width / 1,
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              // mainAxisAlignment: MainAxisAlignment.center,
              // children: [
              leading: Container(
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
              title: Image.asset(
                'assets/images/fyrework_logo.png',
                width: 150,
                height: 40,
              ),
              // ],
            ),
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
                child: Text(
                  'Providers',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
                  maxLines: 1,
                ),
              ),
            ],
          ),
          backgroundColor: Theme.of(context).accentColor,
          // onBackPressed: _onRestoreAllData,
          // onClearPressed: _onRestoreAllData,
          // onChanged: _onSearchChanged,
          controller: searchController,
          // onChanged: updateQueryString(searchController.text),
          onChanged: (query) {
            // setState(() {
            //   // queryString = query;
            //   queryStringProvider.updateQueryString(query);
            // });
          },
          onOpenSearchPressed: () {
            //   setState(() {
            //     isSearchOpen = true;
            //   });
          },
          onBackPressed: () {
            //   setState(() {
            //     isSearchOpen = false;
            //   });
          },
        ),
        body: TabBarView(
          children: [
            // ChangeNotifierProvider(
            //   create: (context) => QueryStringProvider(),
            //   child: AllGigsView(),
            // ),
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
