import 'package:Fyrework/ui/shared/fyreworkTheme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:Fyrework/models/myUser.dart';
import 'package:Fyrework/ui/shared/constants.dart';
import 'package:Fyrework/ui/views/comments_view.dart';
import 'package:Fyrework/viewmodels/add_comment_view_model.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:custom_switch/custom_switch.dart';

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

class _AddCommentsViewState extends State<AddCommentsView> {
  final _proposalFormKey = GlobalKey<FormState>();
  final String paypalIcon = 'assets/svgs/flaticon/paypal.svg';
  final String cash = 'assets/svgs/flaticon/cash.svg';
  final String alternatePayment = 'assets/svgs/flaticon/alternate_payment.svg';
  String proposalBudget;
  String preferredPaymentMethod;

  bool myGig;
  bool appointed;
  bool appointedUser;
  String appointedUserId;
  List appliersOrHirersByUserId;
  final String paperClip = 'assets/svgs/solid/paperclip.svg';
  final String paperPlane = 'assets/svgs/solid/paper-plane.svg';
  final String checkCircle = 'assets/svgs/regular/check-circle.svg';

  final _paymentMethodSnackBar = SnackBar(
    content: Text(
      'Select a payment method',
      style: TextStyle(fontSize: 16),
    ),
  );

  bool isPrivateComment = false;
  bool proposal = false;
  bool approved = false;
  bool rejected = false;
  String offeredBudget;
  String userId = MyUser.uid;
  String username = MyUser.username;
  dynamic userProfilePictureUrl = MyUser.userAvatarUrl;

  TextEditingController _addCommentsController = TextEditingController();
  TextEditingController _addProposalController = TextEditingController();
  TextEditingController _offeredBudgetController = TextEditingController();

