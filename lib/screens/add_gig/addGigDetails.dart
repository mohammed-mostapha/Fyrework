import 'package:flutter/material.dart';
import 'package:myApp/screens/add_gig/assets_picker/pages/multi_assets_picker.dart';
import 'package:myApp/ui/shared/theme.dart';
import 'package:myApp/ui/widgets/provider_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:myApp/view_controllers/user_controller.dart';
import 'package:intl/intl.dart';
import 'package:myApp/locator.dart';
import 'package:myApp/models/gig.dart';
import 'package:myApp/viewmodels/create_gig_view_model.dart';
import 'package:provider_architecture/provider_architecture.dart';

import '../../ui/shared/theme.dart';

class AddGigDetails extends StatefulWidget {
  // final gigHashtagsController = TextEditingController();
  final Gig edittingGig;
  AddGigDetails({Key key, this.edittingGig, Gig edittinGig}) : super(key: key);

  @override
  _AddGigDetailsState createState() => _AddGigDetailsState();
}

class _AddGigDetailsState extends State<AddGigDetails> {
  final _createGigFormKey = GlobalKey<FormState>();

  // instantiating GigModel value here to work with...
  String userId;
  String userProfilePictureDownloadUrl;
  String userFullName;

  String gigHashtags;
  String gigPost;
  dynamic gigDeadline;
  String gigCurrency;
  dynamic gigBudget;
  String gigValue;
  String adultContentText;
  bool adultContentBool = false;
  bool appointed = false;

  DateTime _initialDeadline = new DateTime.now().add(Duration(days: 30));
  TextEditingController _deadLineController = new TextEditingController();

  List<String> _currencies = <String>[
    '€',
    '£',
    '\$',
    'Kr',
  ];

  final _gigValueSnackBar = SnackBar(content: Text('who will do the Gig!!!'));

