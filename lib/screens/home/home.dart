import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myApp/models/myUser.dart';
import 'package:myApp/models/otherUser.dart';
import 'package:myApp/screens/add_gig/addGigDetails.dart';
import 'package:myApp/screens/myJobs.dart';
import 'package:myApp/screens/my_profile.dart';
import 'package:myApp/screens/trends/trends.dart';
import 'package:myApp/services/database.dart';
import 'package:myApp/ui/shared/theme.dart';
import 'package:flutter_svg/svg.dart';
import 'package:myApp/ui/widgets/user_profile.dart';

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
    Trends(),
    AddGigDetails(),
    MyJobs(),
    MyProfileView(),
  ];

  int _selectedIndex = 0;

  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback(() {
    //   _selectedIndex = passedSelectedIndex;
    //   Future.delayed(Duration(seconds: 0), () {
    //     _pageController.jumpToPage(_selectedIndex);
    //   });
    // }());
  }

  void _onPageChanged(int currentIndex) {
    setState(() {
      _selectedIndex = currentIndex;
    });
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
          backgroundColor: FyreworkrColors.fyreworkBlack,
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
              icon: GestureDetector(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: SvgPicture.asset(
                    _selectedIndex == 2 ? search_thick : search_thin,
                    semanticsLabel: 'search',
                    color: Theme.of(context).accentColor,
                  ),
                ),
                onTap: () {
                  showSearch(
                    context: context,
                    delegate: HashtagsOrHandles(
                        DatabaseService().fetchUsersInSearchByHandle()),
                  );
                },
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
}

//Search delegate
class HashtagsOrHandles extends SearchDelegate<OtherUser> {
  final Stream<QuerySnapshot> otherUser;

  HashtagsOrHandles(this.otherUser);
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    showUserProfile(String userId) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => UserProfileView(
                    passedUserUid: userId,
                    // passedUsername: widget.gigOwnerUsername,
                    fromComment: false,
                    fromGig: true,
                  )));
    }

    return StreamBuilder<QuerySnapshot>(
        stream: DatabaseService().fetchUsersInSearchByHandle(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: Text(
                '',
                style: TextStyle(
                    fontSize: 16, color: Theme.of(context).primaryColor),
              ),
            );
          }
          if (snapshot.data.documents.length > 0) {
            final results = snapshot.data.documents
                .where((a) => a['username'].contains(query));

            return ListView(
              children: results
                  .map<Widget>(
                      // (u) => Text(u['username'],),
                      (u) => GestureDetector(
                            child: Padding(
                              padding: const EdgeInsets.all(0.1),
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 5),
                                decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    border: Border(
                                        bottom: BorderSide(
                                            width: 0.3,
                                            color: Colors.grey[50]))),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                    backgroundImage:
                                        NetworkImage(u['userAvatarUrl']),
                                    radius: 25,
                                  ),
                                  title: Container(
                                    padding: EdgeInsets.only(left: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(u['username'],
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Theme.of(context)
                                                    .accentColor),
                                            overflow: TextOverflow.ellipsis),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(u['name'],
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey[500],
                                                fontWeight: FontWeight.bold),
                                            overflow: TextOverflow.ellipsis),
                                      ],
                                    ),
                                  ),
                                  trailing: Container(
                                    padding: EdgeInsets.only(left: 10),
                                    height: 43.0,
                                    width:
                                        MediaQuery.of(context).size.width / 2,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount:
                                                u['favoriteHashtags'].length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              final hashtagItem =
                                                  u['favoriteHashtags'][index] +
                                                      ' ';
                                              return Text('$hashtagItem',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Theme.of(context)
                                                          .accentColor));
                                            },
                                          ),
                                        ),
                                        Text(
                                          u['location'],
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey[500],
                                            fontWeight: FontWeight.bold,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            onTap: () {
                              showUserProfile(u['id']);
                            },
                          ))
                  .toList(),
            );
          } else {
            return Center(
              child: Text(
                'No results found',
                style: TextStyle(
                    fontSize: 16, color: Theme.of(context).primaryColor),
              ),
            );
          }
        });
  }
}