  addComment(bool persistentPrivateComment) {
    if (_addCommentsController.text.isNotEmpty) {
      print('_addCommentsController: ${_addCommentsController.text}');
      AddCommentViewModel().addComment(
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
      // isPrivateComment = true;
      proposal = true;
      await AddCommentViewModel().addComment(
          gigIdHoldingComment: widget.passedGigId,
          gigOwnerId: widget.passedGigOwnerId,
          commentOwnerUsername: username,
          commentBody: _addProposalController.text,
          commentOwnerId: userId,
          commentOwnerAvatarUrl: userProfilePictureUrl,
          commentId: '',
          commentTime: new DateTime.now(),
          isPrivateComment: isPrivateComment,
          persistentPrivateComment: true,
          proposal: proposal,
          approved: approved,
          rejected: rejected,
          gigCurrency: widget.passedGigCurrency,
          offeredBudget: _offeredBudgetController.text,
          preferredPaymentMethod: preferredPaymentMethod);
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
        isScrollControlled: true,
        enableDrag: true,
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: MediaQuery.of(context).size.height / 1.5,
            child: Scaffold(
              body: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setModalState) {
                return Container(
                  color: Color(0xFF737373),
                  child: Padding(
                    padding: MediaQuery.of(context).viewInsets,
                    child: Container(
                      // height: MediaQuery.of(context).size.height / 2,
                      decoration: BoxDecoration(
                        color: Theme.of(context).accentColor,
                        // color: Colors.red,
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(10),
                          topRight: const Radius.circular(10),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 10),
                        child: Form(
                          key: _proposalFormKey,
                          child: ListView(
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Container(
                                  child: TextFormField(
                                    controller: _addProposalController,
                                    decoration: buildSignUpInputDecoration(
                                        context,
                                        'Describe your proposal in brief'),
                                    inputFormatters: [
                                      new LengthLimitingTextInputFormatter(500),
                                    ],
                                    validator: (value) =>
                                        value.isEmpty ? '' : null,
                                    maxLines: null,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: 30,
                                              height: 30,
                                              child: SvgPicture.asset(
                                                paypalIcon,
                                                semanticsLabel: 'paypal',
                                                // color: Colors.white,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                                'Request PayPal escrow deposit',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Theme.of(context)
                                                        .primaryColor)),
                                          ],
                                        ),
                                        Container(
                                          child: SizedBox(
                                            width: 20,
                                            child: Radio(
                                              materialTapTargetSize:
                                                  MaterialTapTargetSize
                                                      .shrinkWrap,
                                              value: 'paypal',
                                              groupValue:
                                                  preferredPaymentMethod,
                                              activeColor: Theme.of(context)
                                                  .primaryColor,
                                              onChanged: (T) {
                                                setModalState(() {
                                                  preferredPaymentMethod = T;
                                                  proposalBudget = null;
                                                });
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Divider(
                                      thickness: 0.5,
                                      color: Colors.black26,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: 30,
                                              height: 30,
                                              child: SvgPicture.asset(
                                                cash,
                                                semanticsLabel: 'pay',
                                                // color: Colors.white,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text('Get paid by cash',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Theme.of(context)
                                                        .primaryColor)),
                                          ],
                                        ),
                                        Container(
                                          child: SizedBox(
                                            width: 20,
                                            child: Radio(
                                                materialTapTargetSize:
                                                    MaterialTapTargetSize
                                                        .shrinkWrap,
                                                value: 'cash',
                                                groupValue:
                                                    preferredPaymentMethod,
                                                activeColor: Theme.of(context)
                                                    .primaryColor,
                                                onChanged: (T) {
                                                  setModalState(() {
                                                    preferredPaymentMethod = T;
                                                  });
                                                }),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Divider(
                                      thickness: 0.5,
                                      color: Colors.black26,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: 30,
                                              height: 30,
                                              child: SvgPicture.asset(
                                                alternatePayment,
                                                semanticsLabel:
                                                    'alternate payment',
                                                // color: Colors.white,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                                'Agree alternate with the poster',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Theme.of(context)
                                                        .primaryColor)),
                                          ],
                                        ),
                                        Container(
                                          child: SizedBox(
                                            width: 20,
                                            child: Radio(
                                                materialTapTargetSize:
                                                    MaterialTapTargetSize
                                                        .shrinkWrap,
                                                value: 'alternate_payment',
                                                groupValue:
                                                    preferredPaymentMethod,
                                                activeColor: Theme.of(context)
                                                    .primaryColor,
                                                onChanged: (T) {
                                                  setModalState(() {
                                                    preferredPaymentMethod = T;
                                                  });
                                                }),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Divider(
                                thickness: 0.5,
                                color: Colors.black26,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Row(
                                        children: <Widget>[
                                          Text(
                                            widget.passedGigCurrency,
                                            // 'Currency',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Container(
                                            width: 70,
                                            child: TextFormField(
                                              controller:
                                                  _offeredBudgetController,
                                              decoration:
                                                  buildSignUpInputDecoration(
                                                      context, '0.00'),
                                              keyboardType:
                                                  TextInputType.number,
                                              validator: (value) =>
                                                  value.isEmpty ? '' : null,
                                              // onSaved: (value) =>
                                              //     proposalBudget = value,
                                              maxLines: null,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Container(
                                        width: 100.0,
                                        child: RaisedButton(
                                            materialTapTargetSize:
                                                MaterialTapTargetSize
                                                    .shrinkWrap,
                                            splashColor: Colors.green,
                                            color:
                                                Theme.of(context).primaryColor,
                                            child: Text(
                                              widget.passedGigValue ==
                                                      'Gigs I can do'
                                                  ? 'Hire'
                                                  : 'Apply',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            onPressed: () {
                                              // Navigator.pop(context);

                                              preferredPaymentMethod == null
                                                  ? Scaffold.of(context)
                                                      .showSnackBar(
                                                          _paymentMethodSnackBar)
                                                  : submitProposal();
                                            }),
                                      ),
                                    ],
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
              }),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
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
          child: ViewModelProvider<AddCommentViewModel>.withConsumer(
            viewModelBuilder: () {
              return AddCommentViewModel();
            },
            builder: (context, model, child) => Scaffold(
              appBar: new AppBar(
                backgroundColor: Theme.of(context).primaryColor,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Comments',
                        style: Theme.of(context)
                            .textTheme
                            .headline1
                            .copyWith(color: fyreworkTheme().accentColor)),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            '${widget.passedGigCurrency} ${widget.passedGigBudget}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(color: fyreworkTheme().accentColor),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          !appointed
                              ? GestureDetector(
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
                                                      .contains(MyUser.uid)
                                                  ? widget.passedGigValue ==
                                                          'Gig I can do'
                                                      ? 'Hire'
                                                      : 'Apply'
                                                  : 'Request sent',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1
                                              .copyWith(
                                                  color: fyreworkTheme()
                                                      .accentColor),
                                        )),
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
                      color: Theme.of(context).primaryColor,
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
                                activeColor: Theme.of(context).primaryColor,
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
                                  decoration: buildSignUpInputDecoration(
                                      context, 'Add comment...'),
                                  onFieldSubmitted:
                                      (String submittedString) async {
                                    if (submittedString.isNotEmpty) {
                                      await AddCommentViewModel().addComment(
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
                                  color: Theme.of(context).primaryColor,
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
                                            await AddCommentViewModel()
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
  }

  @override
  void dispose() {
    _addCommentsController.dispose();
    _addProposalController.dispose();
    _offeredBudgetController.dispose();
    super.dispose();
  }
}
