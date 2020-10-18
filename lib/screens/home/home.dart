import 'package:flutter/material.dart';
import 'package:myApp/services/auth_service.dart';
import 'package:myApp/screens/add_gig/addGigDetails.dart';
import 'package:myApp/screens/myJobs.dart';
import 'package:myApp/screens/profile.dart';
import 'package:myApp/screens/trends/trends.dart';

import 'package:myApp/ui/shared/theme.dart';

class Home extends StatefulWidget {
  final int passedSelectedIndex;
  Home({Key key, @required this.passedSelectedIndex}) : super(key: key);
  @override
  _HomeState createState() => _HomeState(passedSelectedIndex);
}

class _HomeState extends State<Home> {
  int passedSelectedIndex;
  _HomeState(this.passedSelectedIndex);

  PageController _pageController = PageController();

  List<Widget> _screens = [
    Trends(),
    AddGigDetails(),
    MyJobs(),
    ProfileView(),
  ];

  int _selectedIndex = 0;

  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(() {
      _selectedIndex = passedSelectedIndex;
      Future.delayed(Duration(seconds: 0), () {
        _pageController.jumpToPage(_selectedIndex);
      });
    }());
  }

  void _onPageChanged(int currentIndex) {
    setState(() {
      _selectedIndex = currentIndex;
    });
  }

  void _onItemTapped(int selectedIndex) {
    _pageController.jumpToPage(selectedIndex);
  }

  final AuthService _auth = AuthService();

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
          showSelectedLabels: false,
          showUnselectedLabels: false,
          onTap: _onItemTapped,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home,
                  color: _selectedIndex == 0
                      ? FyreworkrColors.fyreworkBlack
                      : Colors.grey),
              title: Text('home'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_box,
                  color: _selectedIndex == 1
                      ? FyreworkrColors.fyreworkBlack
                      : Colors.grey),
              title: Text('add'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.work,
                  color: _selectedIndex == 2
                      ? FyreworkrColors.fyreworkBlack
                      : Colors.grey),
              title: Text('work'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle,
                  color: _selectedIndex == 3
                      ? FyreworkrColors.fyreworkBlack
                      : Colors.grey),
              title: Text('account'),
            )
          ],
        ),
      ),
    );
  }
}
