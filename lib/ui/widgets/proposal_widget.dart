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

  final _paymentMethodSnackBar = SnackBar(
    content: Text(
      'Select a payment method',
      style: TextStyle(fontSize: 16),
    ),
  );

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

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setModalState) {
      return Form(
        key: _proposalFormKey,
        child: ListView(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                // color: Theme.of(context).accentColor,
                borderRadius: BorderRadius.circular(10),
                border:
                    Border.all(color: Theme.of(context).accentColor, width: 2),
              ),
              padding: EdgeInsets.only(left: 10),
              child: TextFormField(
                style: TextStyle(color: Theme.of(context).accentColor),
                controller: _addProposalController,
                decoration: buildSignUpInputDecoration(
                    context, 'Describe your proposal in brief'),
                inputFormatters: [
                  new LengthLimitingTextInputFormatter(500),
                ],
                validator: (value) => value.isEmpty ? '' : null,
                minLines: 1,
                maxLines: 6,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              decoration: BoxDecoration(
                  // color: Theme.of(context).accentColor,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: Theme.of(context).accentColor, width: 2)),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
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
                                color: Theme.of(context).accentColor,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text('Request PayPal escrow deposit',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Theme.of(context).accentColor,
                                )),
                          ],
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Theme.of(context).accentColor,
                              // borderRadius: BorderRadius.circular(10),
                              shape: BoxShape.circle),
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
                    // Divider(
                    //   thickness: 0.5,
                    //   color: Colors.black26,
                    // ),
                    Row(
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
                                color: Theme.of(context).accentColor,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Get paid by cash',
                              style: TextStyle(
                                fontSize: 16,
                                color: Theme.of(context).accentColor,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).accentColor,
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
                    // Divider(
                    //   thickness: 0.5,
                    //   color: Colors.black26,
                    // ),
                    Row(
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
                                color: Theme.of(context).accentColor,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Agree alternate with the poster',
                              style: TextStyle(
                                fontSize: 16,
                                color: Theme.of(context).accentColor,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).accentColor,
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
                  ],
                ),
              ),
            ),
            // Divider(
            //   thickness: 0.5,
            //   color: Colors.black26,
            // ),
            SizedBox(
              height: 20,
            ),
            Container(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: <Widget>[
                        Container(
                          // height: 36,
                          decoration: BoxDecoration(
                              // color: Theme.of(context).accentColor,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Theme.of(context).accentColor,
                                width: 2,
                              )),
                          padding: EdgeInsets.only(left: 10),
                          width: 100,
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: Text(
                                  widget.passedGigCurrency,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .copyWith(
                                        color: Theme.of(context).accentColor,
                                      ),
                                ),
                              ),
                              Expanded(
                                child: TextFormField(
                                  style: TextStyle(
                                      color: Theme.of(context).accentColor),
                                  controller: _offeredBudgetController,
                                  decoration: buildSignUpInputDecoration(
                                      context, '0.00'),

                                  keyboardType: TextInputType.number,
                                  validator: (value) =>
                                      value.isEmpty ? '' : null,
                                  // onSaved: (value) =>
                                  //     proposalBudget = value,

                                  maxLines: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Container(
                        height: 52,
                        decoration: BoxDecoration(
                            // color: Theme.of(context).accentColor,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Theme.of(context).accentColor,
                              width: 2,
                            )),
                        width: 100.0,
                        child: GestureDetector(
                          child: Center(
                            child: Text(
                              widget.passedGigValue == 'Gigs I can do'
                                  ? 'Hire'
                                  : 'Apply',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .copyWith(
                                      color: Theme.of(context).accentColor),
                            ),
                          ),
                          onTap: () {
                            // Navigator.pop(context);

                            preferredPaymentMethod == null
                                ? Scaffold.of(context).showSnackBar(
                                    _paymentMethodSnackBar,
                                  )
                                : submitProposal();
                          },
                        )),
                  ],
                ),
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