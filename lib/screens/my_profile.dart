import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:myApp/locator.dart';
import 'package:myApp/models/myUser.dart';
import 'package:myApp/services/database.dart';
import 'package:myApp/ui/views/sign_up_view.dart';
// import 'package:myApp/ui/widgets/provider_widget.dart';
import 'package:myApp/ui/shared/theme.dart';
import 'package:myApp/services/auth_service.dart';
import 'package:myApp/services/storage_repo.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MyProfileView extends StatefulWidget {
  @override
  _MyProfileViewState createState() => _MyProfileViewState();
}

class _MyProfileViewState extends State<MyProfileView> {
  AuthService _authService = locator.get<AuthService>();
  StorageRepo _storageRepo = locator.get<StorageRepo>();
  AuthFormType authFormType;
  // dynamic userProfilePictureUrl;

  // Future<String> getProfilePictureDownloadUrl() async {
  //   print('fetching profile picture url');
  //   return userProfilePictureUrl = await _storageRepo
  //       .getUserProfilePictureDownloadUrl(await _authService.getCurrentUID());
  // }

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
                // if (snapshot.connectionState == ConnectionState.done) {

                return Column(
                  children: [
                    displayUserMetadata(context, snapshot),
                    Column(
                      children: [
                        displayUserInformation(context),
                      ],
                    ),
                  ],
                );
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
            child: Flexible(
              child: Text(
                MyUser.email,
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
          showSignOut(context)
        ],
      ),
    );
  }

  Widget displayUserInformation(
    context,
  ) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CachedNetworkImage(
            imageBuilder: (context, imageProvider) => Container(
              width: 90.0,
              height: 90.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
              ),
            ),
            imageUrl: MyUser.userAvatarUrl,
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => Icon(Icons.error),
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
                Expanded(
                  child: Text(
                    MyUser.lengthOfOngoingGigsByGigId == null ||
                            MyUser.lengthOfOngoingGigsByGigId < 1
                        ? '0'
                        : MyUser.lengthOfOngoingGigsByGigId,
                    style: TextStyle(fontSize: 18),
                  ),
                ),
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
  }

  Widget showSignOut(context) {
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
