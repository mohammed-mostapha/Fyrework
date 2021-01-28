import 'dart:async';
import 'dart:core';
import 'package:flutter_svg/svg.dart';
import 'package:myApp/models/gig.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:myApp/screens/add_gig/assets_picker/src/constants/constants.dart';
import 'package:myApp/services/firestore_service.dart';
import 'package:myApp/ui/shared/theme.dart';
import 'package:myApp/ui/views/add_comments_view.dart';
import 'package:myApp/ui/widgets/gig_item_media_previewer.dart';
import 'package:myApp/ui/widgets/user_profile.dart';

class GigItem extends StatefulWidget {
  final appointed;
  final appointedUserFullName;
  final gigId;
  final currentUserId;
  final gigOwnerId;
  final gigOwnerEmail;
  final userProfilePictureDownloadUrl;
  final userFullName;
  final userLocation;
  final gigLocation;
  final gigHashtags;
  final gigMediaFilesDownloadUrls;
  final gigPost;
  final gigDeadline;
  final gigCurrency;
  final gigBudget;
  final gigValue;
  final gigLikes;
  final appointedUserId;
  final Gig adultContentText;
  final Gig adultContentBool;
  final Function onDeleteItem;
  GigItem({
    Key key,
    this.appointed,
    this.appointedUserFullName,
    this.gigId,
    this.currentUserId,
    this.gigOwnerId,
    this.gigOwnerEmail,
    this.userProfilePictureDownloadUrl,
    this.userFullName,
    this.userLocation,
    this.gigLocation,
    this.gigHashtags,
    this.gigMediaFilesDownloadUrls,
    this.gigPost,
    this.gigDeadline,
    this.gigCurrency,
    this.gigBudget,
    this.gigValue,
    this.gigLikes,
    this.appointedUserId,
    this.adultContentText,
    this.adultContentBool,
    this.onDeleteItem,
  }) : super(key: key);

  @override
  _GigItemState createState() => _GigItemState();
}

class _GigItemState extends State<GigItem> with TickerProviderStateMixin {
  bool liked = false;
  bool showLikeOverlay = false;
  AnimationController _likeAnimationController;
  final String hourglassStart = 'assets/svgs/hourglass-start.svg';

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
                    passedCurrentUserId: widget.currentUserId,
                    passedGigAppointed: widget.appointed.appointed,
                    passedGigValue: widget.gigValue.gigValue,
                    passedGigCurrency: widget.gigCurrency.gigCurrency,
                    passedGigBudget: widget.gigBudget.gigBudget,
                  )));
    });
  }

  _doubleTappedLike() {
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
                  passedUserFullName: widget.userFullName.userFullName,
                  fromComment: false,
                  fromGig: true,
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
          Container(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 0),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      GestureDetector(
                        onTap: showUserProfile,
                        child: Flexible(
                          child: Container(
                            width: 200,
                            child: Row(
                              children: [
                                CircleAvatar(
                                  maxRadius: 20,
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  backgroundImage: NetworkImage(
                                      "${widget.userProfilePictureDownloadUrl.userProfilePictureDownloadUrl}"),
                                ),
                                Container(
                                  width: 10,
                                  height: 0,
                                ),
                                Flexible(
                                  child: Text(
                                    "${widget.userFullName.userFullName}",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      RaisedButton(
                        color: Theme.of(context).primaryColor,
                        child: Text(
                          widget.gigOwnerId.gigOwnerId == widget.currentUserId
                              ? 'Your gig'
                              : widget.gigValue.gigValue == 'Gigs I can do'
                                  ? 'Hire me'
                                  : 'Apply',
                          style: TextStyle(color: FyreworkrColors.white),
                        ),
                        onPressed:
                            widget.gigOwnerId.gigOwnerId == widget.currentUserId
                                ? () {}
                                : widget.gigValue.gigValue == 'Gigs I can do'
                                    ? () {}
                                    : () {},
                      )
                    ],
                  ),
                  SizedBox(height: 10),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        "${widget.gigHashtags.gigHashtags}",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
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
                  child: Text(
                    "${widget.gigPost.gigPost}",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        SizedBox(
                          width: 16,
                          height: 16,
                          child: SvgPicture.asset(
                            hourglassStart,
                            semanticsLabel: 'hourglass-start',
                            // color: Theme.of(context).primaryColor,
                            // color: Theme.of(context).primaryColor,
                          ),
                        ),
                        Container(
                          width: 5.0,
                          height: 0,
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              // "${widget.gigDeadline.gigDeadline}",
                              widget.gigDeadline.gigDeadline != null
                                  // ? "${widget.gigDeadline.gigDeadline}"
                                  ? DateFormat('yyyy-MM-dd').format(
                                      DateTime.fromMillisecondsSinceEpoch(
                                          widget.gigDeadline.gigDeadline))
                                  : "Book Gig",
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: <Widget>[
                        Container(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              "${widget.gigCurrency.gigCurrency}",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Container(
                          width: 2.5,
                          height: 0,
                        ),
                        Container(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              "${widget.gigBudget.gigBudget}",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                // SizedBox(height: 10.0),
                widget.adultContentBool.adultContentBool
                    ? Container(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          children: [
                            SizedBox(height: 5),
                            Row(
                              children: [
                                FaIcon(
                                  FontAwesomeIcons.asterisk,
                                  size: 8,
                                ),
                                Container(
                                  width: 5.0,
                                ),
                                Expanded(
                                  child: Text(
                                    "${widget.adultContentText.adultContentText}",
                                    style: TextStyle(
                                      fontSize: 8,
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
