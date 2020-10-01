import 'package:flutter/material.dart';
import 'package:myApp/ui/shared/theme.dart';
import 'package:myApp/ui/widgets/provider_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import '../../models/Gig_model.dart';
import 'package:intl/intl.dart';

import 'package:myApp/models/gig.dart';
import 'package:myApp/viewmodels/create_gig_view_model.dart';
import 'package:provider_architecture/provider_architecture.dart';

import '../../ui/shared/theme.dart';

// Numeric input
// class NumberInputField extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     return new NumberInputFieldState();
//   }
// }

// class NumberInputFieldState extends State<NumberInputField> {
//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       decoration: InputDecoration(
//           hintText: 'Budget',
//           border: InputBorder.none,
//           contentPadding: EdgeInsets.symmetric(vertical: 7)),
//       keyboardType: TextInputType.number,
//       inputFormatters: <TextInputFormatter>[
//         WhitelistingTextInputFormatter.digitsOnly
//       ], // Only numbers can be entered
//     );
//   }
// }

class AddGigDetails extends StatefulWidget {
  // final gigHashtagsController = TextEditingController();
  final Gig edittingGig;
  AddGigDetails({Key key, this.edittingGig, Gig edittinGig}) : super(key: key);

  @override
  _AddGigDetailsState createState() => _AddGigDetailsState();
}

class _AddGigDetailsState extends State<AddGigDetails> {
  final _formKey = GlobalKey<FormState>();

  // instantiating GigModel value here to work with...
  // String uid = UserController().getPreferencesUserUid();
  String userId;
  // String userProfilePictureUrl = UserController().avatarUrl;
  // String userFullName = UserController().getPreferencesUserFullName();
  String userFullName;

  String gigHashtags;
  String gigPost;
  dynamic gigDeadline;
  String gigCurrency;
  dynamic gigBudget;
  String gigValue;
  String adultContentText = Gig().adultContentText;
  bool adultContentBool = Gig().adultContentBool;

  DateTime _currentDate = new DateTime.now().add(Duration(days: 30));
  TextEditingController _deadLineController = new TextEditingController();

  List<String> _currency = <String>[
    '€',
    '£',
    '\$',
    'Kr',
  ];

  final _gigValueSnackBar = SnackBar(content: Text('who will do the Gig!!!'));

