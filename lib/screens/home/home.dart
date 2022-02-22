import 'package:Fyrework/screens/add_gig/assets_picker/pages/multi_assets_picker.dart';
import 'package:Fyrework/screens/advertisements/addAdvert.dart';
import 'package:Fyrework/firebase_database/firestore_database.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:Fyrework/models/myUser.dart';
import 'package:Fyrework/screens/my_profile.dart';
import 'package:Fyrework/screens/trends/trends.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
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
  final String homeOutlined = 'assets/svgs/flaticon/home_outlined.svg';
  final String homeSolid = 'assets/svgs/flaticon/home_solid.svg';
  final String addOutlined = 'assets/svgs/flaticon/add_outlined.svg';
  final String addSolid = 'assets/svgs/flaticon/add_solid.svg';
  final String searchThin = 'assets/svgs/flaticon/search_thin.svg';
  final String searchThick = 'assets/svgs/flaticon/search_thick.svg';
  final String megaphoneOutlined =
      'assets/svgs/flaticon/megaphone_outlined.svg';
  final String megaphoneSolid = 'assets/svgs/flaticon/megaphone_solid.svg';
  final String advertsOutlined = 'assets/svgs/flaticon/adverts_outlined.svg';
  final String advertsSolid = 'assets/svgs/flaticon/adverts_solid.svg';

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

    Future.delayed(Duration.zero, () {
      _onItemTapped(widget.passedSelectedIndex == null
          ? _selectedIndex
          : widget.passedSelectedIndex);
    });
  }

  _getDeviceToken() {
    _firebaseMessaging.getToken().then((deviceToken) {
      print('Device token: $deviceToken');
      FirestoreDatabase().saveDeviceToken(deviceToken);
    });
  }

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
                      _selectedIndex == 0 ? homeSolid : homeOutlined,
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
                      _selectedIndex == 1 ? addSolid : addOutlined,
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
                      _selectedIndex == 2 ? megaphoneSolid : megaphoneOutlined,
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
                      _selectedIndex == 3 ? advertsSolid : advertsOutlined,
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
                    child: MyUser.userAvatarUrl == null
                        ? Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: AssetImage(
                                  'assets/images/avatar-placeholder.png',
                                ),
                              ),
                            ),
                          )
                        : CachedNetworkImage(
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
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
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
