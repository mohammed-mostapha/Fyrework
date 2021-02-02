import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:myApp/models/myUser.dart';
import 'package:myApp/screens/add_gig/sizeConfig.dart';
import 'package:myApp/ui/shared/constants.dart';
import 'package:myApp/ui/shared/theme.dart';
import 'package:myApp/ui/views/comments_view.dart';
import 'package:myApp/ui/widgets/provider_widget.dart';
import 'package:myApp/viewmodels/add_comments_view_model.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:myApp/locator.dart';
import 'package:myApp/services/auth_service.dart';
import 'package:myApp/services/storage_repo.dart';
import 'package:custom_switch/custom_switch.dart';
import 'package:sliding_card/sliding_card.dart';

class AddCommentsView extends StatefulWidget {
  final String passedGigId;
  final String passedGigOwnerId;
  final String passedCurrentUserId;
  final String passedGigValue;
  final String passedGigCurrency;
  final String passedGigBudget;
  AddCommentsView({
    Key key,
    @required this.passedGigId,
    @required this.passedGigOwnerId,
    @required this.passedCurrentUserId,
    @required this.passedGigValue,
    @required this.passedGigCurrency,
    @required this.passedGigBudget,
  }) : super(key: key);
  @override
  _AddCommentsViewState createState() => _AddCommentsViewState();
}

SlidingCardController slidingCardController;

class _AddCommentsViewState extends State<AddCommentsView> {
  @override
  void initState() {
    super.initState();
    slidingCardController = SlidingCardController();
  }

  bool myGig;
  bool appointed;
  bool appointedUser;
  String appointedUserId;
  List appliersOrHirersByUserId;
  final String paperClip = 'assets/svgs/solid/paperclip.svg';
  final String paperPlane = 'assets/svgs/solid/paper-plane.svg';
  final String checkCircle = 'assets/svgs/regular/check-circle.svg';

  bool isPrivateComment = false;
  bool proposal = false;
  bool approved = false;
  bool rejected = false;
  String offeredBudget;
  String userId = MyUser.uid;
  String username = MyUser.username;
  dynamic userProfilePictureUrl = MyUser.userAvatarUrl;

  final _proposalFormKey = GlobalKey<FormState>();

  TextEditingController _addCommentsController = TextEditingController();
  TextEditingController _addProposalController = TextEditingController();
  TextEditingController _offeredBudgetController = TextEditingController();