  // Specifying the deadline date
  Future<Null> _selectedDate(BuildContext context) async {
    final DateTime _selectedDeadline = await showDatePicker(
      context: context,
      initialDate: _initialDeadline,
      firstDate: DateTime.now(),
      lastDate: DateTime(2022),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.dark().copyWith(
              primaryColor: FyreworkrColors.fyreworkBlack, //Head background
              accentColor: Colors.white //selection color
              ),
          child: child,
        );
      },
    );
    if (_selectedDeadline != null) {
      setState(() {
        _initialDeadline = _selectedDeadline;
      });
    }
  }

  @override
  void dispose() {
    // Additional disposal code
    _deadLineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String _formattedDate = new DateFormat.yMMMd().format(_initialDeadline);

    _deadLineController.value = new TextEditingValue(
      // text: _formattedDate == null ? _initialDeadline : '$_formattedDate',
      text: _formattedDate,
      selection: TextSelection.fromPosition(
        TextPosition(offset: _formattedDate.length),
      ),
    );

    return FutureBuilder(
      future: Provider.of(context).auth.getCurrentUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          userId = snapshot.data.uid;
          userFullName = snapshot.data.displayName;
          return snapshot.data.isAnonymous
              ? Container(
                  child: Flexible(
                      child: Text(
                          'You are an Anonymous user in the mean time...signUp to continue')),
                )
              : ViewModelProvider<CreateGigViewModel>.withConsumer(
                  viewModelBuilder: () {
                    return CreateGigViewModel();
                  },
                  builder: (context, model, child) => Scaffold(
                    appBar: AppBar(
                      iconTheme: IconThemeData(
                          color: FyreworkrColors
                              .fyreworkBlack //change your color here
                          ),
                      actions: <Widget>[
                        IgnorePointer(
                          // ignoring: button_next ? false : true,
                          ignoring: false,
                          child: Opacity(
                            // opacity: button_next ? 1 : 0.0,
                            opacity: 1,
                            child: FlatButton(
                              child: Text(
                                'Next',
                                style: TextStyle(
                                  fontSize: 20,
                                  // shadows: <Shadow>[
                                  //   Shadow(
                                  //     blurRadius: 30.0,
                                  //     color: Colors.green,
                                  //   ),
                                  // ],
                                ),
                              ),
                              onPressed: () async {
                                await saveFormValuesAndPickMediaFiles();
                              },
                            ),
                          ),
                        ),
                      ],
                      backgroundColor: FyreworkrColors.white,
                      title: Center(
                        child: Text(
                          'Create Gig',
                          style:
                              TextStyle(color: FyreworkrColors.fyreworkBlack),
                        ),
                      ),
                    ),
                    body: Form(
                      key: _createGigFormKey,
                      // autovalidate: true,
                      // color: Colors.white,
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: ListView(
                          children: <Widget>[
                            Container(
                              // height: 60,
                              decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: Colors.grey.shade400, width: 1)),
                              ),
                              child: Container(
                                height: 50,
                                // child: hashtagsTextFormField(),
                                child: TextFormField(
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: '#Hashtags',
                                      fillColor: Colors.transparent,
                                      filled: true,
                                    ),
                                    inputFormatters: [
                                      new LengthLimitingTextInputFormatter(50),
                                    ],
                                    validator: (value) =>
                                        value.isEmpty ? '*' : null,
                                    onSaved: (value) => gigHashtags = value),
                              ),
                            ),
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
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Gig Post',
                                      fillColor: Colors.transparent,
                                      filled: true,
                                    ),
                                    inputFormatters: [
                                      new LengthLimitingTextInputFormatter(500),
                                    ],
                                    validator: (value) =>
                                        value.isEmpty ? '*' : null,
                                    onSaved: (value) => gigPost = value,
                                    maxLines: null,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              // height: 100,
                              decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: Colors.grey.shade400)),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('DeadLine',
                                        style: TextStyle(fontSize: 18)),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.40,
                                      child: FlatButton(
                                        onPressed: () {
                                          _selectedDate(context);
                                        },
                                        child: TextFormField(
                                          enabled: false,
                                          controller: _deadLineController,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            focusedBorder: InputBorder.none,
                                            enabledBorder: InputBorder.none,
                                            errorBorder: InputBorder.none,
                                            disabledBorder: InputBorder.none,
                                          ),
                                          onChanged: (deadline) {
                                            setState(() {
                                              gigDeadline = deadline;
                                            });
                                          },
                                          onSaved: (value) =>
                                              gigDeadline = value,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              // height: 100,
                              decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: Colors.grey.shade400)),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Container(
                                      width: 90,
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButtonFormField(
                                          dropdownColor: Color(0xFF424242),
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            focusedBorder: InputBorder.none,
                                            enabledBorder: InputBorder.none,
                                            errorBorder: InputBorder.none,
                                            disabledBorder: InputBorder.none,
                                          ),
                                          items: _currencies
                                              .map((value) => DropdownMenuItem(
                                                    child: Container(
                                                      width: 25,
                                                      height: 25,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: Colors.white,
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          value,
                                                          style: TextStyle(
                                                            color: FyreworkrColors
                                                                .fyreworkBlack,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    value: value,
                                                  ))
                                              .toList(),
                                          onChanged: (selectedCurrency) {
                                            setState(() {
                                              gigCurrency = selectedCurrency;
                                            });
                                          },
                                          value: gigCurrency,
                                          isExpanded: false,
                                          hint: Text(
                                            'Currency',
                                          ),
                                          validator: (value) =>
                                              value == null ? '*' : null,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.30,
                                      child: TextFormField(
                                        decoration: InputDecoration(
                                            hintText: 'Budget',
                                            border: InputBorder.none,
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    vertical: 7)),
                                        // Only numbers can be entered
                                        keyboardType: TextInputType.number,
                                        inputFormatters: <TextInputFormatter>[
                                          WhitelistingTextInputFormatter
                                              .digitsOnly
                                        ],
                                        onSaved: (value) => gigBudget = value,
                                        validator: (value) =>
                                            value.isEmpty ? '*' : null,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  child: Row(
                                    children: <Widget>[
                                      Radio(
                                          value: 'Gigs I can do',
                                          groupValue: gigValue,
                                          activeColor:
                                              FyreworkrColors.fyreworkBlack,
                                          onChanged: (T) {
                                            setState(() {
                                              gigValue = T;
                                              Gig().gigValue = gigValue;
                                              print("gigValue: $gigValue");
                                            });
                                          }),
                                      Text('Gigs I can do'),
                                    ],
                                  ),
                                ),
                                Container(
                                  child: Row(
                                    children: <Widget>[
                                      Radio(
                                          value: 'I need a provider',
                                          groupValue: gigValue,
                                          activeColor:
                                              FyreworkrColors.fyreworkBlack,
                                          onChanged: (T) {
                                            setState(() {
                                              gigValue = T;
                                              Gig().gigValue = gigValue;
                                              print("gigValue: $gigValue");
                                            });
                                          }),
                                      Text('I need a provider'),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            Container(
                              height: 50,
                              decoration: BoxDecoration(
                                  // border: Border(
                                  //     bottom: BorderSide(
                                  //         color: Colors.grey.shade400)),
                                  ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Checkbox(
                                    value: adultContentBool,
                                    onChanged: (bool value) {
                                      setState(() {
                                        adultContentBool = !adultContentBool;
                                        if (adultContentBool == true) {
                                          adultContentText = "Adult content";
                                        } else {
                                          adultContentText = '';
                                        }
                                      });
                                    },
                                    activeColor: FyreworkrColors.fyreworkBlack,
                                    checkColor: FyreworkrColors.white,
                                  ),
                                  Flexible(
                                      child: Text(
                                          "This is adult content that should not be visible to minors.")),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
        } else {
          return Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Center(child: CircularProgressIndicator()));
        }
      },
    );
  }

  Future saveFormValuesAndPickMediaFiles() async {
    userProfilePictureDownloadUrl =
        await locator.get<UserController>().getProfilePictureDownloadUrl();
    if (gigValue == null) {
      Scaffold.of(context).showSnackBar(_gigValueSnackBar);
    } else if (gigValue != null && _createGigFormKey.currentState.validate()) {
      _createGigFormKey.currentState.save();

      var proceedToMultiAssetPicker = new MaterialPageRoute(
        builder: (BuildContext context) => MultiAssetsPicker(
          appointed: appointed,
          receivedUserId: userId,
          receivedUserProfilePictureDownloadUrl: userProfilePictureDownloadUrl,
          receivedUserFullName: userFullName,
          receivedGigHashtags: gigHashtags,
          receivedGigPost: gigPost,
          receivedGigDeadLine: gigDeadline,
          receivedGigCurrency: gigCurrency,
          receivedGigBudget: gigBudget,
          receivedAdultContentText: adultContentText,
          receivedAdultContentBool: adultContentBool,
          receivedGigValue: gigValue,
        ),
      );
      Navigator.of(context).push(proceedToMultiAssetPicker);
    }
  }
}
