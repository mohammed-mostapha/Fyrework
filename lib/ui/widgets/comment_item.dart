import 'dart:async';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:myApp/services/firestore_service.dart';
import 'package:myApp/ui/shared/theme.dart';
import 'package:myApp/ui/widgets/user_profile.dart';
import 'package:timeago/timeago.dart' as timeAgo;
import 'package:expandable_text/expandable_text.dart';

class CommentItem extends StatefulWidget {
  final passedCurrentUserId;
  final gigIdHoldingComment;
  final gigOwnerId;
  final commentId;
  final commentOwnerId;
  final commentOwnerProfilePictureUrl;
  final commentOwnerUsername;
  final commentBody;
  final gigCurrency;
  final commentTime;
  final privateComment;
  final proposal;
  final approved;
  final rejected;
  final offeredBudget;
  final Function onDeleteItem;
  CommentItem({
    Key key,
    this.passedCurrentUserId,
    this.gigIdHoldingComment,
    this.gigOwnerId,
    this.commentId,
    this.commentOwnerId,
    this.commentOwnerProfilePictureUrl,
    this.commentOwnerUsername,
    this.commentBody,
    this.gigCurrency,
    this.commentTime,
    this.privateComment,
    this.proposal,
    this.approved,
    this.rejected,
    this.offeredBudget,
    this.onDeleteItem,
  }) : super(key: key);

  @override
  _CommentItemState createState() => _CommentItemState();
}

class _CommentItemState extends State<CommentItem> {
  Timer _timer;
  int _commentViewIndex = 0;
  double _commentOpacity = 0.9;

  void initState() {
    super.initState();
  }

  void commentViewShifter() {
    if (!widget.privateComment) {
      print('condition 1');
      setState(() {
        _commentOpacity = 0;
      });
      _timer = new Timer(Duration(milliseconds: 1000), () {
        setState(() {
          _commentOpacity = 0.9;
          _commentViewIndex = 1;
        });
      });
      _timer = new Timer(Duration(milliseconds: 2000), () {
        setState(() {
          _commentOpacity = 0;
        });
      });

      _timer = new Timer(Duration(milliseconds: 3000), () {
        setState(() {
          _commentOpacity = 0.9;
          _commentViewIndex = 0;
        });
      });
    } else {
      print('condition 2');
      setState(() {
        _commentViewIndex = 0;
      });
    }
  }

