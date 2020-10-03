import 'package:auto_size_text/auto_size_text.dart';
import 'package:myApp/models/dialog_models.dart';
import 'package:myApp/models/gig.dart';
import 'package:myApp/vew_controllers/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:myApp/ui/widgets/provider_widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:myApp/vew_controllers/user_controller.dart';
import 'package:myApp/locator.dart';
import 'package:myApp/new_services/auth_service.dart';
import 'package:myApp/new_services/storage_repo.dart';

class GigItem extends StatefulWidget {
  final userProfilePictureUrl;
  final userFullName;
  final gigHashtags;
  final gigPost;
  final gigDeadline;
  final gigCurrency;
  final gigBudget;
  final gigValue;
  final Gig adultContentText;
  final Gig adultContentBool;
  final Function onDeleteItem;
  GigItem({
    Key key,
    this.userProfilePictureUrl,
    this.userFullName,
    this.gigHashtags,
    this.gigPost,
    this.gigDeadline,
    this.gigCurrency,
    this.gigBudget,
    this.gigValue,
    this.adultContentText,
    this.adultContentBool,
    this.onDeleteItem,
  }) : super(key: key);

  @override
  _GigItemState createState() => _GigItemState();
}

class _GigItemState extends State<GigItem> {
  AuthService _authService = locator.get<AuthService>();
  StorageRepo _storageRepo = locator.get<StorageRepo>();

  // Future<String> getProfilePictureDownloadUrl() async {
  //   print('some workkkkkk');
  //   return widget.userProfilePictureUrl = await _storageRepo
  //       .getUserProfilePictureDownloadUrl(await _authService.getCurrentUID());
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 60,
      margin: const EdgeInsets.only(top: 20),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            // FutureBuilder(
            //   future: Provider.of(context).auth.getCurrentUser(),
            //   builder: (context, snapshot) {
            //     if (snapshot.connectionState == ConnectionState.done) {
            //       return displayUserInformation(context, snapshot);
            //     } else {
            //       return Container(
            //           width: MediaQuery.of(context).size.width,
            //           height: MediaQuery.of(context).size.height,
            //           child: Center(child: CircularProgressIndicator()));
            //     }
            //   },
            // ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.end,
            //   children: <Widget>[
            //     IconButton(
            //       icon: Icon(Icons.close),
            //       onPressed: () {
            //         if (onDeleteItem != null) {
            //           onDeleteItem();
            //         }
            //       },
            //     ),
            //   ],
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                //

                // FutureBuilder(
                //   future: Provider.of(context).auth.getCurrentUser(),
                //   builder: (context, snapshot) {
                //     if (snapshot.connectionState == ConnectionState.done) {
                //       return Column(
                //         children: [
                //           // Container(
                //           //   width: 100,
                //           //   height: 100,
                //           //   child: userProfilePictureUrl == null
                //           //       ? CircularProgressIndicator()
                //           //       : NetworkImage(userProfilePictureUrl),
                //           // ),

                //           // displayUserMetadata(context, snapshot),
                //           // Row(
                //           //   mainAxisAlignment: MainAxisAlignment.start,
                //           //   children: <Widget>[
                //           // CircleAvatar(
                //           //   backgroundImage:
                //           //       NetworkImage(widget.userProfilePictureUrl),
                //           // ),
                //           // Container(
                //           //   width: 10,
                //           //   height: 0,
                //           //   child: AutoSizeText("${widget.userFullName}"),
                //           // )
                //           //   ],
                //           // )
                //         ],
                //       );
                //     } else {
                //       return Container(
                //           width: MediaQuery.of(context).size.width,
                //           height: MediaQuery.of(context).size.height,
                //           child: Center(child: CircularProgressIndicator()));
                //     }
                //   },
                // ),

                //
                CircleAvatar(
                  backgroundImage: NetworkImage(
                      "${widget.userProfilePictureUrl.userProfilePictureUrl}"),
                ),
                Container(
                  width: 10,
                  height: 0,
                ),
                AutoSizeText("${widget.userFullName.userFullName}"),
              ],
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: AutoSizeText(
                "${widget.gigHashtags.gigHashtags}",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
            SizedBox(height: 5),
            Container(
              alignment: Alignment.centerLeft,
              child: AutoSizeText(
                "${widget.gigPost.gigPost}",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
            SizedBox(height: 5),
            Container(
              alignment: Alignment.centerLeft,
              child: AutoSizeText(
                "${widget.gigDeadline.gigDeadline}",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
            SizedBox(height: 5),
            Container(
              alignment: Alignment.centerLeft,
              child: AutoSizeText(
                "${widget.gigCurrency.gigCurrency}",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
            SizedBox(height: 5),
            Container(
              alignment: Alignment.centerLeft,
              child: AutoSizeText(
                "${widget.gigBudget.gigBudget}",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
            SizedBox(height: 5),
            Container(
              alignment: Alignment.centerLeft,
              child: AutoSizeText(
                "${widget.gigValue.gigValue}",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
            SizedBox(height: 5),
            Container(
              alignment: Alignment.centerLeft,
              child: AutoSizeText(
                "${widget.adultContentText.adultContentText}",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
            SizedBox(height: 5),
            Container(
              alignment: Alignment.centerLeft,
              child: AutoSizeText(
                "${widget.adultContentBool.adultContentBool}",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
            SizedBox(height: 5),
          ],
        ),
      ),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(blurRadius: 8, color: Colors.grey[200], spreadRadius: 3)
          ]),
    );
  }
}
