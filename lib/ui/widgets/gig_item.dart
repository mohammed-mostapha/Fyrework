import 'dart:async';
import 'dart:core';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:myApp/models/gig.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:myApp/services/firestore_service.dart';
import 'package:myApp/ui/shared/theme.dart';
import 'package:flutter_common_exports/src/extensions/build_context_extension.dart';
import 'package:myApp/ui/views/add_comments_view.dart';
import 'package:myApp/ui/widgets/gig_item_media_previewer.dart';

class GigItem extends StatefulWidget {
  final gigId;
  final userProfilePictureUrl;
  final userFullName;
  final gigHashtags;
  final gigMediaFilesDownloadUrls;
  final gigPost;
  final gigDeadline;
  final gigCurrency;
  final gigBudget;
  final gigValue;
  final gigLikes;
  final Gig adultContentText;
  final Gig adultContentBool;
  final Function onDeleteItem;
  GigItem({
    Key key,
    this.gigId,
    this.userProfilePictureUrl,
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
  _GigItemState createState() => _GigItemState();
}

class _GigItemState extends State<GigItem> with TickerProviderStateMixin {
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
    print('showLikeOverlay $showLikeOverlay');
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
                    Row(
                      children: [
                        CircleAvatar(
                          // backgroundColor: Theme.of(context).primaryColor,
                          backgroundColor: Theme.of(context).primaryColor,
                          backgroundImage: NetworkImage(
                              "${widget.userProfilePictureUrl.userProfilePictureUrl}"),
                        ),
                        Container(
                          width: 10,
                          height: 0,
                        ),
                        AutoSizeText(
                          "${widget.userFullName.userFullName}",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
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
              ],
            ),
          ),
          GestureDetector(
            onDoubleTap: () => _doubleTappedLike(),
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                GigItemMediaPreviewer(
                  receivedGigMediaFilesUrls: widget
                      .gigMediaFilesDownloadUrls.gigMediaFilesDownloadUrls,
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
                    widget.gigLikes.gigLikes != null &&
                            widget.gigLikes.gigLikes != 0 &&
                            widget.gigLikes.gigLikes > 0
                        ? Flexible(
                            child: Text(
                            '${widget.gigLikes.gigLikes}' + ' ' + 'likes',
                            style: TextStyle(
                              fontSize: 18,
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
                          size: 15,
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
