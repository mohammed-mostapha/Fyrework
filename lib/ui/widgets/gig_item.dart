import 'dart:async';
import 'dart:core';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:myApp/screens/add_gig/assets_picker/src/constants/constants.dart';
import 'package:myApp/services/firestore_service.dart';
import 'package:myApp/services/searchUsersScreen.dart';
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
  final gigOwnerAvatarUrl;
  final gigOwnerUsername;
  final gigOwnerLocation;
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
    this.gigOwnerAvatarUrl,
    this.gigOwnerUsername,
    this.gigOwnerLocation,
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
  final String mapMarkerAlt = 'assets/svgs/light/map-marker-alt.svg';
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
                    // passedGigAppointed: widget.appointed,
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
                  // passedUsername: widget.gigOwnerUsername,
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
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      GestureDetector(
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
                                      "${widget.gigOwnerAvatarUrl}"),
                                ),
                                Container(
                                  width: 10,
                                  height: 0,
                                ),
                                Flexible(
                                  child: Text(
                                    "${widget.gigOwnerUsername}".capitalize(),
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        onTap: showUserProfile,
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
                                    : widget.gigValue == 'Gigs I can do'
                                        ? 'Hire me'
                                        : 'Apply',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Theme.of(context).primaryColor),
                              ),
                              onTap: widget.gigOwnerId == widget.currentUserId
                                  ? () {
                                      print('edit you gig');
                                    }
                                  : widget.gigValue == 'Gigs I can do'
                                      ? () {}
                                      : () {},
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  // SizedBox(height: 10),
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Row(
                        children: <Widget>[
                          likeButton,
                          SizedBox(
                            width: 15,
                          ),
                          commentButton
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 2.5,
                      child: Row(
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: SvgPicture.asset(
                              mapMarkerAlt,
                              semanticsLabel: 'Comment',
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          Flexible(
                            child: Text('${widget.gigLocation}',
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.bodyText2),
                          )
                        ],
                      ),
                    )
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
                    "${widget.gigPost}".capitalize(),
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
                SizedBox(height: 5),
                Container(
                  width: double.infinity,
                  child: GestureDetector(
                    child: Wrap(
                      children: widget.gigHashtags
                          .map<Widget>((e) => Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 0, 2.5, 2.5),
                                child: Text(
                                  '$e',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Theme.of(context).primaryColor),
                                ),
                              ))
                          .toList(),
                    ),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => SearchUsersScreen()));
                    },
                  ),
                ),
                SizedBox(height: 10),
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
                                fontSize: 16,
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
                                  size: 12,
                                ),
                                Container(
                                  width: 5.0,
                                ),
                                Expanded(
                                  child: Text(
                                    "${widget.adultContentText}",
                                    style: TextStyle(
                                      fontSize: 12,
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
