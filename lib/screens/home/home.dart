import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:Fyrework/models/myUser.dart';
import 'package:Fyrework/screens/add_gig/addGigDetails.dart';
import 'package:Fyrework/screens/my_profile.dart';
import 'package:Fyrework/screens/trends/trends.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:Fyrework/screens/trends/queryStringProvider.dart';

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

  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance.addPostFrameCallback(() {
  //     _selectedIndex = passedSelectedIndex;
  //     Future.delayed(Duration(seconds: 0), () {
  //       _pageController.jumpToPage(_selectedIndex);
  //     });
  //   }());
  // }

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

  // final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: PageView(
          controller: _pageController,
          children: _screens,
          onPageChanged: _onPageChanged,
          physics: NeverScrollableScrollPhysics(),
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Theme.of(context).primaryColor,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
          onTap: _onItemTapped,
          items: [
            BottomNavigationBarItem(
              icon: SizedBox(
                width: 20,
                height: 20,
                child: SvgPicture.asset(
                  _selectedIndex == 0 ? home_filled : home_outlined,
                  semanticsLabel: 'home',
                  color: Theme.of(context).accentColor,
                ),
              ),
              title: Text('home'),
            ),
            BottomNavigationBarItem(
              icon: SizedBox(
                width: 20,
                height: 20,
                child: SvgPicture.asset(
                  _selectedIndex == 1 ? add_filled : add_outlined,
                  semanticsLabel: 'add',
                  color: Theme.of(context).accentColor,
                ),
              ),
              title: Text('add'),
            ),
            BottomNavigationBarItem(
              icon: SizedBox(
                width: 20,
                height: 20,
                child: SvgPicture.asset(
                  _selectedIndex == 2 ? search_thick : search_thin,
                  semanticsLabel: 'search',
                  color: Theme.of(context).accentColor,
                ),
              ),
              title: Text('search'),
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
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
              title: Text('account'),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
