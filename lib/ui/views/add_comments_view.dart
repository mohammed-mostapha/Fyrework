import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myApp/ui/shared/theme.dart';
import 'package:myApp/ui/views/comments_view.dart';
import 'package:myApp/ui/widgets/comment_item.dart';
import 'package:myApp/ui/widgets/provider_widget.dart';
import 'package:myApp/viewmodels/add_comments_view_model.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:myApp/locator.dart';
import 'package:myApp/services/auth_service.dart';
import 'package:myApp/services/storage_repo.dart';
import 'package:timeago/timeago.dart';
import 'package:custom_switch/custom_switch.dart';

class AddCommentsView extends StatefulWidget {
  final String passedGigId;
  final String passedGigOwnerId;
  final String passedCurrentUserId;
  final String passedGigValue;
  final bool passedGigAppointed;
  final String passedGigCurrency;
  AddCommentsView({
    Key key,
    @required this.passedGigId,
    @required this.passedGigOwnerId,
    @required this.passedCurrentUserId,
    @required this.passedGigValue,
    @required this.passedGigAppointed,
    @required this.passedGigCurrency,
  }) : super(key: key);
  @override
  _AddCommentsViewState createState() => _AddCommentsViewState();
}

class _AddCommentsViewState extends State<AddCommentsView> {
  AuthService _authService = locator.get<AuthService>();
  StorageRepo _storageRepo = locator.get<StorageRepo>();
  bool privateComment = false;
  bool proposal = false;
  bool approved = false;
  String appointedUserId;
  String appointedUserFullName;
  String offeredBudget;
  String userId;
  String userFullName;
  dynamic userProfilePictureUrl;

  final _proposalFormKey = GlobalKey<FormState>();

  Future<String> getProfilePictureDownloadUrl() async {
    print('fetching profile picture url');
    return userProfilePictureUrl = await _storageRepo
        .getUserProfilePictureDownloadUrl(await _authService.getCurrentUID());
  }

  TextEditingController _addCommentsController = TextEditingController();
  TextEditingController _addProposalController = TextEditingController();
  TextEditingController _offeredBudgetController = TextEditingController();

  addComment() {
    if (_addCommentsController.text != '') {
      print('_addCommentsController: ${_addCommentsController.text}');
      AddCommentsViewModel().addComment(
        gigIdHoldingComment: widget.passedGigId,
        gigOwnerId: widget.passedGigOwnerId,
        commentOwnerFullName: userFullName,
        commentBody: _addCommentsController.text,
        commentOwnerId: userId,
        commentOwnerProfilePictureUrl: userProfilePictureUrl,
        commentId: '',
        commentTime: new DateTime.now(),
        privateComment: privateComment,
        proposal: proposal,
        approved: approved,
        appointedUserId: appointedUserId,
        appointedUserFullName: appointedUserFullName,
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

  submitProposal() async {
    if (_proposalFormKey.currentState.validate()) {
      privateComment = true;
      proposal = true;
      await AddCommentsViewModel().addComment(
        gigIdHoldingComment: widget.passedGigId,
        gigOwnerId: widget.passedGigOwnerId,
        commentOwnerFullName: userFullName,
        commentBody: _addCommentsController.text,
        commentOwnerId: userId,
        commentOwnerProfilePictureUrl: userProfilePictureUrl,
        commentId: '',
        commentTime: new DateTime.now(),
        privateComment: privateComment,
        proposal: proposal,
        approved: approved,
        appointedUserId: appointedUserId,
        appointedUserFullName: appointedUserFullName,
        gigCurrency: widget.passedGigCurrency,
        offeredBudget: _offeredBudgetController.text,
      );
      privateComment = false;
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
                    child: ListView(
                      children: <Widget>[
                        Container(
                          height: 100,
                          decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: Colors.grey.shade400, width: 1)),
                          ),
                          child: ListView(
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
                              style: TextStyle(fontSize: 18),
                            ),
                            Container(
                              height: 20,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: Colors.grey.shade400, width: 1)),
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
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    print('passedGigAppointed: ${widget.passedGigAppointed}');
// new code
    return Scaffold(
      appBar: new AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              'Comments',
              style: TextStyle(fontSize: 18),
            ),
            FlatButton(
                color: FyreworkrColors.white,
                child: Text(
                  widget.passedGigOwnerId == widget.passedCurrentUserId
                      ? 'Your gig'
                      : !widget.passedGigAppointed
                          ? widget.passedGigValue == 'Gigs I can do'
                              ? 'Hire me'
                              : 'Apply'
                          : 'Appointed',
                  style: TextStyle(color: FyreworkrColors.fyreworkBlack),
                ),
                onPressed: widget.passedGigOwnerId == widget.passedCurrentUserId
                    ? () {}
                    :
                    // widget.passedGigValue == 'Gigs I can do'
                    //     ? () {}
                    //     : () {},
                    !widget.passedGigAppointed
                        ? () {
                            _showApplyOrHireTemplate();
                          }
                        : () {}),
          ],
        ),
        bottom: PreferredSize(
            child: Container(
              color: FyreworkrColors.fyreworkBlack,
              height: 0.5,
            ),
            preferredSize: Size.fromHeight(4.0)),
      ),
      body: FutureBuilder(
          // future: Provider.of(context).auth.getCurrentUser(),
          future: Future.wait([
            Provider.of(context).auth.getCurrentUser(),
            getProfilePictureDownloadUrl()
          ]),
          builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              userId = snapshot.data[0].uid;
              userFullName = snapshot.data[0].displayName;
              userProfilePictureUrl = snapshot.data[1];
              return ViewModelProvider<AddCommentsViewModel>.withConsumer(
                viewModelBuilder: () {
                  return AddCommentsViewModel();
                },
                builder: (context, model, child) => Builder(
                  builder: (context) => Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                            child: CommentsView(
                          passedCurrentUserId: userId,
                          gigIdCommentsIdentifier: widget.passedGigId,
                          gigOwnerId: widget.passedGigOwnerId,
                        )),
                        ListTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              // CircleAvatar(
                              //   backgroundImage:
                              //       NetworkImage(userProfilePictureUrl),
                              //   radius: 20,
                              // ),
                              CustomSwitch(
                                activeColor: FyreworkrColors.fyreworkBlack,
                                value: privateComment,
                                onChanged: (value) {
                                  setState(() {
                                    privateComment = value;
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
                                    // enabledBorder: UnderlineInputBorder(
                                    //     borderSide: BorderSide(color: Colors.red)),
                                    // focusedBorder: UnderlineInputBorder(
                                    //     borderSide: BorderSide(color: Colors.red)),
                                  ),
                                  // onFieldSubmitted: addComment(),
                                  onFieldSubmitted:
                                      (String submittedString) async {
                                    if (submittedString != '') {
                                      await AddCommentsViewModel().addComment(
                                        gigIdHoldingComment: widget.passedGigId,
                                        gigOwnerId: widget.passedGigOwnerId,
                                        commentOwnerFullName: userFullName,
                                        commentBody: submittedString,
                                        commentOwnerId: userId,
                                        commentOwnerProfilePictureUrl:
                                            userProfilePictureUrl,
                                        commentId: '',
                                        commentTime: new DateTime.now(),
                                        privateComment: privateComment,
                                        proposal: proposal,
                                        approved: approved,
                                        appointedUserId: appointedUserId,
                                        appointedUserFullName:
                                            appointedUserFullName,
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
                                  addComment();
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            } else {
              return Container();
            }
          }),
    );
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
