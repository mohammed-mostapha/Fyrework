import 'dart:io';

import 'package:Fyrework/screens/add_gig/assets_picker/src/constants/constants.dart';
import 'package:Fyrework/services/database.dart';
import 'package:Fyrework/ui/shared/fyreworkLightTheme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:Fyrework/models/myUser.dart';
import 'package:Fyrework/ui/shared/constants.dart';
import 'package:Fyrework/ui/views/comments_view.dart';
import 'package:Fyrework/viewmodels/add_comment_view_model.dart';
import 'package:custom_switch/custom_switch.dart';
import 'package:Fyrework/ui/widgets/client_actions.dart';
import 'package:Fyrework/ui/widgets/worker_actions.dart';
import 'package:Fyrework/ui/widgets/workstream_files.dart';
import 'package:Fyrework/ui/widgets/proposal_widget.dart';
import 'package:dartx/dartx.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

class AddCommentsView extends StatefulWidget {
  final String passedGigId;
  final String passedGigOwnerId;
  final String passedCurrentUserId;
  final String passedGigCurrency;
  final String passedGigValue;
  final String passedGigBudget;

  AddCommentsView({
    Key key,
    @required this.passedGigId,
    @required this.passedGigOwnerId,
    @required this.passedCurrentUserId,
    @required this.passedGigValue,
    @required this.passedGigCurrency,
    // @required this.passedGigCurrency,
    @required this.passedGigBudget,
  }) : super(key: key);
  @override
  _AddCommentsViewState createState() => _AddCommentsViewState();
}

