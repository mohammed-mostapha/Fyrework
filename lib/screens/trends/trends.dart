import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:myApp/screens/trends/BuyerGigs.dart';
import 'package:myApp/screens/trends/providerGigs.dart';
import 'package:myApp/ui/shared/theme.dart';
import 'package:myApp/screens/trends/AllGigs_view.dart';

class Trends extends StatefulWidget {
  @override
  _TrendsState createState() => _TrendsState();
}

class _TrendsState extends State<Trends> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Image.asset(
              'assets/images/fyrework_logo.png',
              width: 150,
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
            ],
          ),
          backgroundColor: FyreworkrColors.white,
        ),
        body: TabBarView(
          children: [
            AllGigsView(),
            BuyerGigs(),
            ProviderGigs(),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