  addComment(bool persistentPrivateComment) {
    if (_addCommentsController.text.isNotEmpty) {
      print('_addCommentsController: ${_addCommentsController.text}');
      AddCommentsViewModel().addComment(
        gigIdHoldingComment: widget.passedGigId,
        gigOwnerId: widget.passedGigOwnerId,
        commentOwnerUsername: username,
        commentBody: _addCommentsController.text,
        commentOwnerId: userId,
        commentOwnerAvatarUrl: userProfilePictureUrl,
        commentId: '',
        commentTime: new DateTime.now(),
        isPrivateComment: isPrivateComment,
        persistentPrivateComment: persistentPrivateComment,
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

  addToGigAppliersOrHirersList() {
    Firestore.instance
        .collection('gigs')
        .document(widget.passedGigId)
        .updateData({
      'appliersOrHirersByUserId': FieldValue.arrayUnion([MyUser.uid])
    });
  }

  submitProposal() async {
    if (_proposalFormKey.currentState.validate()) {
      isPrivateComment = true;
      proposal = true;
      await AddCommentsViewModel().addComment(
        gigIdHoldingComment: widget.passedGigId,
        gigOwnerId: widget.passedGigOwnerId,
        commentOwnerUsername: username,
        commentBody: _addCommentsController.text,
        commentOwnerId: userId,
        commentOwnerAvatarUrl: userProfilePictureUrl,
        commentId: '',
        commentTime: new DateTime.now(),
        isPrivateComment: isPrivateComment,
        proposal: proposal,
        approved: approved,
        rejected: rejected,
        gigCurrency: widget.passedGigCurrency,
        offeredBudget: _offeredBudgetController.text,
      );
      addToGigAppliersOrHirersList();
      isPrivateComment = false;
      proposal = false;
      _addCommentsController.clear();
      _addProposalController.clear();
      _offeredBudgetController.clear();

      Navigator.pop(context);
    }
  }

  _showApplyOrHireTemplate() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Container(
            color: Color(0xFF737373),
            child: Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Container(
                height: MediaQuery.of(context).size.height / 1.5,
                decoration: BoxDecoration(
                  color: Theme.of(context).accentColor,
                  // color: Colors.red,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(10),
                    topRight: const Radius.circular(10),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    key: _proposalFormKey,
                    child: ListView(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Container(
                            child: TextFormField(
                              controller: _addCommentsController,
                              decoration:
                                  buildSignUpInputDecoration('Your proposal'),
                              inputFormatters: [
                                new LengthLimitingTextInputFormatter(500),
                              ],
                              validator: (value) => value.isEmpty ? '*' : null,
                              maxLines: null,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        //choosing payment method
                        PaymentMethod(
                          onCardTapped: () {
                            print('card tapped');
                            if (slidingCardController.isCardSeparated == true) {
                              slidingCardController.collapseCard();
                            } else {
                              slidingCardController.expandCard();
                            }
                          },
                          slidingCardController: slidingCardController,
                        ),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                        //   crossAxisAlignment: CrossAxisAlignment.start,
                        //   children: [
                        // Column(
                        //   children: [
                        //     SizedBox(
                        //       width: 40,
                        //       height: 40,
                        //       child: SvgPicture.asset(
                        //         paypalIcon,
                        //         semanticsLabel: 'user',
                        //         // color: Colors.white,
                        //       ),
                        //     ),
                        //     Container(
                        //       child: SizedBox(
                        //         width: 20,
                        //         child: Radio(
                        //           materialTapTargetSize:
                        //               MaterialTapTargetSize.shrinkWrap,
                        //           value: 'Paypal',
                        //           groupValue: preferredPaymentMethod,
                        //           activeColor:
                        //               Theme.of(context).primaryColor,
                        //           onChanged: (T) {
                        //             setState(() {
                        //               preferredPaymentMethod = T;

                        //               // Gig().gigValue = gigValue;
                        //             });
                        //           },
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        // Column(
                        //   children: [
                        //     SizedBox(
                        //       width: 40,
                        //       height: 40,
                        //       child: SvgPicture.asset(
                        //         pay,
                        //         semanticsLabel: 'pay',
                        //         // color: Colors.white,
                        //       ),
                        //     ),
                        //     Container(
                        //       child: SizedBox(
                        //         width: 20,
                        //         child: Radio(
                        //             materialTapTargetSize:
                        //                 MaterialTapTargetSize
                        //                     .shrinkWrap,
                        //             value: 'Cash',
                        //             groupValue: preferredPaymentMethod,
                        //             activeColor:
                        //                 Theme.of(context).primaryColor,
                        //             onChanged: (T) {
                        //               setState(() {
                        //                 preferredPaymentMethod = T;
                        //               });
                        //             }),
                        //       ),
                        //     ),
                        //     Row(
                        //       mainAxisAlignment: MainAxisAlignment.end,
                        //       children: <Widget>[
                        //         Text(
                        //           '${widget.passedGigCurrency}',
                        //           style: TextStyle(fontSize: 16),
                        //         ),
                        //         SizedBox(
                        //           width: 10,
                        //         ),
                        //         Container(
                        //           width: 100,
                        //           child: TextFormField(
                        //             controller: _addCommentsController,
                        //             decoration: buildSignUpInputDecoration(
                        //                 'Budget'),
                        //             keyboardType: TextInputType.number,
                        //             validator: (value) =>
                        //                 value.isEmpty ? '*' : null,
                        //             maxLines: null,
                        //           ),
                        //         ),
                        //       ],
                        //     ),
                        //   ],
                        // ),
                        //   ],
                        // ),

                        //end choosing payment method

                        // Container(
                        //   height: 20,
                        // ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              width: 100.0,
                              child: RaisedButton(
                                  splashColor: Colors.green,
                                  color: FyreworkrColors.fyreworkBlack,
                                  child: Text(
                                    widget.passedGigValue == 'Gigs I can do'
                                        ? 'Hire'
                                        : 'Apply',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onPressed: () {
                                    // Navigator.pop(context);
                                    submitProposal();
                                  }),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    myGig = widget.passedGigOwnerId == MyUser.uid ? true : false;

//first check if this gig is appointed or not
    return StreamBuilder<DocumentSnapshot>(
      stream: Firestore.instance
          .collection('gigs')
          .document(widget.passedGigId)
          .snapshots(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: CircularProgressIndicator(
              valueColor:
                  AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
            ),
          );
        }

        appointed = snapshot.data['appointed'];
        appointedUserId = snapshot.data['appointedUserId'];
        appliersOrHirersByUserId = snapshot.data['appliersOrHirersByUserId'];
        appointedUser = appointedUserId == MyUser.uid ? true : false;

        return Container(
          child: ViewModelProvider<AddCommentsViewModel>.withConsumer(
            viewModelBuilder: () {
              return AddCommentsViewModel();
            },
            builder: (context, model, child) => Scaffold(
              appBar: new AppBar(
                backgroundColor: Theme.of(context).primaryColor,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Comments',
                      style: TextStyle(fontSize: 16),
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            '${widget.passedGigCurrency} ${widget.passedGigBudget}',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          !appointed
                              ? Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        width: 1,
                                        color: Colors.white,
                                      ),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(2))),
                                  child: GestureDetector(
                                    child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          myGig
                                              ? 'Your gig'
                                              : !appliersOrHirersByUserId
                                                      .contains(MyUser.uid)
                                                  ? widget.passedGigValue ==
                                                          'Gig I can do'
                                                      ? 'Hire'
                                                      : 'Apply'
                                                  : 'Request sent',
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.white),
                                        )),
                                    onTap: myGig
                                        ? () {}
                                        : !appointed
                                            ? !appliersOrHirersByUserId
                                                    .contains(MyUser.uid)
                                                ? () {
                                                    _showApplyOrHireTemplate();
                                                  }
                                                : () {}
                                            : () {},
                                  ),
                                )
                              : appointedUserId == MyUser.uid
                                  ? SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: SvgPicture.asset(checkCircle,
                                          semanticsLabel: 'check-circle',
                                          color: Colors.green),
                                    )
                                  : Container(
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
                                          'Appointed',
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.white),
                                        ),
                                      ),
                                    )
                        ],
                      ),
                    ),
                  ],
                ),
                bottom: PreferredSize(
                    child: Container(
                      color: FyreworkrColors.fyreworkBlack,
                      height: 0.5,
                    ),
                    preferredSize: Size.fromHeight(4.0)),
              ),
              body: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: CommentsView(
                      isGigAppointed: appointed,
                      // passedCurrentUserId: userId,
                      gigIdCommentsIdentifier: widget.passedGigId,
                      gigOwnerId: widget.passedGigOwnerId,
                    ),
                  ),
                  !appointed
                      ? Padding(
                          padding: EdgeInsets.all(5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              CustomSwitch(
                                activeColor: FyreworkrColors.fyreworkBlack,
                                value: isPrivateComment,
                                onChanged: (value) {
                                  setState(() {
                                    isPrivateComment = value;
                                  });
                                },
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                child: TextFormField(
                                  controller: _addCommentsController,
                                  decoration: InputDecoration(
                                    hintText: "Add comment...",
                                    border: InputBorder.none,
                                  ),
                                  onFieldSubmitted:
                                      (String submittedString) async {
                                    if (submittedString.isNotEmpty) {
                                      await AddCommentsViewModel().addComment(
                                        gigIdHoldingComment: widget.passedGigId,
                                        gigOwnerId: widget.passedGigOwnerId,
                                        commentOwnerUsername: username,
                                        commentBody: submittedString,
                                        commentOwnerId: userId,
                                        commentOwnerAvatarUrl:
                                            userProfilePictureUrl,
                                        commentId: '',
                                        commentTime: new DateTime.now(),
                                        isPrivateComment: isPrivateComment,
                                        proposal: proposal,
                                        approved: approved,
                                        rejected: rejected,
                                        gigCurrency: widget.passedGigCurrency,
                                        offeredBudget: offeredBudget,
                                      );
                                    }

                                    _addCommentsController.clear();
                                    _addProposalController.clear();
                                    _offeredBudgetController.clear();
                                  },
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.send,
                                  color: FyreworkrColors.fyreworkBlack,
                                ),
                                onPressed: () {
                                  addComment(false);
                                },
                              ),
                            ],
                          ),
                        )
                      : myGig || appointedUser
                          ? Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      height: 40,
                                      decoration: BoxDecoration(
                                          color: Theme.of(context).primaryColor,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(50))),
                                      child: TextFormField(
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).accentColor),
                                        controller: _addCommentsController,
                                        decoration: InputDecoration(
                                          hintText: "Add private comment",
                                          hintStyle: TextStyle(
                                              color: Theme.of(context)
                                                  .accentColor),
                                          border: InputBorder.none,
                                          suffixIconConstraints:
                                              BoxConstraints(),
                                          suffixIcon: GestureDetector(
                                            child: SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: SvgPicture.asset(
                                                paperClip,
                                                semanticsLabel: 'paperclip',
                                                color: Theme.of(context)
                                                    .accentColor,
                                              ),
                                            ),
                                            onTap: () {},
                                          ),
                                        ),
                                        onFieldSubmitted:
                                            (String submittedString) async {
                                          if (submittedString.isNotEmpty) {
                                            await AddCommentsViewModel()
                                                .addComment(
                                              gigIdHoldingComment:
                                                  widget.passedGigId,
                                              gigOwnerId:
                                                  widget.passedGigOwnerId,
                                              commentOwnerUsername: username,
                                              commentBody: submittedString,
                                              commentOwnerId: userId,
                                              commentOwnerAvatarUrl:
                                                  userProfilePictureUrl,
                                              commentId: '',
                                              commentTime: new DateTime.now(),
                                              isPrivateComment:
                                                  isPrivateComment,
                                              persistentPrivateComment: true,
                                              proposal: proposal,
                                              approved: approved,
                                              rejected: rejected,
                                              gigCurrency:
                                                  widget.passedGigCurrency,
                                              offeredBudget: offeredBudget,
                                            );
                                          }

                                          _addCommentsController.clear();
                                          _addProposalController.clear();
                                          _offeredBudgetController.clear();
                                        },
                                      ),
                                    ),
                                  ),

                                  SizedBox(
                                    width: 10,
                                  ),

                                  // IconButton(
                                  //   icon: Icon(
                                  //     Icons.send,
                                  //     color: FyreworkrColors.fyreworkBlack,
                                  //   ),
                                  //   onPressed: () {
                                  //     addComment(true);
                                  //   },
                                  // ),
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(50))),
                                    child: GestureDetector(
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
                                      onTap: () {
                                        addComment(true);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Container(
                                height: 40,
                                child: ListTile(
                                  title: Center(
                                    child: Text(
                                      'Private work stream',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ),
                              ),
                            )
                ],
              ),
            ),
          ),
        );
      },
    );