class _AddCommentsViewState extends State<AddCommentsView>
    // with WidgetsBindingObserver {
    with
        SingleTickerProviderStateMixin {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  AnimationController animationController;
  Animation<double> animation;
  bool _filePickerOpened = false;
  double _animatedContainerHeight = 0;

  AnimationController _pickFilecontroller;

  void initState() {
    super.initState();
    // WidgetsBinding.instance.addObserver(this);
    _pickFilecontroller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
  }

  // @override
  // void didChangeMetrics() {
  //   print('device rotated');
  // }

  double screenWidth = 0.0;
  double screenHeight = 0.0;
  bool isPortrait = true;
  final _proposalFormKey = GlobalKey<FormState>();
  TextEditingController _addCommentsController = TextEditingController();
  TextEditingController _addProposalController = TextEditingController();
  TextEditingController _offeredBudgetController = TextEditingController();

  bool myGig = false;
  bool appointed = false;
  bool appointedUser = false;
  String appointedUserId = '';
  List appliersOrHirersByUserId = [];
  bool worker = false;
  bool client = false;
  bool gigICanDo = false;
  // bool _keyboardVisible;
  String gigCurrency;
  String gigBudget;

  final String paperClip = 'assets/svgs/solid/paperclip.svg';
  final String paperPlane = 'assets/svgs/solid/paper-plane.svg';
  final String checkCircle = 'assets/svgs/regular/check-circle.svg';
  final String downArrow = 'assets/svgs/flaticon/down-arrow.svg';
  final String actions = 'assets/svgs/flaticon/actions.svg';

  bool isPrivateComment = false;
  bool proposal = false;
  bool approved = false;
  bool rejected = false;
  String offeredBudget;
  String userId = MyUser.uid;
  String username = MyUser.username;
  dynamic userProfilePictureUrl = MyUser.userAvatarUrl;

  addComment() {
    if (_addCommentsController.text.isNotEmpty) {
      AddCommentViewModel().addComment(
        gigIdHoldingComment: widget.passedGigId,
        gigOwnerId: widget.passedGigOwnerId,
        commentOwnerUsername: username,
        commentBody: _addCommentsController.text,
        commentOwnerId: userId,
        commentOwnerAvatarUrl: userProfilePictureUrl,
        commentId: '',
        isPrivateComment: isPrivateComment,
        proposal: proposal,
        approved: approved,
        rejected: rejected,
        gigCurrency: widget.passedGigCurrency,
        offeredBudget: offeredBudget,
      );
      _addCommentsController.clear();
      _addProposalController.clear();
      _offeredBudgetController.clear();
    } else {
      //
    }
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    isPortrait = MediaQuery.of(context).orientation == Orientation.portrait
        ? true
        : false;

    myGig = widget.passedGigOwnerId == MyUser.uid ? true : false;
    gigICanDo = widget.passedGigValue == 'Gig I can do' ? true : false;
    worker = (!myGig && !gigICanDo || myGig && gigICanDo) ? true : false;
    client = (myGig && !gigICanDo || !myGig && gigICanDo) ? true : false;
    // _keyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0;

    // hirer = (myGig && !gigICanDo || !myGig && gigICanDo) ? true : false;

//first check if this gig is appointed or not
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('gigs')
            .doc(widget.passedGigId)
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).primaryColor),
                ),
              ),
            );
          }

          if (!snapshot.data.exists) {
            Future.delayed(Duration(milliseconds: 2000)).then((_) {
              Navigator.pop(context);
            });
            return Container(
              color: Theme.of(context).primaryColor,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  Text(
                    'Gig no longer exists',
                    style: Theme.of(context).textTheme.bodyText1,
                  )
                ],
              ),
            );
          } else {
            appointed = snapshot.data['appointed'];
            appointedUserId = snapshot.data['appointedUserId'];
            appliersOrHirersByUserId =
                snapshot.data['appliersOrHirersByUserId'];
            gigCurrency = snapshot.data['gigCurrency'];
            gigBudget = snapshot.data['gigBudget'];
            appointedUser = appointedUserId == MyUser.uid ? true : false;

            return Scaffold(
              key: _scaffoldKey,
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(60),
                child: new AppBar(
                  automaticallyImplyLeading: false,
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: [
                          ModalRoute.of(context)?.canPop == true
                              ? GestureDetector(
                                  child: Icon(
                                    Icons.arrow_back,
                                    size: 20,
                                    color: Theme.of(context).hintColor,
                                  ),
                                  onTap: () => Navigator.of(context).pop(),
                                )
                              : null,
                          SizedBox(
                            width: 10,
                          ),
                          !appointed
                              ? Text('Comments',
                                  style: Theme.of(context).textTheme.bodyText1)
                              : Container(
                                  width: 130,
                                  child: StreamBuilder(
                                    stream: DatabaseService()
                                        .showGigWorkstreamActions(
                                      gigId: widget.passedGigId,
                                    ),
                                    builder: (context, snapshot) {
                                      if (!snapshot.hasData ||
                                          !(snapshot.data.docs.length > 0)) {
                                        List<PopupMenuItem> actionItems = [];
                                        actionItems.add(
                                          PopupMenuItem<String>(
                                            child: Center(
                                              child: Text(
                                                'Workstream has no history',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1,
                                              ),
                                            ),
                                          ),
                                        );
                                        return PopupMenuButton(
                                          icon: Text(
                                            'Workstream',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1,
                                          ),
                                          color: Theme.of(context).primaryColor,
                                          itemBuilder: (BuildContext context) {
                                            return actionItems;
                                          },
                                        );
                                      }
                                      List<PopupMenuItem> actionItems = [];

                                      for (int i = 0;
                                          i < snapshot.data.docs.length;
                                          i++) {
                                        DocumentSnapshot actionSnapshot =
                                            snapshot.data.docs[i];
                                        String gigWorkstreamActionDate;

                                        if (actionSnapshot
                                                .data()['createdAt'] !=
                                            null) {
                                          gigWorkstreamActionDate =
                                              DateFormat('d MMM, yyyy h:mm a')
                                                  .format(actionSnapshot
                                                      .data()['createdAt']
                                                      .toDate());
                                        }

                                        actionItems.add(
                                          PopupMenuItem(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                    .accentColor,
                                                border: Border(
                                                  bottom: BorderSide(
                                                    color: Theme.of(context)
                                                        .textTheme
                                                        .caption
                                                        .color,
                                                    width: 0.5,
                                                  ),
                                                ),
                                              ),
                                              child: ListTile(
                                                leading: CircleAvatar(
                                                  maxRadius: 20,
                                                  backgroundColor:
                                                      Theme.of(context)
                                                          .primaryColor,
                                                  backgroundImage: NetworkImage(
                                                      "${actionSnapshot.data()['userAvatarUrl']}"),
                                                ),
                                                title: Column(
                                                  children: [
                                                    Text(
                                                        "${actionSnapshot.data()['gigAction']}"
                                                            .capitalize(),
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyText1),
                                                    Text(
                                                      "$gigWorkstreamActionDate",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyText1
                                                          .copyWith(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor,
                                                          ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                      return Theme(
                                        data: Theme.of(context).copyWith(
                                            cardColor:
                                                Theme.of(context).accentColor),
                                        child: PopupMenuButton(
                                          icon: Row(
                                            children: [
                                              Text('Workstream',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              SizedBox(
                                                width: 12,
                                                height: 12,
                                                child: SvgPicture.asset(
                                                  downArrow,
                                                  semanticsLabel: 'down-arrow',
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                          // color: Theme.of(context).primaryColor,
                                          itemBuilder: (BuildContext context) {
                                            return actionItems;
                                          },
                                        ),
                                      );
                                    },
                                  ),
                                ),
                        ],
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            SizedBox(
                              width: 10,
                            ),
                            Text('$gigCurrency $gigBudget',
                                style: Theme.of(context).textTheme.bodyText1),
                            SizedBox(
                              width: 10,
                            ),
                            !appointed
                                ? Builder(
                                    builder: (BuildContext context) {
                                      return GestureDetector(
                                        onTap: myGig
                                            ? () {}
                                            : !appointed
                                                ? !appliersOrHirersByUserId
                                                        .contains(MyUser.uid)
                                                    ? () {
                                                        showModalBottomSheet(
                                                            isScrollControlled:
                                                                true,
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return Builder(builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return Container(
                                                                  height: isPortrait
                                                                      ? screenHeight -
                                                                          200
                                                                      : screenHeight,
                                                                  child:
                                                                      Scaffold(
                                                                    backgroundColor:
                                                                        Color(
                                                                            0xFF737373),
                                                                    body:
                                                                        Container(
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: Theme.of(context)
                                                                            .primaryColor,
                                                                        border: Border.all(
                                                                            width:
                                                                                1,
                                                                            color:
                                                                                Theme.of(context).primaryColor),
                                                                        borderRadius:
                                                                            BorderRadius.only(
                                                                          topLeft:
                                                                              const Radius.circular(10),
                                                                          topRight:
                                                                              const Radius.circular(10),
                                                                        ),
                                                                      ),
                                                                      child:
                                                                          Padding(
                                                                        padding: const EdgeInsets.symmetric(
                                                                            vertical:
                                                                                20,
                                                                            horizontal:
                                                                                10),
                                                                        child:
                                                                            ProposalWidget(
                                                                          passedGigId:
                                                                              widget.passedGigId,
                                                                          passedGigOwnerId:
                                                                              widget.passedGigOwnerId,
                                                                          passedGigCurrency:
                                                                              gigCurrency,
                                                                          passedGigValue:
                                                                              widget.passedGigValue,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                );
                                                              });
                                                            });
                                                      }
                                                    : () {}
                                                : () {},
                                        child: Container(
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                width: 1,
                                                color: Colors.white,
                                              ),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(2))),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                                myGig
                                                    ? 'Your gig'
                                                    : !appliersOrHirersByUserId
                                                            .contains(
                                                                MyUser.uid)
                                                        ? widget.passedGigValue ==
                                                                'Gig I can do'
                                                            ? 'Hire'
                                                            : 'Apply'
                                                        : 'Request sent',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1),
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                : appointedUserId == MyUser.uid
                                    ? SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: SvgPicture.asset(
                                          checkCircle,
                                          semanticsLabel: 'check-circle',
                                          color: Colors.green,
                                        ),
                                      )
                                    : Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              width: 1,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(2))),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            'Appointed',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1,
                                          ),
                                        ),
                                      ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  bottom: PreferredSize(
                      child: Container(
                        color: Theme.of(context).primaryColor,
                        height: 0.5,
                      ),
                      preferredSize: Size.fromHeight(4.0)),
                ),
              ),
              body: Builder(builder: (BuildContext context) {
                return Container(
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: CommentsView(
                          isGigAppointed: appointed,
                          gigIdCommentsIdentifier: widget.passedGigId,
                          gigOwnerId: widget.passedGigOwnerId,
                        ),
                      ),
                      !appointed
                          ? Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Expanded(
                                    child: Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 15),
                                      // height: 40,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor,
                                        border: Border.all(
                                            width: 1,
                                            color:
                                                Theme.of(context).primaryColor),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Expanded(
                                            child: TextFormField(
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColor),
                                              controller:
                                                  _addCommentsController,
                                              decoration: InputDecoration(
                                                hintText: "Add comment",
                                                hintStyle: TextStyle(
                                                    color: Theme.of(context)
                                                        .primaryColor),
                                                border: InputBorder.none,
                                              ),
                                              onFieldSubmitted: (String
                                                  submittedString) async {
                                                if (submittedString
                                                    .isNotEmpty) {
                                                  await AddCommentViewModel()
                                                      .addComment(
                                                    gigIdHoldingComment:
                                                        widget.passedGigId,
                                                    gigOwnerId:
                                                        widget.passedGigOwnerId,
                                                    commentOwnerUsername:
                                                        username,
                                                    commentBody:
                                                        submittedString,
                                                    commentOwnerId: userId,
                                                    commentOwnerAvatarUrl:
                                                        userProfilePictureUrl,
                                                    commentId: '',
                                                    isPrivateComment:
                                                        isPrivateComment,
                                                    proposal: proposal,
                                                    approved: approved,
                                                    rejected: rejected,
                                                    gigCurrency: widget
                                                        .passedGigCurrency,
                                                    offeredBudget:
                                                        offeredBudget,
                                                  );
                                                }

                                                _addCommentsController.clear();
                                                _addProposalController.clear();
                                                _offeredBudgetController
                                                    .clear();
                                              },
                                              minLines: 1,
                                              maxLines: 6,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsets.only(bottom: 10),
                                            child: CustomSwitch(
                                              activeColor: Theme.of(context)
                                                  .primaryColor,
                                              value: isPrivateComment,
                                              onChanged: (value) {
                                                setState(() {
                                                  isPrivateComment = value;
                                                });
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      addComment();
                                    },
                                    child: Container(
                                      width: 48,
                                      height: 48,
                                      decoration: BoxDecoration(
                                          color: Theme.of(context).primaryColor,
                                          border: Border.all(
                                              width: 1,
                                              color: Theme.of(context)
                                                  .accentColor),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(50))),
                                      child: Center(
                                        child: SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: SvgPicture.asset(
                                            paperPlane,
                                            semanticsLabel: 'paper-plane',
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : myGig || appointedUser
                              ? Column(
                                  children: [
                                    SizeTransition(
                                      sizeFactor:
                                          _pickFilecontroller, // duration: Duration(milliseconds: 300),
                                      child: WorkstreamFiles(
                                        passedGigId: widget.passedGigId,
                                        passedGigOwnerId:
                                            widget.passedGigOwnerId,
                                      ),
                                    ),
                                    Container(
                                      child: Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Expanded(
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 15),
                                                // height: 40,
                                                decoration: BoxDecoration(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  border: Border.all(
                                                      width: 1,
                                                      color: Theme.of(context)
                                                          .primaryColor),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10)),
                                                ),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    Expanded(
                                                      child: TextFormField(
                                                        style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .accentColor),
                                                        controller:
                                                            _addCommentsController,
                                                        decoration:
                                                            InputDecoration(
                                                          hintText:
                                                              "Add private comment",
                                                          hintStyle: TextStyle(
                                                              color: Theme.of(
                                                                      context)
                                                                  .accentColor),
                                                          border:
                                                              InputBorder.none,
                                                        ),
                                                        onFieldSubmitted: (String
                                                            submittedString) async {
                                                          if (submittedString
                                                              .isNotEmpty) {
                                                            await AddCommentViewModel()
                                                                .addComment(
                                                              gigIdHoldingComment:
                                                                  widget
                                                                      .passedGigId,
                                                              gigOwnerId: widget
                                                                  .passedGigOwnerId,
                                                              commentOwnerUsername:
                                                                  username,
                                                              commentBody:
                                                                  submittedString,
                                                              commentOwnerId:
                                                                  userId,
                                                              commentOwnerAvatarUrl:
                                                                  userProfilePictureUrl,
                                                              commentId: '',
                                                              isPrivateComment:
                                                                  isPrivateComment,
                                                              proposal:
                                                                  proposal,
                                                              approved:
                                                                  approved,
                                                              rejected:
                                                                  rejected,
                                                              gigCurrency: widget
                                                                  .passedGigCurrency,
                                                              offeredBudget:
                                                                  offeredBudget,
                                                            );
                                                          }

                                                          _addCommentsController
                                                              .clear();
                                                          _addProposalController
                                                              .clear();
                                                          _offeredBudgetController
                                                              .clear();
                                                        },
                                                        minLines: 1,
                                                        maxLines: 6,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 20,
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          if (!_filePickerOpened) {
                                                            _pickFilecontroller
                                                                .forward();
                                                          } else {
                                                            _pickFilecontroller
                                                                .reverse();
                                                          }
                                                          _filePickerOpened =
                                                              !_filePickerOpened;
                                                        });
                                                        //open reveal animation
                                                        print(
                                                            'paperclip tapped');
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                bottom: 15),
                                                        child: SizedBox(
                                                          width: 20,
                                                          height: 20,
                                                          child: SvgPicture.asset(
                                                              paperClip,
                                                              semanticsLabel:
                                                                  'paperclip',
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColor),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            GestureDetector(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(2),
                                                  child: Container(
                                                    height: 48,
                                                    width: 48,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              2),
                                                      child: Center(
                                                        child: Center(
                                                          child: SizedBox(
                                                            width: 20,
                                                            height: 20,
                                                            child: SvgPicture
                                                                .asset(
                                                              actions,
                                                              semanticsLabel:
                                                                  'paper-plane',
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    decoration: BoxDecoration(
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                        border: Border.all(
                                                            width: 1,
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    10))),
                                                  ),
                                                ),
                                                onTap: () {
                                                  Scaffold.of(context)
                                                      .showBottomSheet(
                                                          (BuildContext
                                                              context) {
                                                    return Builder(
                                                      builder: (BuildContext
                                                          context) {
                                                        return Container(
                                                          height: 250,
                                                          child: StatefulBuilder(
                                                              builder: (BuildContext
                                                                      context,
                                                                  StateSetter
                                                                      setModalState) {
                                                            return Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColor,
                                                                border: Border.all(
                                                                    width: 1,
                                                                    color: Theme.of(
                                                                            context)
                                                                        .primaryColor),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .only(
                                                                  topLeft:
                                                                      const Radius
                                                                          .circular(10),
                                                                  topRight:
                                                                      const Radius
                                                                          .circular(10),
                                                                ),
                                                              ),
                                                              child: Padding(
                                                                padding: const EdgeInsets
                                                                        .symmetric(
                                                                    vertical:
                                                                        10,
                                                                    horizontal:
                                                                        10),
                                                                // child: hirer ? _hirerActions() : _applierActions(),
                                                                child: !client
                                                                    ? WorkerActions(
                                                                        passedGigId:
                                                                            widget.passedGigId,
                                                                      )
                                                                    : ClientActions(
                                                                        passedGigId:
                                                                            widget.passedGigId,
                                                                      ),
                                                              ),
                                                            );
                                                          }),
                                                        );
                                                      },
                                                    );
                                                  });
                                                }),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Container(
                                              width: 48,
                                              height: 48,
                                              decoration: BoxDecoration(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  border: Border.all(
                                                    width: 1,
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(50))),
                                              child: GestureDetector(
                                                child: Center(
                                                  child: SizedBox(
                                                    width: 20,
                                                    height: 20,
                                                    child: SvgPicture.asset(
                                                      paperPlane,
                                                      semanticsLabel:
                                                          'paper-plane',
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                                onTap: () {
                                                  addComment();
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Center(
                                    child: Container(
                                      height: 40,
                                      child: Text(
                                        'Private work stream',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1,
                                      ),
                                    ),
                                  ),
                                ),
                    ],
                  ),
                );
              }),
            );
          }
        });
  }

  @override
  void dispose() {
    _addCommentsController.dispose();
    _addProposalController.dispose();
    _offeredBudgetController.dispose();
    // WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
