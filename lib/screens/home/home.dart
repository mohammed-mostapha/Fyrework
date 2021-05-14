import 'package:Fyrework/services/mobileAds_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:Fyrework/models/myUser.dart';
import 'package:Fyrework/screens/add_gig/addGigDetails.dart';
import 'package:Fyrework/screens/my_profile.dart';
import 'package:Fyrework/screens/trends/trends.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:Fyrework/screens/trends/queryStringProvider.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  final int passedSelectedIndex;

  Home({Key key, @required this.passedSelectedIndex}) : super(key: key);
  @override
  _HomeState createState() => _HomeState(passedSelectedIndex);
}

class _HomeState extends State<Home> {
  final String home_outlined = 'assets/svgs/flaticon/home_outlined.svg';
  final String home_filled = 'assets/svgs/flaticon/home_filled.svg';
  final String add_outlined = 'assets/svgs/flaticon/add_outlined.svg';
  final String add_filled = 'assets/svgs/flaticon/add_filled.svg';
  final String search_thin = 'assets/svgs/flaticon/search_thin.svg';
  final String search_thick = 'assets/svgs/flaticon/search_thick.svg';

  BannerAd firstBannerAd;

  int passedSelectedIndex;
  _HomeState(this.passedSelectedIndex);

  PageController _pageController = PageController();

  List<Widget> _screens = [
    ChangeNotifierProvider(
      create: (context) => QueryStringProvider(),
      child: Trends(),
    ),
    AddGigDetails(),
    AddGigDetails(),
    MyProfileView(),
  ];

  int _selectedIndex = 0;

  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final mobileAdState = Provider.of<MobileAdsState>(context);
    mobileAdState.adStateInitialization.then((status) {
      setState(() {
        firstBannerAd = BannerAd(
          size: AdSize.banner,
          adUnitId: mobileAdState.testBannerAdUnit,
          request: AdRequest(),
          listener: mobileAdState.adListener,
        )..load();
      });
    });
  }

  void _onPageChanged(int currentIndex) {
    if (this.mounted) {
      setState(() {
        _selectedIndex = currentIndex;
      });
    }
  }

  void _onItemTapped(int selectedIndex) {
    _pageController.jumpToPage(selectedIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              Expanded(
                child: PageView(
                  controller: _pageController,
                  children: _screens,
                  onPageChanged: _onPageChanged,
                  physics: NeverScrollableScrollPhysics(),
                ),
              ),
              if (firstBannerAd == null)
                SizedBox(
                  height: 50,
                )
              else
                Container(
                  height: 50,
                  child: AdWidget(ad: firstBannerAd),
                ),
            ],
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              border: Border(
                  top: BorderSide(
                      width: 0.5, color: Theme.of(context).primaryColor)),
            ),
            child: BottomNavigationBar(
              elevation: 0.0,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              onTap: _onItemTapped,
              items: [
                BottomNavigationBarItem(
                  icon: SizedBox(
                    width: 20,
                    height: 20,
                    child: SvgPicture.asset(
                      _selectedIndex == 0 ? home_filled : home_outlined,
                      semanticsLabel: 'home',
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  label: 'home',
                ),
                BottomNavigationBarItem(
                  icon: SizedBox(
                    width: 20,
                    height: 20,
                    child: SvgPicture.asset(
                      _selectedIndex == 1 ? add_filled : add_outlined,
                      semanticsLabel: 'add',
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  label: 'add',
                ),
                BottomNavigationBarItem(
                  icon: SizedBox(
                    width: 20,
                    height: 20,
                    child: SvgPicture.asset(
                      _selectedIndex == 2 ? search_thick : search_thin,
                      semanticsLabel: 'search',
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  label: 'search',
                ),
                BottomNavigationBarItem(
                  icon: SizedBox(
                    width: 20,
                    height: 20,
                    child: CachedNetworkImage(
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: imageProvider, fit: BoxFit.cover),
                        ),
                      ),
                      imageUrl: MyUser.userAvatarUrl,
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                  label: 'account',
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
