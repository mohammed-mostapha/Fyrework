import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:myApp/screens/trends/BuyerGigs.dart';
import 'package:myApp/screens/trends/AllAccounts.dart';
import 'package:myApp/screens/trends/providerGigs.dart';
import 'package:myApp/ui/shared/theme.dart';
import 'package:myApp/ui/views/AllGigs_view.dart';

class Trends extends StatefulWidget {
  @override
  _TrendsState createState() => _TrendsState();
}

class _TrendsState extends State<Trends> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    // return Scaffold(
    //   appBar: AppBar(
    //     title: Center(
    //       child: Text(
    //         'Trends',
    //         style:
    //             TextStyle(color: FyreworkrColors.fyreworkBlack, fontSize: 30),
    //         textAlign: TextAlign.center,
    //       ),
    //     ),
    //     backgroundColor: FyreworkrColors.white,
    //   ),
    //   body: Container(
    //     child: ListView.builder(
    //       itemCount: 200,
    //       itemBuilder: (context, index) {
    //         return Padding(
    //           padding: const EdgeInsets.all(10.0),
    //           child: Card(
    //             color: index % 2 == 0 ? Colors.teal : null,
    //             child: Column(
    //               children: <Widget>[
    //                 Text(
    //                   '#Hashtag ${index + 1}',
    //                   style: TextStyle(
    //                     fontSize: 20,
    //                     color: index % 2 == 0 ? Colors.white : null,
    //                     fontWeight: FontWeight.bold,
    //                   ),
    //                 ),
    //                 SizedBox(
    //                   height: 10,
    //                 ),
    //                 Text(
    //                     'lorem ipsum lorem ipsum lorem ipsumlorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum',
    //                     style: TextStyle(fontSize: 20)),
    //               ],
    //             ),
    //           ),
    //         );
    //       },
    //     ),
    //   ),
    // );

    return Scaffold(
      body: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            title: Center(
              child: Text(
                'Fyrework',
                style: TextStyle(
                    color: FyreworkrColors.fyreworkBlack, fontSize: 30),
                textAlign: TextAlign.center,
              ),
            ),
            bottom: TabBar(
              indicatorColor: FyreworkrColors.fyreworkBlack,
              tabs: [
                Tab(
                  child: AutoSizeText('All',
                      style: TextStyle(color: FyreworkrColors.fyreworkBlack),
                      maxLines: 1),
                ),
                Tab(
                  child: AutoSizeText(
                    'Gigs',
                    style: TextStyle(
                      color: FyreworkrColors.fyreworkBlack,
                    ),
                    maxLines: 1,
                  ),
                ),
                Tab(
                  child: AutoSizeText('Providers',
                      style: TextStyle(color: FyreworkrColors.fyreworkBlack),
                      maxLines: 1),
                ),
                Tab(
                  child: AutoSizeText('Accounts',
                      style: TextStyle(color: FyreworkrColors.fyreworkBlack),
                      maxLines: 1),
                ),
              ],
            ),
            backgroundColor: FyreworkrColors.white,
            // actions: <Widget>[
            //   IconButton(
            //     icon: Icon(Icons.undo),
            //     color: FyreworkrColors.fyreworkBlack,
            //     onPressed: () async {
            //       try {
            //         AuthService auth = Provider.of(context).auth;
            //         await auth.signOut();
            //         print('Signed Out!');
            //       } catch (e) {
            //         print(e);
            //       }
            //     },
            //   ),
            //   IconButton(
            //     icon: Icon(Icons.account_circle),
            //     color: FyreworkrColors.fyreworkBlack,
            //     onPressed: () {
            //       Navigator.of(context).pushNamed('/convertUser');
            //     },
            //   )
            // ],
          ),
          body: TabBarView(
            children: [
              // AllGigs(),
              AllGigsView(),
              BuyerGigs(),
              ProviderGigs(),
              AllAccounts(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
