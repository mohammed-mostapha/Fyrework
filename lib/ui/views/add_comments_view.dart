import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myApp/models/myUser.dart';
import 'package:myApp/ui/shared/theme.dart';
import 'package:myApp/ui/views/comments_view.dart';
import 'package:myApp/ui/widgets/provider_widget.dart';
import 'package:myApp/viewmodels/add_comments_view_model.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:myApp/locator.dart';
import 'package:myApp/services/auth_service.dart';
import 'package:myApp/services/storage_repo.dart';
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
  bool myGig;
  bool appointed;
  bool appointedUser;
  String appointedUserId;
  List appliersOrHirersByUserId;

  @override
  void initState() {
    super.initState();
  }

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
        commentOwnerProfilePictureUrl: userProfilePictureUrl,
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
        commentOwnerProfilePictureUrl: userProfilePictureUrl,
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
                height: MediaQuery.of(context).size.height / 2,
                decoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(10),
                    topRight: const Radius.circular(10),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    key: _proposalFormKey,
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          Container(
                            height: 100,
                            decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: Colors.grey.shade400, width: 1)),
                            ),
                            child: Column(
                              children: <Widget>[
                                TextFormField(
                                  controller: _addCommentsController,
                                  // textInputAction: TextInputAction.newline,
                                  maxLines: null,
                                  keyboardType: TextInputType.multiline,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Your proposal',
                                    fillColor: Colors.transparent,
                                    filled: true,
                                  ),
                                  inputFormatters: [
                                    new LengthLimitingTextInputFormatter(500),
                                  ],
                                  validator: (value) =>
                                      value.isEmpty ? '*' : null,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Text(
                                '${widget.passedGigCurrency}',
                                style: TextStyle(fontSize: 16),
                              ),
                              Container(
                                height: 20,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Colors.grey.shade400,
                                          width: 1)),
                                ),
                                width: 100,
                                child: TextFormField(
                                  controller: _offeredBudgetController,
                                  decoration: InputDecoration(
                                      hintText: 'Budget',
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.only(
                                          left: 15,
                                          bottom: 11,
                                          top: 11,
                                          right: 15)),
                                  // Only numbers can be entered
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    WhitelistingTextInputFormatter.digitsOnly
                                  ],
                                  validator: (value) =>
                                      value.isEmpty ? '*' : null,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
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
                            ],
                          )
                        ],
                      ),
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
                          Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                  color: Colors.white,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(2))),
                            child: Expanded(
                                child: GestureDetector(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  myGig
                                      ? 'Your gig'
                                      : !appointed
                                          ? !appliersOrHirersByUserId
                                                  .contains(MyUser.uid)
                                              ? widget.passedGigValue ==
                                                      'Gig I can do'
                                                  ? 'Hire me'
                                                  : 'Apply'
                                              : 'Applied'
                                          // : 'Appointed',
                                          : appointedUserId == MyUser.uid
                                              ? 'tick Icon'
                                              : 'Appointed',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                              ),
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
                            )),
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
                      // passedCurrentUserId: userId,
                      gigIdCommentsIdentifier: widget.passedGigId,
                      gigOwnerId: widget.passedGigOwnerId,
                    ),
                  ),
                  !appointed
                      ? ListTile(
                          title: Row(
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
                                        commentOwnerProfilePictureUrl:
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
                          ? ListTile(
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      controller: _addCommentsController,
                                      decoration: InputDecoration(
                                        hintText: "Add private comment",
                                        border: InputBorder.none,
                                      ),
                                      onFieldSubmitted:
                                          (String submittedString) async {
                                        if (submittedString.isNotEmpty) {
                                          await AddCommentsViewModel()
                                              .addComment(
                                            gigIdHoldingComment:
                                                widget.passedGigId,
                                            gigOwnerId: widget.passedGigOwnerId,
                                            commentOwnerUsername: username,
                                            commentBody: submittedString,
                                            commentOwnerId: userId,
                                            commentOwnerProfilePictureUrl:
                                                userProfilePictureUrl,
                                            commentId: '',
                                            commentTime: new DateTime.now(),
                                            isPrivateComment: isPrivateComment,
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
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.send,
                                      color: FyreworkrColors.fyreworkBlack,
                                    ),
                                    onPressed: () {
                                      addComment(true);
                                    },
                                  ),
                                ],
                              ),
                            )
                          : ListTile(
                              title: Center(
                                child: Text(
                                  'Private work stream',
                                  style: TextStyle(fontSize: 16),
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