  showUserProfile() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => UserProfileView(
                  passedUserUid: widget.commentOwnerId,
                  // passedUserFullName: widget.commentOwnerUsername,
                  fromComment: true,
                  fromGig: false,
                )));
  }

  @override
  Widget build(BuildContext context) {
    // public comment view
    Widget publicCommentView = Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  child: Container(
                    width: 200,
                    child: Row(
                      children: [
                        CircleAvatar(
                          maxRadius: 20,
                          backgroundColor: Theme.of(context).primaryColor,
                          backgroundImage: NetworkImage(
                              "${widget.commentOwnerProfilePictureUrl}"),
                        ),
                        Container(
                          width: 10,
                          height: 0,
                        ),
                        Flexible(
                          child: Text(
                            '${widget.commentOwnerUsername}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              color: widget.commentOwnerId ==
                                      widget.passedCurrentUserId
                                  ? Colors.white
                                  : FyreworkrColors.fyreworkBlack,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  onTap: showUserProfile,
                ),
                Container(
                  child: (widget.gigOwnerId == widget.passedCurrentUserId &&
                          widget.gigOwnerId != widget.commentOwnerId &&
                          widget.proposal &&
                          !widget.approved &&
                          widget.rejected)
                      ? RejectedLabel()
                      : (widget.gigOwnerId == widget.passedCurrentUserId &&
                              widget.gigOwnerId != widget.commentOwnerId &&
                              widget.proposal &&
                              widget.approved &&
                              !widget.rejected)
                          ? ApprovedLabel()
                          : (widget.commentOwnerId ==
                                      widget.passedCurrentUserId &&
                                  !widget.proposal)
                              ? Switch(
                                  activeColor: Colors.blue,
                                  inactiveThumbColor: Colors.grey[200],
                                  inactiveTrackColor: Colors.grey[200],
                                  activeTrackColor: Colors.grey[200],
                                  value: widget.privateComment,
                                  onChanged: (value) {
                                    FirestoreService().commentPrivacyToggle(
                                        widget.commentId, value);
                                    commentViewShifter();
                                  },
                                )
                              : Container(
                                  width: 0,
                                  height: 0,
                                ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: ExpandableText(
                    '${widget.commentBody}',
                    expandText: ' more',
                    collapseText: ' less',
                    maxLines: 3,
                    linkColor:
                        widget.commentOwnerId == widget.passedCurrentUserId
                            ? Colors.white
                            : FyreworkrColors.fyreworkBlack,
                    style: TextStyle(
                      fontSize: 18,
                      color: widget.commentOwnerId == widget.passedCurrentUserId
                          ? Colors.white
                          : Colors.grey[700],
                    ),
                  ),
                ),
                Container(height: 5),
                (widget.gigOwnerId == widget.passedCurrentUserId &&
                        widget.commentOwnerId != widget.passedCurrentUserId &&
                        widget.proposal &&
                        !widget.approved &&
                        !widget.rejected)
                    ? Column(
                        children: [
                          Container(
                            color: Colors.white,
                            child: Row(
                              children: <Widget>[
                                Text('${widget.gigCurrency}'),
                                Container(
                                  width: 5,
                                ),
                                Text('${widget.offeredBudget}'),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              RaisedButton(
                                  color: widget.commentOwnerId ==
                                          widget.passedCurrentUserId
                                      ? Colors.white
                                      : FyreworkrColors.fyreworkBlack,
                                  child: Expanded(
                                    child: Text(
                                      'Approve',
                                      style: TextStyle(
                                        color: widget.commentOwnerId ==
                                                widget.passedCurrentUserId
                                            ? FyreworkrColors.fyreworkBlack
                                            : Colors.white,
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                    FirestoreService().appointedGigToUser(
                                        widget.gigIdHoldingComment,
                                        widget.commentOwnerId,
                                        widget.commentId);
                                  }),
                              SizedBox(
                                width: 10,
                              ),
                              RaisedButton(
                                  color: widget.commentOwnerId ==
                                          widget.passedCurrentUserId
                                      ? Colors.white
                                      : FyreworkrColors.fyreworkBlack,
                                  child: Expanded(
                                    child: Text(
                                      'Reject',
                                      style: TextStyle(
                                        color: widget.commentOwnerId ==
                                                widget.passedCurrentUserId
                                            ? FyreworkrColors.fyreworkBlack
                                            : Colors.white,
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                    FirestoreService()
                                        .rejectProposal(widget.commentId);
                                  }),
                            ],
                          )
                        ],
                      )
                    : (widget.gigOwnerId == widget.passedCurrentUserId &&
                            widget.commentOwnerId !=
                                widget.passedCurrentUserId &&
                            widget.proposal &&
                            widget.rejected)
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: Wrap(
                                  direction: Axis.horizontal,
                                  alignment: WrapAlignment.start,
                                  children: [
                                    Text('You rejected '),
                                    GestureDetector(
                                      child: Text(
                                        '${widget.commentOwnerUsername}\'s proposal',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      onTap: () {
                                        showUserProfile();
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: 5,
                              ),
                            ],
                          )
                        : (widget.gigOwnerId == widget.passedCurrentUserId &&
                                widget.commentOwnerId !=
                                    widget.passedCurrentUserId &&
                                widget.proposal &&
                                widget.approved)
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: Wrap(
                                      direction: Axis.horizontal,
                                      alignment: WrapAlignment.start,
                                      children: [
                                        Text('You appointed this gig to '),
                                        GestureDetector(
                                          child: Text(
                                            '${widget.commentOwnerUsername}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w900),
                                          ),
                                          onTap: () {
                                            showUserProfile();
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: 5,
                                  ),
                                ],
                              )
                            : (widget.commentOwnerId ==
                                        widget.passedCurrentUserId &&
                                    widget.proposal)
                                ? Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            // color: !widget.approved
                                            //     ? !widget.rejected
                                            //         ? Colors.white
                                            //         : Colors.red
                                            //     : Colors.green,
                                            border: Border.all(
                                              width: 2,
                                              color: !widget.approved
                                                  ? !widget.rejected
                                                      ? Colors.white
                                                      : Colors.red
                                                  : Colors.green,
                                            ),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(2))),
                                        child: Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              !widget.approved
                                                  ? !widget.rejected
                                                      ? 'Pending approval'
                                                      : 'Rejected'
                                                  : 'Approved',
                                              style: TextStyle(
                                                color: !widget.approved
                                                    ? !widget.rejected
                                                        ? Colors.white
                                                        : Colors.red
                                                    : Colors.green,
                                                //  !widget.approved
                                                //     ? Colors.black
                                                //     : Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 10,
                                      ),
                                    ],
                                  )
                                : Container(
                                    width: 0,
                                    height: 0,
                                  ),
                Text(
                  timeAgo.format(widget.commentTime.toDate()),
                  style: TextStyle(
                    fontSize: 12,
                    color: widget.commentOwnerId == widget.passedCurrentUserId
                        ? Colors.white
                        : FyreworkrColors.fyreworkBlack,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );

    // private comment view
    Widget privateCommentView = Container(
      width: double.infinity,
      height: 70,
      child: Center(
        child: Text('Private comment',
            style: TextStyle(
              color: widget.commentOwnerId == widget.passedCurrentUserId
                  ? Colors.white
                  : FyreworkrColors.fyreworkBlack,
            )),
      ),
    );

    // Widget commentViewShifter =
    //     widget.privateComment ? privateCommentView : publicCommentView;

    timeAgo.setLocaleMessages('de', timeAgo.DeMessages());
    timeAgo.setLocaleMessages('dv', timeAgo.DvMessages());
    timeAgo.setLocaleMessages('dv_short', timeAgo.DvShortMessages());
    timeAgo.setLocaleMessages('fr', timeAgo.FrMessages());
    timeAgo.setLocaleMessages('fr_short', timeAgo.FrShortMessages());
    timeAgo.setLocaleMessages('gr', timeAgo.GrMessages());
    timeAgo.setLocaleMessages('gr_short', timeAgo.GrShortMessages());
    timeAgo.setLocaleMessages('ca', timeAgo.CaMessages());
    timeAgo.setLocaleMessages('ca_short', timeAgo.CaShortMessages());
    timeAgo.setLocaleMessages('cs', timeAgo.CsMessages());
    timeAgo.setLocaleMessages('cs_short', timeAgo.CsShortMessages());
    timeAgo.setLocaleMessages('ja', timeAgo.JaMessages());
    timeAgo.setLocaleMessages('km', timeAgo.KmMessages());
    timeAgo.setLocaleMessages('km_short', timeAgo.KmShortMessages());
    timeAgo.setLocaleMessages('ko', timeAgo.KoMessages());
    timeAgo.setLocaleMessages('id', timeAgo.IdMessages());
    timeAgo.setLocaleMessages('pt_BR', timeAgo.PtBrMessages());
    timeAgo.setLocaleMessages('pt_BR_short', timeAgo.PtBrShortMessages());
    timeAgo.setLocaleMessages('zh_CN', timeAgo.ZhCnMessages());
    timeAgo.setLocaleMessages('zh', timeAgo.ZhMessages());
    timeAgo.setLocaleMessages('it', timeAgo.ItMessages());
    timeAgo.setLocaleMessages('it_short', timeAgo.ItShortMessages());
    timeAgo.setLocaleMessages('fa', timeAgo.FaMessages());
    timeAgo.setLocaleMessages('ru', timeAgo.RuMessages());
    timeAgo.setLocaleMessages('tr', timeAgo.TrMessages());
    timeAgo.setLocaleMessages('pl', timeAgo.PlMessages());
    timeAgo.setLocaleMessages('th', timeAgo.ThMessages());
    timeAgo.setLocaleMessages('th_short', timeAgo.ThShortMessages());
    timeAgo.setLocaleMessages('nb_NO', timeAgo.NbNoMessages());
    timeAgo.setLocaleMessages('nb_NO_short', timeAgo.NbNoShortMessages());
    timeAgo.setLocaleMessages('nn_NO', timeAgo.NnNoMessages());
    timeAgo.setLocaleMessages('nn_NO_short', timeAgo.NnNoShortMessages());
    timeAgo.setLocaleMessages('ku', timeAgo.KuMessages());
    timeAgo.setLocaleMessages('ku_short', timeAgo.KuShortMessages());
    timeAgo.setLocaleMessages('ar', timeAgo.ArMessages());
    timeAgo.setLocaleMessages('ar_short', timeAgo.ArShortMessages());
    timeAgo.setLocaleMessages('ko', timeAgo.KoMessages());
    timeAgo.setLocaleMessages('vi', timeAgo.ViMessages());
    timeAgo.setLocaleMessages('vi_short', timeAgo.ViShortMessages());
    timeAgo.setLocaleMessages('tr', timeAgo.TrMessages());
    timeAgo.setLocaleMessages('ta', timeAgo.TaMessages());
    timeAgo.setLocaleMessages('ro', timeAgo.RoMessages());
    timeAgo.setLocaleMessages('ro_short', timeAgo.RoShortMessages());
    timeAgo.setLocaleMessages('sv', timeAgo.SvMessages());
    timeAgo.setLocaleMessages('sv_short', timeAgo.SvShortMessages());

    var locale = 'en';
    return Container(
        decoration: BoxDecoration(
          color: widget.commentOwnerId == widget.passedCurrentUserId
              // ? FyreworkrColors.fyreworkBlack
              ? Theme.of(context).primaryColor
              : Colors.white,
          border: Border(
            top: widget.commentOwnerId == widget.passedCurrentUserId
                ? BorderSide(width: 0.3, color: Colors.grey[50])
                : BorderSide(width: 0.3, color: FyreworkrColors.fyreworkBlack),
            bottom: widget.commentOwnerId == widget.passedCurrentUserId
                ? BorderSide(width: 0.3, color: Colors.green)
                : BorderSide(width: 0.3, color: FyreworkrColors.fyreworkBlack),
          ),
        ),
        child: (widget.gigOwnerId == widget.passedCurrentUserId)
            ? IndexedStack(
                index: _commentViewIndex,
                children: [
                  AnimatedOpacity(
                    opacity: _commentOpacity,
                    child: publicCommentView,
                    duration: Duration(milliseconds: 500),
                  ),
                  AnimatedOpacity(
                      opacity: _commentOpacity,
                      child: privateCommentView,
                      duration: Duration(milliseconds: 500)),
                ],
              )
            : widget.commentOwnerId == widget.passedCurrentUserId
                ?
                // AnimatedSwitcher(
                //     duration: Duration(seconds: 1), child: commentViewShift)
                IndexedStack(
                    index: _commentViewIndex,
                    children: [
                      AnimatedOpacity(
                        opacity: _commentOpacity,
                        child: publicCommentView,
                        duration: Duration(milliseconds: 500),
                      ),
                      AnimatedOpacity(
                          opacity: _commentOpacity,
                          child: privateCommentView,
                          duration: Duration(milliseconds: 500)),
                    ],
                  )
                : widget.privateComment
                    ? privateCommentView
                    : publicCommentView);
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}

class ApprovedLabel extends StatelessWidget {
  const ApprovedLabel({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: Colors.green,
          ),
          borderRadius: BorderRadius.all(Radius.circular(2))),
      child: Expanded(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Approved',
            style: TextStyle(color: Colors.green),
          ),
        ),
      ),
    );
  }
}

class RejectedLabel extends StatelessWidget {
  const RejectedLabel({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: Colors.red,
          ),
          borderRadius: BorderRadius.all(Radius.circular(2))),
      child: Expanded(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Rejected',
            style: TextStyle(color: Colors.red),
          ),
        ),
      ),
    );
  }
}
