import 'package:Fyrework/screens/add_gig/assets_picker/pages/multi_assets_picker.dart';
import 'package:Fyrework/screens/advertisements/addAdvert.dart';
import 'package:Fyrework/services/firestore_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:Fyrework/models/myUser.dart';
import 'package:Fyrework/screens/add_gig/addGigDetails.dart';
import 'package:Fyrework/screens/my_profile.dart';
import 'package:Fyrework/screens/trends/trends.dart';
import 'package:flutter_svg/svg.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:Fyrework/screens/trends/queryStringProvider.dart';
import 'package:Fyrework/services/local_notification_service.dart';

class Home extends StatefulWidget {
  final int passedSelectedIndex;

  Home({Key key, @required this.passedSelectedIndex}) : super(key: key);
  @override
  _HomeState createState() => _HomeState(passedSelectedIndex);
}

class _HomeState extends State<Home> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final String home_outlined = 'assets/svgs/flaticon/home_outlined.svg';
  final String home_solid = 'assets/svgs/flaticon/home_solid.svg';
  final String add_outlined = 'assets/svgs/flaticon/add_outlined.svg';
  final String add_solid = 'assets/svgs/flaticon/add_solid.svg';
  final String search_thin = 'assets/svgs/flaticon/search_thin.svg';
  final String search_thick = 'assets/svgs/flaticon/search_thick.svg';
  final String megaphone_outlined =
      'assets/svgs/flaticon/megaphone_outlined.svg';
  final String megaphone_solid = 'assets/svgs/flaticon/megaphone_solid.svg';
  final String adverts_outlined = 'assets/svgs/flaticon/adverts_outlined.svg';
  final String adverts_solid = 'assets/svgs/flaticon/adverts_solid.svg';

  // BannerAd firstBannerAd;

  int passedSelectedIndex;
  _HomeState(this.passedSelectedIndex);

  PageController _pageController = PageController(keepPage: false);

  List<Widget> _screens = [
    ChangeNotifierProvider(
      create: (context) => QueryStringProvider(),
      child: Trends(),
    ),
    // AddGigDetails(),
    MultiAssetsPicker(),
    AddAdvert(),
    AddAdvert(),
    MyProfileView(),
  ];

  int _selectedIndex = 0;

  void initState() {
    super.initState();
    _getDeviceToken();
    localNotificationService.initialize(context);
  }

  _getDeviceToken() {
    _firebaseMessaging.getToken().then((deviceToken) {
      print('Device token: $deviceToken');
      FirestoreService().saveDeviceToken(deviceToken);
    });
  }
  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   final mobileAdState = Provider.of<MobileAdsState>(context);
  //   mobileAdState.adStateInitialization.then((status) {
  //     setState(() {
  //       firstBannerAd = BannerAd(
  //         size: AdSize.banner,
  //         adUnitId: mobileAdState.testBannerAdUnit,
  //         request: AdRequest(),
  //         listener: mobileAdState.adListener,
  //       )..load();
  //     });
  //   });
  // }

  // void _onPageChanged(int currentIndex) {}

  void _onItemTapped(int selectedIndex) {
    if (this.mounted) {
      setState(() {
        _selectedIndex = selectedIndex;
      });
      FocusScope.of(context).requestFocus(new FocusNode());
      AddAdvert.advertTextController.clear();
      AddAdvert.myFavoriteHashtagsController.clear();
      _pageController.jumpToPage(selectedIndex);
    }
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
                  // onPageChanged: _onPageChanged,
                  physics: NeverScrollableScrollPhysics(),
                ),
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
                      _selectedIndex == 0 ? home_solid : home_outlined,
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
                      _selectedIndex == 1 ? add_solid : add_outlined,
                      semanticsLabel: 'add',
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  label: 'add',
                ),
                BottomNavigationBarItem(
                  icon: SizedBox(
                    width: 23,
                    height: 23,
                    child: SvgPicture.asset(
                      _selectedIndex == 2
                          ? megaphone_solid
                          : megaphone_outlined,
                      semanticsLabel: 'search',
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  label: 'search',
                ),
                BottomNavigationBarItem(
                  icon: SizedBox(
                    width: 23,
                    height: 23,
                    child: SvgPicture.asset(
                      _selectedIndex == 3 ? adverts_solid : adverts_outlined,
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
                ),
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
