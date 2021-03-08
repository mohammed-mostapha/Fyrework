import 'dart:async';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:Fyrework/services/firestore_service.dart';
import 'package:flutter_common_exports/src/extensions/build_context_extension.dart';
import 'package:Fyrework/ui/views/add_comments_view.dart';
import 'package:Fyrework/ui/widgets/gig_item_media_previewer.dart';
import 'package:Fyrework/ui/widgets/user_profile.dart';

class UserRelatedGigItem extends StatefulWidget {
  final gigId;
  final gigOwnerId;
  final gigOwnerEmail;
  final userProfilePictureDownloadUrl;
  final userFullName;
  final gigHashtags;
  final gigMediaFilesDownloadUrls;
  final gigPost;
  final gigDeadline;
  final gigCurrency;
  final gigBudget;
  final gigValue;
  final gigLikes;
  final dynamic adultContentText;
  final dynamic adultContentBool;
  final Function onDeleteItem;
  UserRelatedGigItem({
    Key key,
    this.gigId,
    this.gigOwnerId,
    this.gigOwnerEmail,
    this.userProfilePictureDownloadUrl,
    this.userFullName,
    this.gigHashtags,
    this.gigMediaFilesDownloadUrls,
    this.gigPost,
    this.gigDeadline,
    this.gigCurrency,
    this.gigBudget,
    this.gigValue,
    this.gigLikes,
    this.adultContentText,
    this.adultContentBool,
    this.onDeleteItem,
  }) : super(key: key);

  @override
  _UserRelatedGigItemState createState() => _UserRelatedGigItemState();
}

class _UserRelatedGigItemState extends State<UserRelatedGigItem>
    with TickerProviderStateMixin {
  bool isDisplayingDetail = true;
  ThemeData get currentTheme => context.themeData;

  bool liked = false;
  bool showLikeOverlay = false;
  AnimationController _likeAnimationController;

  List<String> gigMediaFilesDownloadedUrls = List<String>();

  void initState() {
    super.initState();

    _likeAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 125),
      value: 1.0,
      lowerBound: 1.0,
      upperBound: 1.25,
    );
  }

  _likedPressed() {
    setState(() {
      liked = !liked;
      _likeAnimationController.forward().then((value) {
        _likeAnimationController.reverse();
      });
    });
    FirestoreService().updateGigAddRemoveLike(widget.gigId.gigId, liked);
  }

  _commentButtonPressed() {
    setState(() {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AddCommentsView(
                    passedGigId: widget.gigId.gigId,
                    passedGigOwnerId: widget.gigOwnerId.gigOwnerId,
                  )));
    });
  }

  _doubleTappedLike() {
    print('showLikeOverlay $showLikeOverlay');
    if (liked == false && showLikeOverlay == false) {
      setState(() {
        liked = true;
        showLikeOverlay = true;
        _likeAnimationController.forward().then((value) {
          _likeAnimationController.reverse();
        });
        if (showLikeOverlay) {
          Timer(const Duration(milliseconds: 500), () {
            setState(() {
              showLikeOverlay = false;
            });
          });
        }

        FirestoreService().updateGigAddRemoveLike(widget.gigId.gigId, liked);
      });
    }
    showLikeOverlay = true;
    _likeAnimationController.forward().then((value) {
      _likeAnimationController.reverse();
      showLikeOverlay = false;
    });
  }

  showUserProfile() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => UserProfileView(
                  passedUserUid: widget.gigOwnerId.gigOwnerId,
                  // passedUserFullName: widget.userFullName.userFullName,
                )));
  }

  @override
  Widget build(BuildContext context) {
    ScaleTransition likeButton = ScaleTransition(
      scale: _likeAnimationController,
      child: IconButton(
          icon: Icon(
            liked ? Icons.favorite : Icons.favorite_border,
            color: liked ? Colors.red[400] : Colors.grey,
            size: 30,
          ),
          onPressed: () => _likedPressed()),
    );

    IconButton commentButton = IconButton(
      // icon: Icon(
      //   Icons.chat_bubble_outline,
      //   color: Colors.grey,
      //   size: 30,
      // ),
      icon: FaIcon(
        FontAwesomeIcons.comment,
        size: 27,
        color: Colors.grey,
      ),
      onPressed: () => _commentButtonPressed(),
    );

    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    GestureDetector(
                      onTap: showUserProfile,
                      child: Row(
                        children: [
                          CircleAvatar(
                            // backgroundColor: Theme.of(context).primaryColor,
                            backgroundColor: Theme.of(context).primaryColor,
                            backgroundImage: NetworkImage(
                                "${widget.userProfilePictureDownloadUrl}"),
                          ),
                          Container(
                            width: 10,
                            height: 0,
                          ),
                          Text(
                            "${widget.userFullName}",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // RaisedButton(
                    //   child: widget.gigValue == 'Gigs I can do'
                    //       ? AutoSizeText(
                    //           "Hire me",
                    //           style: TextStyle(
                    //             color: FyreworkrColors.white,
                    //           ),
                    //         )
                    //       : AutoSizeText(
                    //           "Apply",
                    //           style: TextStyle(
                    //             color: FyreworkrColors.white,
                    //           ),
                    //         ),
                    //   color: FyreworkrColors.fyreworkBlack,
                    //   onPressed: () {},
                    // ),
                  ],
                ),
                SizedBox(height: 10),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "${widget.gigHashtags}",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
          GestureDetector(
            onDoubleTap: () => _doubleTappedLike(),
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                GigItemMediaPreviewer(
                  receivedGigMediaFilesUrls: widget.gigMediaFilesDownloadUrls,
                ),
                showLikeOverlay
                    ? Icon(
                        Icons.favorite,
                        size: 120.0,
                        color: Colors.white,
                      )
                    : Container()
              ],
            ),
          ),
          Row(
            children: <Widget>[likeButton, commentButton],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    widget.gigLikes != null &&
                            widget.gigLikes != 0 &&
                            widget.gigLikes > 0
                        ? Flexible(
                            child: Text(
                            '${widget.gigLikes}' + ' ' + 'likes',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ))
                        : Container(
                            width: 0,
                            height: 0,
                          ),
                  ],
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "${widget.gigPost}",
                    style: TextStyle(
                      fontSize: 16,
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
                          size: 15,
                        ),
                        Container(
                          width: 5.0,
                          height: 0,
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "${widget.gigDeadline}",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: <Widget>[
                        Container(
                          child: Text(
                            "${widget.gigCurrency}",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Container(
                          width: 2.5,
                          height: 0,
                        ),
                        Container(
                          child: Text(
                            "${widget.gigBudget}",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 10.0),
                widget.adultContentBool
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
                                  child: Text(
                                    "${widget.adultContentText}",
                                    style: TextStyle(
                                      fontSize: 16,
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
                SizedBox(height: 5),
              ],
            ),
          ),
        ],
      ),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(blurRadius: 8, color: Colors.grey[200], spreadRadius: 3)
          ]),
    );
  }

  @override
  void dispose() {
    _likeAnimationController.dispose();
    super.dispose();
  }
}
