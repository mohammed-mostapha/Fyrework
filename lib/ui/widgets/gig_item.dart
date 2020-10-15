import 'dart:core';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:myApp/models/gig.dart';
import 'package:flutter/material.dart';
import 'package:myApp/locator.dart';
import 'package:myApp/services/auth_service.dart';
import 'package:myApp/services/storage_repo.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:myApp/ui/shared/theme.dart';
import 'package:flutter_common_exports/src/extensions/build_context_extension.dart';
import 'package:myApp/ui/widgets/chewie_player.dart';
import 'package:video_player/video_player.dart';

class GigItem extends StatefulWidget {
  final userProfilePictureUrl;
  final userFullName;
  final gigHashtags;
  final gigMediaFilesDownloadUrls;
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
    this.gigMediaFilesDownloadUrls,
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

  bool isDisplayingDetail = true;
  ThemeData get currentTheme => context.themeData;

  List<String> gigMediaFilesDownloadedUrls = List<String>();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                          "${widget.userProfilePictureUrl.userProfilePictureUrl}"),
                    ),
                    Container(
                      width: 10,
                      height: 0,
                    ),
                    AutoSizeText(
                      "${widget.userFullName.userFullName}",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                RaisedButton(
                  child: widget.gigValue.gigValue == 'Gigs I can do'
                      ? AutoSizeText(
                          "Hire me",
                          style: TextStyle(
                            color: FyreworkrColors.white,
                          ),
                        )
                      : AutoSizeText(
                          "Apply",
                          style: TextStyle(
                            color: FyreworkrColors.white,
                          ),
                        ),
                  color: FyreworkrColors.fyreworkBlack,
                  onPressed: () {},
                ),
              ],
            ),
            SizedBox(height: 10),
            Container(
              alignment: Alignment.centerLeft,
              child: AutoSizeText(
                "${widget.gigHashtags.gigHashtags}",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
            SizedBox(height: 10),
            // Container(
            //   child: Image.asset('assets/images/fyrework_logo.png'),
            // ),
            //slider to preview gigMediaFiles
            Container(
              height: 200,
              // child: Text(
              //   widget.gigMediaFilesDownloadUrls.gigMediaFilesDownloadUrls
              //       .toString(),
              // ),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                // Let the ListView know how many items it needs to build.
                itemCount: widget
                    .gigMediaFilesDownloadUrls.gigMediaFilesDownloadUrls.length,
                // Provide a builder function. This is where the magic happens.
                // Convert each item into a widget based on the type of item it is.
                itemBuilder: (context, index) {
                  final itemUrl = widget.gigMediaFilesDownloadUrls
                      .gigMediaFilesDownloadUrls[index];
                  if (itemUrl.contains("imageFile")) {
                    return Container(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.network(itemUrl),
                      ),
                    );
                  } else if (itemUrl.contains("videoFile")) {
                    return Container(
                      child: Expanded(
                        child: ChewiePlayer(
                          videoPlayerController:
                              VideoPlayerController.network(itemUrl),
                          looping: false,
                        ),
                      ),
                    );
                  } else {
                    //
                  }
                },
              ),
            ),

            //end slider to preview gigMediafiles
            SizedBox(height: 10),
            Container(
              alignment: Alignment.centerLeft,
              child: AutoSizeText(
                "${widget.gigPost.gigPost}",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    FaIcon(
                      FontAwesomeIcons.hourglassStart,
                      size: 20,
                    ),
                    Container(
                      width: 5.0,
                      height: 0,
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: AutoSizeText(
                        "${widget.gigDeadline.gigDeadline}",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  children: <Widget>[
                    Container(
                      child: AutoSizeText(
                        "${widget.gigCurrency.gigCurrency}",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      width: 2.5,
                      height: 0,
                    ),
                    Container(
                      child: AutoSizeText(
                        "${widget.gigBudget.gigBudget}",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10.0),
            // Container(
            //   alignment: Alignment.centerLeft,
            //   child: AutoSizeText(
            //     "${widget.gigValue.gigValue}",
            //     style: TextStyle(
            //       fontSize: 18,
            //     ),
            //   ),
            // ),
            widget.adultContentBool.adultContentBool
                ? Container(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      children: [
                        SizedBox(height: 10),
                        Row(
                          children: [
                            FaIcon(
                              FontAwesomeIcons.solidStar,
                              size: 20,
                            ),
                            Container(
                              width: 5.0,
                              height: 0,
                            ),
                            Expanded(
                              child: AutoSizeText(
                                "${widget.adultContentText.adultContentText}",
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                : Container(
                    width: 0,
                    height: 0,
                  ),
            // Container(
            //   alignment: Alignment.centerLeft,
            //   child: AutoSizeText(
            //     "${widget.adultContentBool.adultContentBool}",
            //     style: TextStyle(
            //       fontSize: 18,
            //     ),
            //   ),
            // ),
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
