import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:myApp/locator.dart';
import 'package:myApp/ui/views/sign_up_view.dart';
import 'package:myApp/ui/widgets/provider_widget.dart';
import 'package:myApp/ui/shared/theme.dart';
import 'package:myApp/new_services/auth_service.dart';
import 'package:myApp/new_services/storage_repo.dart';

// import 'package:myApp/services/auth.dart';

class ProfileView extends StatefulWidget {
  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  AuthService _authService = locator.get<AuthService>();
  StorageRepo _storageRepo = locator.get<StorageRepo>();
  AuthFormType authFormType;
  dynamic userProfilePictureUrl;

  Future<String> getProfilePictureDownloadUrl() async {
    print('some workkkkkk');
    return userProfilePictureUrl = await _storageRepo
        .getUserProfilePictureDownloadUrl(await _authService.getCurrentUID());
  }

  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance
  //       .addPostFrameCallback((_) => getProfilePictureDownloadUrl());
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Center(
      //     child: Text(
      //       'Profile',
      //       style:
      //           TextStyle(color: FyreworkrColors.fyreworkBlack, fontSize: 30),
      //       textAlign: TextAlign.center,
      //     ),
      //   ),
      //   backgroundColor: FyreworkrColors.white,
      //   actions: [
      //     FlatButton.icon(
      //       icon: Icon(Icons.person),
      //       label: Text(
      //         'Logout',
      //         style: TextStyle(color: Colors.white),
      //       ),
      //       onPressed: () async {
      //         final AuthService _auth = AuthService();
      //         return await _auth.signout();
      //       },
      //     ),
      //     FlatButton.icon(
      //         icon: Icon(Icons.settings),
      //         label: Text(
      //           'settings',
      //           style: TextStyle(color: Colors.white),
      //         ),
      //         onPressed: () {
      //           // _showSettingsPanel(),
      //         })
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
      //         // Navigator.of(context).pushNamed('/convertUser');
      //         Navigator.push(
      //             context,
      //             MaterialPageRoute(
      //                 builder: (context) =>
      //                     SignUpView(authFormType: AuthFormType.convert)));
      //       },
      //     )
      //   ],
      // ),

      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            FutureBuilder(
              future: Provider.of(context).auth.getCurrentUser(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Column(
                    children: [
                      // Container(
                      //   width: 100,
                      //   height: 100,
                      //   child: userProfilePictureUrl == null
                      //       ? CircularProgressIndicator()
                      //       : NetworkImage(userProfilePictureUrl),
                      // ),

                      displayUserMetadata(context, snapshot),
                    ],
                  );
                } else {
                  return Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: Center(child: CircularProgressIndicator()));
                }
              },
            ),
            FutureBuilder(
              future: Provider.of(context).auth.getCurrentUser(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Column(
                    children: [
                      // Container(
                      //   width: 100,
                      //   height: 100,
                      //   child: userProfilePictureUrl == null
                      //       ? CircularProgressIndicator()
                      //       : NetworkImage(userProfilePictureUrl),
                      // ),
                      snapshot.data.isAnonymous
                          ? Container(
                              child: Text(
                                  'You are an Anonymous user in the mean timeeeeeeee'),
                            )
                          : displayUserInformation(context, snapshot),
                    ],
                  );
                } else {
                  return Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: Center(child: CircularProgressIndicator()));
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget displayUserMetadata(context, snapshot) {
    final authData = snapshot.data;
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: <Widget>[
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: AutoSizeText(
          //     "Name: ${authData.displayName ?? 'Anonymous'}",
          //     style: TextStyle(fontSize: 20),
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: AutoSizeText(
              "${authData.email ?? 'Anonymous'}",
              style: TextStyle(fontSize: 20),
            ),
            // child: AutoSizeText(
            //   "${authData.email ?? 'Anonymous'}",
            //   style: TextStyle(fontSize: 20),
            // ),
          ),
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: AutoSizeText(
          //     "Created: ${DateFormat.yMd().format(DateTime.fromMillisecondsSinceEpoch(authData.metadata.creationTimestamp))}",
          //     style: TextStyle(fontSize: 20),
          //   ),
          // ),
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: AutoSizeText(
          //     "Last time user signedIn: ${DateFormat.yMd().format(DateTime.fromMillisecondsSinceEpoch(authData.metadata.lastSignInTimestamp))}",
          //     style: TextStyle(fontSize: 20),
          //     textAlign: TextAlign.center,
          //   ),
          // ),
          showSignOut(context, authData.isAnonymous)
        ],
      ),
    );
  }

  Widget displayUserInformation(context, snapshot) {
    return FutureBuilder(
        future: getProfilePictureDownloadUrl(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Container(
              width: 100,
              height: 100,
              child: Image.network(userProfilePictureUrl),
            );
          } else {
            return Container(
              width: 70,
              height: 70,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    FyreworkrColors.fyreworkBlack),
              ),
            );
          }
        });

    // return Row(
    //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //   children: [
    //     Padding(
    //       padding: const EdgeInsets.all(8.0),
    //       child: CircleAvatar(
    //         radius: 60,
    //         backgroundColor: FyreworkrColors.fyreworkBlack,
    //         backgroundImage: NetworkImage(userProfilePictureUrl),
    //       ),
    //     ),
    //     Padding(
    //       padding: const EdgeInsets.all(8.0),
    //       child: Column(
    //         children: <Widget>[
    //           AutoSizeText(
    //             'Gigs',
    //             style: TextStyle(fontSize: 20.0),
    //           ),
    //           AutoSizeText(
    //             '5',
    //             style: TextStyle(fontSize: 20.0),
    //           ),
    //         ],
    //       ),
    //     ),
    //     Padding(
    //       padding: const EdgeInsets.all(8.0),
    //       child: Column(
    //         children: <Widget>[
    //           AutoSizeText(
    //             'Ongoing gigs',
    //             style: TextStyle(fontSize: 20.0),
    //           ),
    //           AutoSizeText(
    //             '5',
    //             style: TextStyle(fontSize: 20.0),
    //           ),
    //         ],
    //       ),
    //     ),
    //     // Padding(
    //     //   padding: const EdgeInsets.all(8.0),
    //     //   child: Column(
    //     //     children: <Widget>[
    //     //       AutoSizeText(
    //     //         'Completed Gigs',
    //     //         style: TextStyle(fontSize: 20.0),
    //     //       ),
    //     //       AutoSizeText(
    //     //         '5',
    //     //         style: TextStyle(fontSize: 20.0),
    //     //       ),
    //     //     ],
    //     //   ),
    //     // ),
    //   ],
    // );
  }

  Widget showSignOut(context, bool isAnonymous) {
    if (isAnonymous == true) {
      return RaisedButton(
        child: AutoSizeText("Sign up to save your data"),
        onPressed: () {
          // Navigator.of(context).pushNamed('/convertUser');
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      SignUpView(authFormType: AuthFormType.convert)));
        },
      );
    } else {
      return RaisedButton(
        child: AutoSizeText("Sign out"),
        onPressed: () async {
          try {
            await Provider.of(context).auth.signOut();
          } catch (e) {
            print(e);
          }
        },
      );
    }
  }
}