  // Specifying the deadline date
  Future<Null> _selectedDate(BuildContext context) async {
    final DateTime _deadLine = await showDatePicker(
      context: context,
      initialDate: _currentDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2022),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.dark().copyWith(
              // primarySwatch: buttonTextColor,//OK/Cancel button text color
              primaryColor: FyreworkrColors.fyreworkBlack, //Head background
              accentColor: Colors.white //selection color
              //dialogBackgroundColor: Colors.white,//Background color
              ),
          child: child,
        );
      },
    );

    if (_deadLine != null) {
      setState(() {
        _currentDate = _deadLine;
        GigModel().gigDeadLine = _currentDate;
      });
    } else {
      setState(() {
        _currentDate = DateTime.now();
        GigModel().gigDeadLine = _currentDate;
      });
    }
  }

  // TextFormField hashtagsTextFormField() {
  //   return TextFormField(
  //     decoration: InputDecoration(
  //       border: InputBorder.none,
  //       hintText: '#Hashtags',
  //       fillColor: Colors.white,
  //       filled: true,
  //     ),
  //     validator: (value) {
  //       if (value.isEmpty) {
  //         return 'at least one Hashtag required';
  //       }
  //     },
  //     onSaved: (value) => hashtags = value,
  //   );
  // }

  // TextFormField gigPostTextFormField() {
  //   return TextFormField(
  //     decoration: InputDecoration(
  //       border: InputBorder.none,
  //       hintText: 'Gig Post',
  //       fillColor: Colors.white,
  //       filled: true,
  //     ),
  //     validator: (value) {
  //       if (value.isEmpty) {
  //         return 'Gig post required';
  //       }
  //     },
  //     onSaved: (value) => gigPost = value,
  //   );
  // }

  @override
  void dispose() {
    // Additional disposal code

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String _formattedDate = new DateFormat.yMMMd().format(_currentDate);

    _deadLineController.value = new TextEditingValue(
      text: _formattedDate == null ? _currentDate : '$_formattedDate',
      selection: TextSelection.fromPosition(
        TextPosition(offset: _formattedDate.length),
      ),
    );

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder(
              future: Provider.of(context).auth.getCurrentUser(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return snapshot.data.isAnonymous
                      ? Container(
                          child: Text(
                              'You are an Anonymous user in the mean timeeeeeeee'),
                        )
                      : ViewModelProvider<CreateGigViewModel>.withConsumer(
                          viewModel: CreateGigViewModel(),
                          // onModelReady: (model) {
                          // update the text in the controller
                          // widget.gigHashtagsController.text =
                          //     widget.edittingGig?.gigHashtags ?? '';

                          // model.setEdittingGig(widget.edittingGig);
                          // },
                          builder: (context, model, child) => Scaffold(
                            backgroundColor: Colors.white,
                            appBar: AppBar(
                              iconTheme: IconThemeData(
                                  color: FyreworkrColors
                                      .fyreworkBlack //change your color here
                                  ),
                              // leading: IconButton(
                              //     icon: Icon(
                              //       Icons.arrow_back,
                              //       color: FyreworkrColors.fyreworkBlack,
                              //     ),
                              //     onPressed: () {}),
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
                                        await saveFormValues();
                                        model.addGig(
                                          userId: userId,
                                          // userProfilePictureUrl,
                                          userFullName: userFullName,
                                          gigHashtags: gigHashtags,
                                          gigPost: gigPost,
                                          gigDeadLine: gigDeadline,
                                          gigCurrency: gigCurrency,
                                          gigBudget: gigBudget,
                                          gigValue: gigValue,
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                              backgroundColor: FyreworkrColors.white,
                              title: Center(
                                child: Text(
                                  'Create Gig',
                                  style: TextStyle(
                                      color: FyreworkrColors.fyreworkBlack),
                                ),
                              ),
                            ),
                            body: Form(
                              key: _formKey,
                              // autovalidate: true,
                              // color: Colors.white,
                              child: Padding(
                                padding: EdgeInsets.all(20.0),
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        // height: 60,
                                        decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: Colors.grey.shade400,
                                                  width: 1)),
                                        ),
                                        child: Container(
                                          height: 60,
                                          // child: hashtagsTextFormField(),
                                          child: TextFormField(
                                              decoration: InputDecoration(
                                                border: InputBorder.none,
                                                hintText: '#Hashtags',
                                                fillColor: Colors.transparent,
                                                filled: true,
                                              ),
                                              inputFormatters: [
                                                new LengthLimitingTextInputFormatter(
                                                    50),
                                              ],
                                              validator: (value) =>
                                                  value.isEmpty ? '*' : null,
                                              onSaved: (value) =>
                                                  gigHashtags = value),
                                        ),
                                      ),
                                      Container(
                                        height: 120,
                                        decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: Colors.grey.shade400,
                                                  width: 1)),
                                        ),
                                        child: Container(
                                          height: 120,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              TextFormField(
                                                decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  hintText: 'Gig Post',
                                                  fillColor: Colors.transparent,
                                                  filled: true,
                                                ),
                                                inputFormatters: [
                                                  new LengthLimitingTextInputFormatter(
                                                      500),
                                                ],
                                                validator: (value) =>
                                                    value.isEmpty ? '*' : null,
                                                onSaved: (value) =>
                                                    gigPost = value,
                                                maxLines: null,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 100,
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
                                                  style:
                                                      TextStyle(fontSize: 18)),
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.40,
                                                child: FlatButton(
                                                  onPressed: () {
                                                    _selectedDate(context);
                                                  },
                                                  child: TextFormField(
                                                    enabled: false,
                                                    controller:
                                                        _deadLineController,
                                                    decoration: InputDecoration(
                                                      border: InputBorder.none,
                                                      focusedBorder:
                                                          InputBorder.none,
                                                      enabledBorder:
                                                          InputBorder.none,
                                                      errorBorder:
                                                          InputBorder.none,
                                                      disabledBorder:
                                                          InputBorder.none,
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
                                              // Container(
                                              //   child: FlatButton(
                                              //     child: Text('DD/MM/YYYY',
                                              //         style: TextStyle(
                                              //             fontSize: 16, color: Colors.grey)),
                                              //     onPressed: () {
                                              //       _selectedDate(context);
                                              //     },
                                              //   ),
                                              // )
                                            ],
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 100,
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
                                                child: Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.30,
                                                  height: 100,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      DropdownButtonHideUnderline(
                                                        child:
                                                            DropdownButtonFormField(
                                                          dropdownColor:
                                                              FyreworkrColors
                                                                  .fyreworkBlack,
                                                          decoration:
                                                              InputDecoration(
                                                            border: InputBorder
                                                                .none,
                                                            focusedBorder:
                                                                InputBorder
                                                                    .none,
                                                            enabledBorder:
                                                                InputBorder
                                                                    .none,
                                                            errorBorder:
                                                                InputBorder
                                                                    .none,
                                                            disabledBorder:
                                                                InputBorder
                                                                    .none,
                                                          ),
                                                          items: _currency
                                                              .map((value) =>
                                                                  DropdownMenuItem(
                                                                    child: Text(
                                                                      value,
                                                                      style: TextStyle(
                                                                          color:
                                                                              FyreworkrColors.white),
                                                                    ),
                                                                    value:
                                                                        value,
                                                                  ))
                                                              .toList(),
                                                          onChanged:
                                                              (selectedCurrency) {
                                                            setState(() {
                                                              gigCurrency =
                                                                  selectedCurrency;
                                                            });
                                                          },
                                                          value: gigCurrency,
                                                          isExpanded: false,
                                                          hint: Text(
                                                            'Currency',
                                                          ),
                                                          validator: (value) =>
                                                              value == null
                                                                  ? '*'
                                                                  : null,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.30,
                                                height: 100,
                                                // child: NumberInputField(),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    TextFormField(
                                                      decoration: InputDecoration(
                                                          hintText: 'Budget',
                                                          border: InputBorder
                                                              .none,
                                                          contentPadding:
                                                              EdgeInsets
                                                                  .symmetric(
                                                                      vertical:
                                                                          7)),
                                                      // Only numbers can be entered
                                                      keyboardType:
                                                          TextInputType.number,
                                                      inputFormatters: <
                                                          TextInputFormatter>[
                                                        WhitelistingTextInputFormatter
                                                            .digitsOnly
                                                      ],
                                                      onSaved: (value) =>
                                                          gigBudget = value,
                                                      validator: (value) =>
                                                          value.isEmpty
                                                              ? '*'
                                                              : null,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Container(
                                              child: Row(
                                                children: <Widget>[
                                                  Radio(
                                                      value: 'Gigs I can do',
                                                      groupValue: gigValue,
                                                      activeColor:
                                                          FyreworkrColors
                                                              .fyreworkBlack,
                                                      onChanged: (T) {
                                                        setState(() {
                                                          gigValue = T;
                                                          Gig().gigValue =
                                                              gigValue;
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
                                                      value:
                                                          'I need a provider',
                                                      groupValue: gigValue,
                                                      activeColor:
                                                          FyreworkrColors
                                                              .fyreworkBlack,
                                                      onChanged: (T) {
                                                        setState(() {
                                                          gigValue = T;
                                                          Gig().gigValue =
                                                              gigValue;
                                                        });
                                                      }),
                                                  Text('I need a provider'),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Container(
                                        height: 50,
                                        decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: Colors.grey.shade400)),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Checkbox(
                                                value: adultContentBool,
                                                onChanged: (bool value) {
                                                  setState(() {
                                                    adultContentBool =
                                                        !adultContentBool;
                                                  });
                                                },
                                                activeColor: FyreworkrColors
                                                    .fyreworkBlack,
                                                checkColor:
                                                    FyreworkrColors.white,
                                              ),
                                              Flexible(
                                                  child:
                                                      Text(adultContentText)),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
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
            ),
          ],
        ),
      ),
    );
  }

  Future saveFormValues() async {
    if (gigValue == null) {
      Scaffold.of(context).showSnackBar(_gigValueSnackBar);
    } else if (gigValue != null && _formKey.currentState.validate()) {
      _formKey.currentState.save();
      print('$userFullName');
      print('$gigHashtags');
      print('$gigPost');
      print('$gigDeadline');
      print('$gigCurrency');
      print('$gigBudget');
      print('$gigValue');

      // var proceedToMultiAssetPicker = new MaterialPageRoute(
      //   builder: (BuildContext context) => MultiAssetsPicker(
      //     receivedGigHashtags: gigHashtags,
      //     receivedGigPost: gigPost,
      //     receivedGigDeadLine: gigDeadline,
      //     receivedGigCurrency: gigCurrency,
      //     receivedGigBudget: gigBudget,
      //     receivedAdultContentBool: adultContentBool,
      //     receivedGigValue: gigValue,
      //   ),
      // );
      // Navigator.of(context).push(proceedToMultiAssetPicker);
    }
  }
}
