import 'package:Fyrework/models/myUser.dart';
import 'package:Fyrework/ui/shared/constants.dart';
import 'package:Fyrework/viewmodels/add_comment_view_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

class ProposalWidget extends StatefulWidget {
  final String passedGigId;
  final String passedGigOwnerId;
  final String passedGigCurrency;
  final String passedGigValue;

  ProposalWidget({
    @required this.passedGigId,
    @required this.passedGigOwnerId,
    @required this.passedGigCurrency,
    @required this.passedGigValue,
  });
  @override
  _ProposalWidgetState createState() => _ProposalWidgetState();
}

class _ProposalWidgetState extends State<ProposalWidget> {
  String userId = MyUser.uid;
  String username = MyUser.username;
  dynamic userProfilePictureUrl = MyUser.userAvatarUrl;
  final _proposalFormKey = GlobalKey<FormState>();
  TextEditingController _addCommentsController = TextEditingController();
  TextEditingController _addProposalController = TextEditingController();
  TextEditingController _offeredBudgetController = TextEditingController();
  final String paypalIcon = 'assets/svgs/flaticon/paypal.svg';
  final String cash = 'assets/svgs/flaticon/cash.svg';
  final String alternatePayment = 'assets/svgs/flaticon/alternate_payment.svg';
  String preferredPaymentMethod;
  String proposalBudget;
  bool proposal = false;
  bool isPrivateComment = false;
  bool approved = false;
  bool rejected = false;

  SnackBar _paymentMethodSnackBar;

