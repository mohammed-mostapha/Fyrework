import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:myApp/locator.dart';
import 'package:myApp/services/database.dart';
import 'package:myApp/ui/views/sign_up_view.dart';
// import 'package:myApp/ui/widgets/provider_widget.dart';
import 'package:myApp/ui/shared/theme.dart';
import 'package:myApp/services/auth_service.dart';
import 'package:myApp/services/storage_repo.dart';

class MyProfileView extends StatefulWidget {
  @override
  _MyProfileViewState createState() => _MyProfileViewState();
}

class _MyProfileViewState extends State<MyProfileView> {
  AuthService _authService = locator.get<AuthService>();
  StorageRepo _storageRepo = locator.get<StorageRepo>();
  AuthFormType authFormType;
  dynamic userProfilePictureUrl;

  Future<String> getProfilePictureDownloadUrl() async {
    print('fetching profile picture url');
    return userProfilePictureUrl = await _storageRepo
        .getUserProfilePictureDownloadUrl(await _authService.getCurrentUID());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            FutureBuilder(
              // future: Provider.of(context).auth.getCurrentUser(),
              future: AuthService().getCurrentUser(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Column(
                    children: [
                      displayUserMetadata(context, snapshot),
                      Column(
                        children: [
                          snapshot.data.isAnonymous
                              ? Container(
                                  child: Text(
                                      'You are an Anonymous user in the mean timeeeeeeee'),
                                )
                              : displayUserInformation(context, snapshot),
                        ],
                      ),
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: AutoSizeText(
              "${authData.email ?? 'Anonymous'}",
              style: TextStyle(fontSize: 20),
            ),
          ),
          showSignOut(context, authData.isAnonymous)
        ],
      ),
    );
  }

  Widget displayUserInformation(context, snapshot) {
    final authData = snapshot.data;
    return FutureBuilder(
        future: getProfilePictureDownloadUrl(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // return Container(
            //   width: 100,
            //   height: 100,
            //   child: Image.network(userProfilePictureUrl),
            // );
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(userProfilePictureUrl),
                    radius: 50,
                  ),
                  SizedBox(
                    height: 100,
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            "Ongoing gigs",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        StreamBuilder(
                          stream: DatabaseService().userData(authData.uid),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return CircularProgressIndicator();
                            } else if ((snapshot.hasData &&
                                snapshot.data.ongoingGigsByGigId == null)) {
                              return Expanded(
                                child: Text(
                                  '0',
                                  style: TextStyle(fontSize: 18),
                                ),
                              );
                            } else {
                              return Expanded(
                                  child: Text(
                                '${snapshot.data.ongoingGigsByGigId.length}',
                                style: TextStyle(fontSize: 18),
                              ));
                            }
                          },
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 100,
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            "Completed gigs",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            "5",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
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
  }

  Widget showSignOut(context, bool isAnonymous) {
    return RaisedButton(
      child: AutoSizeText("Sign out"),
      onPressed: () async {
        try {
          // await Provider.of(context).auth.signOut();
          await AuthService().signOut();
        } catch (e) {
          print(e);
        }
      },
    );
  }
}
