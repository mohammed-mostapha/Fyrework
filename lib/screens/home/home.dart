import 'package:flutter/material.dart';
import 'package:myApp/services/auth_service.dart';
import 'package:myApp/screens/add_gig/addGigDetails.dart';

import 'package:myApp/screens/home/setting_form.dart';
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
    // AddGig(),
    AddGigDetails(),
    // CreateGigView(),
    MyJobs(),
    ProfileView(),
  ];

  int _selectedIndex = 0;

  void initState() {
    super.initState();
    //if user is signed in or has signed up...load userUid from shared preferences
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
    void _showSettingsPanel() {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
              child: SettingsForm(),
            );
          });
    }

    return SafeArea(
      // value: DatabaseService().brews,
      child: MaterialApp(
        theme: ThemeData(
            // primaryColor: FyreworkrColors.fyreworkBlack,
            // accentColor: Colors.green,
            // textTheme: TextTheme(bodyText2: TextStyle(color: Colors.purple)),
            ),
        home: Scaffold(
          // backgroundColor: Colors.purple[50],
          // appBar: AppBar(
          //   title: Center(
          //       child: Text(
          //     'Fyrework',
          //     style: TextStyle(
          //         color: FyreworkrColors.fyreworkBlack, fontSize: 25),
          //   )),
          //   backgroundColor: FyreworkrColors.white,
          //   elevation: 0.0,
          //   actions: <Widget>[
          // FlatButton.icon(
          //   icon: Icon(Icons.person),
          //   label: Text(
          //     'Logout',
          //     style: TextStyle(color: Colors.white),
          //   ),
          //   onPressed: () async {
          //     return await _auth.signout();
          //   },
          // ),
          // FlatButton.icon(
          //   icon: Icon(Icons.settings),
          //   label: Text(
          //     'settings',
          //     style: TextStyle(color: Colors.white),
          //   ),
          //   onPressed: () => _showSettingsPanel(),
          // )
          //   ],
          // ),
          // appBar: AppBar(
          //   backgroundColor: Colors.white,
          //   actions: <Widget>[
          //     IconButton(
          //       icon: Icon(Icons.undo),
          //       color: FyreworkrColors.fyreworkBlack,
          //       onPressed: () async {
          //         try {
          //           AuthService auth = Provider.of(context).auth;
          //           await auth.signOut();
          //           print('Signed Out!');
          //         } catch (e) {
          //           print(e);
          //         }
          //       },
          //     ),
          //     IconButton(
          //       icon: Icon(Icons.account_circle),
          //       color: FyreworkrColors.fyreworkBlack,
          //       onPressed: () {
          //         Navigator.of(context).pushNamed('/convertUser');
          //       },
          //     )
          //   ],
          // ),
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
      ),
    );
  }
}