  addToGigAppliersOrHirersList() {
    FirebaseFirestore.instance
        .collection('gigs')
        .doc(widget.passedGigId)
        .update({
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
          isPrivateComment: isPrivateComment,
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

  @override
  Widget build(BuildContext context) {
    _paymentMethodSnackBar = SnackBar(
      content: Text(
        'Select a payment method',
        style: Theme.of(context)
            .textTheme
            .bodyText1
            .copyWith(color: Theme.of(context).accentColor),
      ),
    );
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setModalState) {
      return Form(
        key: _proposalFormKey,
        child: ListView(
          children: <Widget>[
            Container(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextFormField(
                  style: Theme.of(context).textTheme.bodyText1,
                  controller: _addProposalController,
                  decoration: signUpInputDecoration(
                    context,
                    'Describe your proposal in brief',
                  )
                  // .copyWith(
                  //   enabledBorder: UnderlineInputBorder(
                  //     borderSide: BorderSide(
                  //       color: Theme.of(context).textTheme.caption.color,
                  //       width: 0.5,
                  //     ),
                  //   ),
                  //   focusedBorder: UnderlineInputBorder(
                  //     borderSide: BorderSide(
                  //         color: Theme.of(context).accentColor, width: 0.5),
                  //   ),
                  // )
                  ,
                  inputFormatters: [
                    new LengthLimitingTextInputFormatter(500),
                  ],
                  validator: (value) => value.isEmpty ? '' : null,
                  minLines: 1,
                  maxLines: 6,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                        color: Theme.of(context).textTheme.caption.color,
                        width: 0.5,
                      ))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: 30,
                                height: 30,
                                child: SvgPicture.asset(
                                  paypalIcon,
                                  semanticsLabel: 'paypal',
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Request PayPal escrow deposit',
                                style: Theme.of(context).textTheme.bodyText1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).accentColor,
                              border: Border.all(
                                  width: 0.5,
                                  color: Theme.of(context).primaryColor),
                              // borderRadius: BorderRadius.circular(10),
                              shape: BoxShape.circle,
                            ),
                            child: SizedBox(
                              width: 20,
                              child: Radio(
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                value: 'paypal',
                                groupValue: preferredPaymentMethod,
                                activeColor: Theme.of(context).primaryColor,
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
                    ),
                    Container(
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                        color: Theme.of(context).textTheme.caption.color,
                        width: 0.5,
                      ))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: 30,
                                height: 30,
                                child: SvgPicture.asset(
                                  cash,
                                  semanticsLabel: 'pay',
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Get paid by cash',
                                style: Theme.of(context).textTheme.bodyText1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).accentColor,
                              border: Border.all(
                                  width: 0.5,
                                  color: Theme.of(context).primaryColor),
                              shape: BoxShape.circle,
                            ),
                            child: SizedBox(
                              width: 20,
                              child: Radio(
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  value: 'cash',
                                  groupValue: preferredPaymentMethod,
                                  activeColor: Theme.of(context).primaryColor,
                                  onChanged: (T) {
                                    setModalState(() {
                                      preferredPaymentMethod = T;
                                    });
                                  }),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                        color: Theme.of(context).textTheme.caption.color,
                        width: 0.5,
                      ))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: 30,
                                height: 30,
                                child: SvgPicture.asset(
                                  alternatePayment,
                                  semanticsLabel: 'alternate payment',
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Agree alternate with the poster',
                                style: Theme.of(context).textTheme.bodyText1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).accentColor,
                              border: Border.all(
                                  width: 0.5,
                                  color: Theme.of(context).primaryColor),
                              shape: BoxShape.circle,
                            ),
                            child: SizedBox(
                              width: 20,
                              child: Radio(
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  value: 'alternate_payment',
                                  groupValue: preferredPaymentMethod,
                                  activeColor: Theme.of(context).primaryColor,
                                  onChanged: (T) {
                                    setModalState(() {
                                      preferredPaymentMethod = T;
                                    });
                                  }),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              height: 48,
              child: Row(
                children: [
                  Container(
                    // height: 36,

                    padding: EdgeInsets.only(left: 10),
                    width: 100,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: StreamBuilder<DocumentSnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('gigs')
                                .doc(widget.passedGigId)
                                .snapshots(),
                            builder: (BuildContext context,
                                AsyncSnapshot<DocumentSnapshot> snapshot) {
                              if (snapshot.hasData) {
                                return Text(
                                  snapshot.data['gigCurrency'],
                                  style: Theme.of(context).textTheme.bodyText1,
                                );
                              }
                              return SizedBox(
                                width: 20,
                                height: 20,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                            style: Theme.of(context).textTheme.bodyText1,
                            controller: _offeredBudgetController,
                            decoration: signUpInputDecoration(context, '0.00')
                            //         .copyWith(
                            //   enabledBorder: UnderlineInputBorder(
                            //     borderSide: BorderSide(
                            //       color: Theme.of(context)
                            //           .textTheme
                            //           .caption
                            //           .color,
                            //       width: 0.5,
                            //     ),
                            //   ),
                            //   focusedBorder: UnderlineInputBorder(
                            //     borderSide: BorderSide(
                            //         color: Theme.of(context).accentColor,
                            //         width: 0.5),
                            //   ),
                            // ),
                            ,
                            keyboardType: TextInputType.number,
                            validator: (value) => value.isEmpty ? '' : null,
                            // onSaved: (value) =>
                            //     proposalBudget = value,

                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      preferredPaymentMethod == null
                          ? Scaffold.of(context).showSnackBar(
                              _paymentMethodSnackBar,
                            )
                          : submitProposal();
                    },
                    child: Container(
                      width: 80.0,
                      decoration: BoxDecoration(
                        color: Theme.of(context).accentColor,
                        border: Border.all(
                            color: Theme.of(context).primaryColor, width: 0.5),
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: Center(
                        child: Text(
                            widget.passedGigValue == 'Gigs I can do'
                                ? 'Hire'
                                : 'Apply',
                            style: Theme.of(context).textTheme.bodyText1),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      );
    });
  }

  @override
  void dispose() {
    _addCommentsController.dispose();
    _addProposalController.dispose();
    _offeredBudgetController.dispose();
    super.dispose();
  }
}
