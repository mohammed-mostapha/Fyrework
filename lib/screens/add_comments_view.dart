import 'package:Fyrework/custom_widgets/client_actions.dart';
import 'package:Fyrework/custom_widgets/proposal_widget.dart';
import 'package:Fyrework/custom_widgets/worker_actions.dart';
import 'package:Fyrework/custom_widgets/workstream_files.dart';
import 'package:Fyrework/firebase_database/firestore_database.dart';
import 'package:Fyrework/firebase_database/realtime_database.dart';
import 'package:Fyrework/models/comment.dart';
import 'package:Fyrework/ui/shared/fyreworkLightTheme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:Fyrework/models/myUser.dart';
import 'package:Fyrework/ui/shared/constants.dart';
import 'package:Fyrework/screens/comments_view.dart';
import 'package:custom_switch/custom_switch.dart';
import 'package:dartx/dartx.dart';
import 'package:intl/intl.dart';

class AddCommentsView extends StatefulWidget {
  final String passedGigId;
  final String passedGigOwnerId;
  final String passGigOwnerUsername;
  final String passedCurrentUserId;
  final String passedGigCurrency;
  final String passedGigValue;
  final String passedGigBudget;

  AddCommentsView({
    Key key,
    @required this.passedGigId,
    @required this.passedGigOwnerId,
    @required this.passGigOwnerUsername,
    @required this.passedCurrentUserId,
    @required this.passedGigValue,
    @required this.passedGigCurrency,
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
  bool _canSendComment = false;
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
  // bool isPortrait = true;
  // final _proposalFormKey = GlobalKey<FormState>();
  TextEditingController _addCommentsController = TextEditingController();
  TextEditingController _addProposalController = TextEditingController();
  TextEditingController _offeredBudgetController = TextEditingController();

  bool myGig = false;
  bool appointed = false;
  bool hirer;
  String hirerId = '';
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

  Future addComment({
    @required String gigIdHoldingComment,
    @required String gigOwnerId,
    @required String gigOwnerUsername,
    String commentId,
    @required String commentOwnerId,
    @required String commentOwnerAvatarUrl,
    @required String commentOwnerUsername,
    @required dynamic commentBody,
    @required bool isPrivateComment,
    @required bool proposal,
    @required bool approved,
    @required bool rejected,
    String gigCurrency,
    String offeredBudget,
    @required String gigValue,
    String preferredPaymentMethod,
    @required bool isGigCompleted,
    @required bool containMediaFile,
    appointedUserId,
    appointedUsername,
    int ratingCount,
    bool leftReview,
  }) async {
    await FirestoreDatabase().addComment(
      Comment(
        gigIdHoldingComment: gigIdHoldingComment,
        gigOwnerId: gigOwnerId,
        gigOwnerUsername: gigOwnerUsername,
        commentId: commentId,
        commentOwnerId: commentOwnerId,
        commentOwnerAvatarUrl: commentOwnerAvatarUrl,
        commentOwnerUsername: commentOwnerUsername,
        commentBody: commentBody,
        // createdAt: FieldValue.serverTimestamp(),
        createdAt: DateTime.now(),
        isPrivateComment: isPrivateComment,
        proposal: proposal,
        approved: approved,
        rejected: rejected,
        gigCurrency: gigCurrency,
        offeredBudget: offeredBudget,
        gigValue: gigValue,
        preferredPaymentMethod: preferredPaymentMethod,
        containMediaFile: containMediaFile,
        commentPrivacyToggle: isPrivateComment,
        isGigCompleted: isGigCompleted,
        appointedUserId: appointedUserId,
        appointedUsername: appointedUsername,
        ratingCount: ratingCount,
        leftReview: leftReview,
      ),
      gigIdHoldingComment,
    );

    _addCommentsController.clear();
    _addProposalController.clear();
    _offeredBudgetController.clear();
    setState(() {
      _canSendComment = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // var brightness = MediaQuery.of(context).platformBrightness;
    // bool darkModeOn = brightness == Brightness.dark;
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    // isPortrait = MediaQuery.of(context).orientation == Orientation.portrait
    //     ? true
    //     : false;

    myGig = widget.passedGigOwnerId == MyUser.uid ? true : false;
    gigICanDo = widget.passedGigValue == 'Gig i can do' ? true : false;
    worker = (!myGig && gigICanDo || myGig && gigICanDo) ? true : false;
    client = (myGig && !gigICanDo || !myGig && gigICanDo) ? true : false;
    // _keyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0;

    // hirer = (myGig && !gigICanDo || !myGig && gigICanDo) ? true : false;

//first check if this gig is appointed or not
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        child: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('gigs')
                .doc(widget.passedGigId)
                .snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
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
                Future.delayed(Duration(milliseconds: 1000)).then((_) {
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
                hirerId = snapshot.data['hirerId'];
                hirer = MyUser.uid == hirerId ? true : false;
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
                                      style:
                                          Theme.of(context).textTheme.bodyText1)
                                  : Container(
                                      width: 130,
                                      child: StreamBuilder(
                                        stream: FirestoreDatabase()
                                            .showGigWorkstreamActions(
                                          gigId: widget.passedGigId,
                                        ),
                                        builder: (context, snapshot) {
                                          if (!snapshot.hasData ||
                                              !(snapshot.data.docs.length >
                                                  0)) {
                                            List<PopupMenuItem> actionItems =
                                                [];
                                            actionItems.add(
                                              PopupMenuItem<String>(
                                                child: Center(
                                                  child: Text(
                                                    'Workstream has no history',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText1
                                                        .copyWith(
                                                            color: Theme.of(
                                                                    context)
                                                                .accentColor),
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
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              itemBuilder:
                                                  (BuildContext context) {
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
                                                  DateFormat(
                                                          'd MMM, yyyy h:mm a')
                                                      .format(actionSnapshot
                                                          .data()['createdAt']
                                                          .toDate());
                                            }

                                            actionItems.add(
                                              PopupMenuItem(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 10.0),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        color: Theme.of(context)
                                                            .inputDecorationTheme
                                                            .fillColor,
                                                        border: Border(),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10)),
                                                    child: ListTile(
                                                      leading: CircleAvatar(
                                                        maxRadius: 20,
                                                        backgroundColor:
                                                            Theme.of(context)
                                                                .primaryColor,
                                                        backgroundImage:
                                                            NetworkImage(
                                                                "${actionSnapshot.data()['userAvatarUrl']}"),
                                                      ),
                                                      title: Column(
                                                        children: [
                                                          Text(
                                                              "${actionSnapshot.data()['gigAction']}"
                                                                  .capitalize(),
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodyText1),
                                                          Text(
                                                            "$gigWorkstreamActionDate",
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodyText1
                                                                .copyWith(
                                                                  color: Theme.of(
                                                                          context)
                                                                      .primaryColor,
                                                                ),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          }
                                          return Theme(
                                            data: Theme.of(context).copyWith(
                                                cardColor: Theme.of(context)
                                                    .accentColor),
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
                                                      semanticsLabel:
                                                          'down-arrow',
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              // color: Theme.of(context).primaryColor,
                                              itemBuilder:
                                                  (BuildContext context) {
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
                                    style:
                                        Theme.of(context).textTheme.bodyText1),
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
                                                            .contains(
                                                                MyUser.uid)
                                                        ? () {
                                                            showModalBottomSheet(
                                                                barrierColor: Theme.of(
                                                                        context)
                                                                    .bottomAppBarColor,
                                                                isScrollControlled:
                                                                    true,
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  return Builder(builder:
                                                                      (BuildContext
                                                                          context) {
                                                                    return Container(
                                                                      height:
                                                                          screenHeight /
                                                                              1.5,
                                                                      child:
                                                                          Scaffold(
                                                                        backgroundColor:
                                                                            Color(0xFF737373),
                                                                        body:
                                                                            Container(
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color:
                                                                                Theme.of(context).scaffoldBackgroundColor,
                                                                            border:
                                                                                Border.all(width: 1, color: Theme.of(context).primaryColor),
                                                                            borderRadius:
                                                                                BorderRadius.only(
                                                                              topLeft: const Radius.circular(10),
                                                                              topRight: const Radius.circular(10),
                                                                            ),
                                                                          ),
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
                                                                            child:
                                                                                ProposalWidget(
                                                                              passedGigId: widget.passedGigId,
                                                                              passedGigOwnerId: widget.passedGigOwnerId,
                                                                              passedGigOwnerUsername: widget.passGigOwnerUsername,
                                                                              passedGigCurrency: gigCurrency,
                                                                              passedGigValue: widget.passedGigValue,
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
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(2))),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
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
                                                      .bodyText1,
                                                ),
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
                                              padding:
                                                  const EdgeInsets.all(8.0),
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
                                  padding: EdgeInsets.all(10),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Expanded(
                                        child: Container(
                                          // height: 40,

                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                        width: 1,
                                                        color: Theme.of(context)
                                                            .primaryColor),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10)),
                                                  ),
                                                  child: TextFormField(
                                                    style: TextStyle(
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                    ),
                                                    controller:
                                                        _addCommentsController,
                                                    decoration:
                                                        signUpInputDecoration(
                                                      context,
                                                      'Add comment',
                                                    ),
                                                    onFieldSubmitted: (String
                                                        submittedString) async {
                                                      if (submittedString
                                                          .isNotEmpty) {
                                                        await addComment(
                                                          gigValue: widget
                                                              .passedGigValue,
                                                          gigIdHoldingComment:
                                                              widget
                                                                  .passedGigId,
                                                          gigOwnerId: widget
                                                              .passedGigOwnerId,
                                                          gigOwnerUsername: widget
                                                              .passGigOwnerUsername,
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
                                                          proposal: proposal,
                                                          approved: approved,
                                                          rejected: rejected,
                                                          gigCurrency: widget
                                                              .passedGigCurrency,
                                                          offeredBudget:
                                                              offeredBudget,
                                                          containMediaFile:
                                                              false,
                                                          isGigCompleted: false,
                                                        );
                                                      }

                                                      _addCommentsController
                                                          .clear();
                                                      _addProposalController
                                                          .clear();
                                                      _offeredBudgetController
                                                          .clear();
                                                    },
                                                    inputFormatters: [
                                                      LengthLimitingTextInputFormatter(
                                                          50),
                                                    ],
                                                    minLines: 1,
                                                    maxLines: 6,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(bottom: 7),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      width: 1,
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                50)),
                                                  ),
                                                  child: CustomSwitch(
                                                    activeColor: Colors.black,
                                                    value: isPrivateComment,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        isPrivateComment =
                                                            value;
                                                      });
                                                    },
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
                                        onTap: () async {
                                          if (_addCommentsController
                                              .text.isNotEmpty) {
                                            await addComment(
                                              gigIdHoldingComment:
                                                  widget.passedGigId,
                                              gigOwnerId:
                                                  widget.passedGigOwnerId,
                                              gigOwnerUsername:
                                                  widget.passGigOwnerUsername,
                                              commentOwnerUsername: username,
                                              commentBody:
                                                  _addCommentsController.text,
                                              commentOwnerId: userId,
                                              commentOwnerAvatarUrl:
                                                  userProfilePictureUrl,
                                              commentId: '',
                                              isPrivateComment:
                                                  isPrivateComment,
                                              proposal: proposal,
                                              approved: approved,
                                              rejected: rejected,
                                              gigCurrency:
                                                  widget.passedGigCurrency,
                                              offeredBudget: offeredBudget,
                                              gigValue: widget.passedGigValue,
                                              containMediaFile: false,
                                              isGigCompleted: false,
                                            );
                                            await RealTimeDatabase()
                                                .addCommentNotification(
                                              gigId: widget.passedGigId,
                                              gigOwnerId:
                                                  widget.passedGigOwnerId,
                                              commenterId: MyUser.uid,
                                              commenterUsername:
                                                  MyUser.username,
                                              commenterUserAvatarUrl:
                                                  MyUser.userAvatarUrl,
                                              commentBody:
                                                  _addCommentsController.text,
                                            );
                                          }
                                        },
                                        child: Container(
                                          width: 48,
                                          height: 48,
                                          decoration: BoxDecoration(
                                              color:
                                                  Theme.of(context).accentColor,
                                              border: Border.all(
                                                  width: 1,
                                                  color: Theme.of(context)
                                                      .primaryColor),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(50))),
                                          child: Center(
                                            child: SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: SvgPicture.asset(
                                                paperPlane,
                                                semanticsLabel: 'paper-plane',
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : myGig || appointedUser || hirer
                                  ? Column(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(40.0),
                                          child: SizeTransition(
                                            sizeFactor:
                                                _pickFilecontroller, // duration: Duration(milliseconds: 300),
                                            child: WorkstreamFiles(
                                              passedGigId: widget.passedGigId,
                                              passedGigOwnerId:
                                                  widget.passedGigOwnerId,
                                              passedGigOwnerUsername:
                                                  widget.passGigOwnerUsername,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 16),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: Theme.of(context)
                                                          .inputDecorationTheme
                                                          .fillColor,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10)),
                                                    ),
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: [
                                                        Expanded(
                                                          child: TextFormField(
                                                            style: TextStyle(
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColor,
                                                            ),
                                                            controller:
                                                                _addCommentsController,
                                                            decoration:
                                                                signUpInputDecoration(
                                                              context,
                                                              "Add private comment",
                                                            ),
                                                            onChanged: (text) {
                                                              setState(() {
                                                                _addCommentsController
                                                                        .text
                                                                        .isNotEmpty
                                                                    ? _canSendComment =
                                                                        true
                                                                    : _canSendComment =
                                                                        false;
                                                              });
                                                            },
                                                            onFieldSubmitted:
                                                                (String
                                                                    submittedString) async {
                                                              if (submittedString
                                                                  .isNotEmpty) {
                                                                await addComment(
                                                                  gigValue: widget
                                                                      .passedGigValue,
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
                                                                  isGigCompleted:
                                                                      false,
                                                                  containMediaFile:
                                                                      false,
                                                                  gigOwnerUsername:
                                                                      widget
                                                                          .passGigOwnerUsername,
                                                                  proposal:
                                                                      proposal,
                                                                  approved:
                                                                      approved,
                                                                  rejected:
                                                                      rejected,
                                                                  gigCurrency:
                                                                      widget
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
                                                            inputFormatters: [
                                                              LengthLimitingTextInputFormatter(
                                                                  50),
                                                            ],
                                                            minLines: 1,
                                                            maxLines: 6,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 20,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  right: 10),
                                                          child:
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
                                                                      bottom:
                                                                          15),
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
                                                          const EdgeInsets.all(
                                                              2),
                                                      child: Container(
                                                        height: 48,
                                                        width: 48,
                                                        child: Center(
                                                          child: Center(
                                                            child: SizedBox(
                                                              width: 20,
                                                              height: 20,
                                                              child: SvgPicture
                                                                  .asset(
                                                                actions,
                                                                semanticsLabel:
                                                                    'actions',
                                                                color: Theme.of(
                                                                        context)
                                                                    .accentColor,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        decoration: BoxDecoration(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            50))),
                                                      ),
                                                    ),
                                                    onTap: () {
                                                      showModalBottomSheet(
                                                          shape:
                                                              RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    20.0),
                                                            topRight:
                                                                Radius.circular(
                                                                    20.0),
                                                          )),
                                                          backgroundColor:
                                                              fyreworkLightTheme()
                                                                  .accentColor,
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return Container(
                                                              child: SafeArea(
                                                                child: Builder(
                                                                  builder:
                                                                      (BuildContext
                                                                          context) {
                                                                    return Container(
                                                                      height:
                                                                          250,
                                                                      child: StatefulBuilder(
                                                                          builder:
                                                                              (
                                                                        BuildContext
                                                                            context,
                                                                        StateSetter
                                                                            setModalState,
                                                                      ) {
                                                                        return Container(
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                const EdgeInsets.all(
                                                                              10,
                                                                            ),
                                                                            // child: hirer ? _hirerActions() : _applierActions(),
                                                                            child: !client
                                                                                ? WorkerActions(
                                                                                    passedGigId: widget.passedGigId,
                                                                                    passedGigOwnerId: widget.passedGigOwnerId,
                                                                                    passedGigOwnerUsername: widget.passGigOwnerUsername,
                                                                                  )
                                                                                : ClientActions(
                                                                                    passedGigId: widget.passedGigId,
                                                                                    passedGigOwnerId: widget.passedGigOwnerId,
                                                                                    passedGigOwnerUsername: widget.passGigOwnerUsername,
                                                                                  ),
                                                                          ),
                                                                        );
                                                                      }),
                                                                    );
                                                                  },
                                                                ),
                                                              ),
                                                            );
                                                          });
                                                    }),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                GestureDetector(
                                                  onTap: _canSendComment
                                                      ? () {
                                                          addComment(
                                                            gigIdHoldingComment:
                                                                widget
                                                                    .passedGigId,
                                                            gigOwnerId: widget
                                                                .passedGigOwnerId,
                                                            gigOwnerUsername: widget
                                                                .passGigOwnerUsername,
                                                            commentOwnerUsername:
                                                                username,
                                                            commentBody:
                                                                _addCommentsController
                                                                    .text,
                                                            commentOwnerId:
                                                                userId,
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
                                                            gigValue: widget
                                                                .passedGigValue,
                                                            containMediaFile:
                                                                false,
                                                            isGigCompleted:
                                                                false,
                                                          );
                                                        }
                                                      : null,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            2.0),
                                                    child: Container(
                                                      width: 48,
                                                      height: 48,
                                                      decoration: BoxDecoration(
                                                        color: _canSendComment
                                                            ? Theme.of(context)
                                                                .primaryColor
                                                            : Colors.grey,
                                                        borderRadius:
                                                            BorderRadius.all(
                                                          Radius.circular(50),
                                                        ),
                                                      ),
                                                      child: Center(
                                                        child: SizedBox(
                                                          width: 20,
                                                          height: 20,
                                                          child:
                                                              SvgPicture.asset(
                                                            paperPlane,
                                                            semanticsLabel:
                                                                'paper-plane',
                                                            color: Theme.of(
                                                                    context)
                                                                .accentColor,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
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
            }),
      ),
    );
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
