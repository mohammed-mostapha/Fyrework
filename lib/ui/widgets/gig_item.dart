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
  final adultContentText;
  final adultContentBool;
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
  final String heart = 'assets/svgs/light/heart.svg';
  final String heartSolid = 'assets/svgs/solid/heart.svg';
  final String comment = 'assets/svgs/light/comment.svg';
  final String hourglassStart = 'assets/svgs/light/hourglass-start.svg';
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
                    passedGigId: widget.gigId,
                    passedGigOwnerId: widget.gigOwnerId,
                    passedCurrentUserId: widget.currentUserId,
                    passedGigAppointed: widget.appointed,
                    passedGigValue: widget.gigValue,
                    passedGigCurrency: widget.gigCurrency,
                    passedGigBudget: widget.gigBudget,
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
                  passedUserUid: widget.gigOwnerId,
                  passedUserFullName: widget.userFullName,
                  fromComment: false,
                  fromGig: true,
                )));
  }

  @override
  Widget build(BuildContext context) {
    ScaleTransition likeButton = ScaleTransition(
      scale: _likeAnimationController,
      child: GestureDetector(
        child: SizedBox(
          width: 20,
          height: 20,
          child: SvgPicture.asset(
            liked ? heartSolid : heart,
            semanticsLabel: 'Like',
            color: liked ? Colors.red[400] : Theme.of(context).primaryColor,
          ),
        ),
        onTap: () => _likedPressed(),
      ),
    );

    GestureDetector commentButton = GestureDetector(
      child: SizedBox(
        width: 20,
        height: 20,
        child: SvgPicture.asset(
          comment,
          semanticsLabel: 'Comment',
          color: Theme.of(context).primaryColor,
        ),
      ),
      onTap: () => _commentButtonPressed(),
    );

    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Column(
        children: [
          Container(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
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
                                      "${widget.userProfilePictureDownloadUrl}"),
                                ),
                                Container(
                                  width: 10,
                                  height: 0,
                                ),
                                Flexible(
                                  child: Text(
                                    "${widget.userFullName}",
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
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Theme.of(context).primaryColor,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(2))),
                        child: Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              child: Text(
                                widget.gigOwnerId == widget.currentUserId
                                    ? 'Edit Your gig'
                                    : widget.gigValue.gigValue ==
                                            'Gigs I can do'
                                        ? 'Hire me'
                                        : 'Apply',
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor),
                              ),
                              onTap: widget.gigOwnerId == widget.currentUserId
                                  ? () {
                                      print('edit you gig');
                                    }
                                  : widget.gigValue.gigValue == 'Gigs I can do'
                                      ? () {}
                                      : () {},
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    child: Wrap(
                      children: widget.gigHashtags
                          .map<Widget>((e) => Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 0, 2.5, 2.5),
                                child: Chip(
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  backgroundColor: Colors.black,
                                  label: Text(
                                    '$e',
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.white),
                                  ),
                                ),
                              ))
                          .toList(),
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
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 16.0),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    likeButton,
                    SizedBox(
                      width: 15,
                    ),
                    commentButton
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
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
                              widget.gigDeadline != null
                                  // ? "${widget.gigDeadline.gigDeadline}"
                                  ? DateFormat('yyyy-MM-dd').format(
                                      DateTime.fromMillisecondsSinceEpoch(
                                          widget.gigDeadline))
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
                              "${widget.gigCurrency}",
                              style: TextStyle(
                                fontSize: 16,
                              ),
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
                              "${widget.gigBudget}",
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                // SizedBox(height: 10.0),
                widget.adultContentBool
                    ? Container(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          children: [
                            SizedBox(height: 5),
                            Row(
                              children: [
                                FaIcon(
                                  FontAwesomeIcons.asterisk,
                                  size: 10,
                                ),
                                Container(
                                  width: 5.0,
                                ),
                                Expanded(
                                  child: Text(
                                    "${widget.adultContentText}",
                                    style: TextStyle(
                                      fontSize: 10,
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