//end check

// new code

//end new code
  }

  // showApplyOrHireTemplate() {
  //   Scaffold.of(context).showSnackBar(SnackBar(content: Text('snackbar')));
  // }

  @override
  void dispose() {
    _addCommentsController.dispose();
    _addProposalController.dispose();
    _offeredBudgetController.dispose();
    super.dispose();
  }
}

//Cash in hand
class PaymentMethod extends StatefulWidget {
  PaymentMethod({
    Key key,
    this.slidingCardController,
    @required this.onCardTapped,
  }) : super(key: key);

  final SlidingCardController slidingCardController;
  final Function onCardTapped;

  @override
  _PaymentMethodState createState() => _PaymentMethodState();
}

class _PaymentMethodState extends State<PaymentMethod> {
  final String paypalIcon = 'assets/svgs/flaticon/paypal.svg';
  final String pay = 'assets/svgs/flaticon/pay.svg';
  String proposalBudget;
  TextEditingController _submitProposalController = TextEditingController();

  String preferredPaymentMethod;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).orientation == Orientation.landscape
          ? EdgeInsets.only(bottom: 30)
          : EdgeInsets.zero,
      child: SlidingCard(
        slimeCardElevation: 0.5,
        // slidingAnimationReverseCurve: Curves.bounceInOut,
        cardsGap: SizeConfig.safeBlockVertical,
        controller: widget.slidingCardController,
        slidingCardWidth: SizeConfig.horizontalBloc * 90,
        visibleCardHeight: SizeConfig.safeBlockVertical * 17,
        hiddenCardHeight: SizeConfig.safeBlockVertical * 15,
        frontCardWidget: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                SizedBox(
                  width: 40,
                  height: 40,
                  child: SvgPicture.asset(
                    paypalIcon,
                    semanticsLabel: 'paypal',
                    // color: Colors.white,
                  ),
                ),
                Container(
                  child: SizedBox(
                    width: 20,
                    child: Radio(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      value: 'Paypal',
                      groupValue: preferredPaymentMethod,
                      activeColor: Theme.of(context).primaryColor,
                      onChanged: (T) {
                        setState(() {
                          preferredPaymentMethod = T;
                          widget.slidingCardController.collapseCard();
                          proposalBudget = null;
                          // Gig().gigValue = gigValue;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                SizedBox(
                  width: 40,
                  height: 40,
                  child: SvgPicture.asset(
                    pay,
                    semanticsLabel: 'pay',
                    // color: Colors.white,
                  ),
                ),
                Container(
                  child: SizedBox(
                    width: 20,
                    child: Radio(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        value: 'Cash',
                        groupValue: preferredPaymentMethod,
                        activeColor: Theme.of(context).primaryColor,
                        onChanged: (T) {
                          setState(() {
                            preferredPaymentMethod = T;
                            widget.onCardTapped();
                          });
                        }),
                  ),
                ),
              ],
            ),
          ],
        ),
        backCardWidget: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Text(
              // '${AddCommentsView().passedGigCurrency}',
              'Currency',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(
              width: 10,
            ),
            Container(
              width: 100,
              child: TextFormField(
                decoration: buildSignUpInputDecoration('Budget'),
                keyboardType: TextInputType.number,
                validator: (value) => value.isEmpty ? '*' : null,
                onSaved: (value) => proposalBudget = value,
                maxLines: null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Additional disposal code
    _submitProposalController.dispose();
    super.dispose();
  }
}
