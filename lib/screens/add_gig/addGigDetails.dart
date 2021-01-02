import 'package:flutter/material.dart';
import 'package:myApp/screens/add_gig/assets_picker/pages/multi_assets_picker.dart';
import 'package:myApp/screens/add_gig/sizeConfig.dart';
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
import 'package:sliding_card/sliding_card.dart';

class AddGigDetails extends StatefulWidget {
  // final gigHashtagsController = TextEditingController();
  final Gig edittingGig;
  AddGigDetails({Key key, this.edittingGig, Gig edittinGig}) : super(key: key);

  @override
  _AddGigDetailsState createState() => _AddGigDetailsState();
}

class _AddGigDetailsState extends State<AddGigDetails> {
  final _createGigFormKey = GlobalKey<FormState>();
  SlidingCardController slidingCardController;

  // instantiating GigModel value here to work with...
  String userId;
  String userProfilePictureDownloadUrl;
  String userFullName;

  String gigHashtags;
  String gigPost;
  String gigCurrency;
  dynamic gigBudget;
  String adultContentText;
  bool adultContentBool = false;
  bool appointed = false;

  List<String> _currencies = <String>[
    '€',
    '£',
    '\$',
    'Kr',
  ];

  final _gigValueSnackBar = SnackBar(content: Text('who will do the Gig!!!'));

  void initState() {
    super.initState();
    slidingCardController = SlidingCardController();
  }

  Future saveFormValuesAndPickMediaFiles() async {
    userProfilePictureDownloadUrl =
        await locator.get<UserController>().getProfilePictureDownloadUrl();
    if (AppointmentCard.gigValue == null) {
      Scaffold.of(context).showSnackBar(_gigValueSnackBar);
    } else if (AppointmentCard.gigValue != null &&
        _createGigFormKey.currentState.validate()) {
      _createGigFormKey.currentState.save();

      var proceedToMultiAssetPicker = new MaterialPageRoute(
        builder: (BuildContext context) => MultiAssetsPicker(
          appointed: appointed,
          receivedUserId: userId,
          receivedUserProfilePictureDownloadUrl: userProfilePictureDownloadUrl,
          receivedUserFullName: userFullName,
          receivedGigHashtags: gigHashtags,
          receivedGigPost: gigPost,
          receivedGigDeadLine: AppointmentCard.gigDeadline,
          receivedGigCurrency: gigCurrency,
          receivedGigBudget: gigBudget,
          receivedAdultContentText: adultContentText,
          receivedAdultContentBool: adultContentBool,
          receivedGigValue: AppointmentCard.gigValue,
        ),
      );
      Navigator.of(context).push(proceedToMultiAssetPicker);
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

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
                      title: Padding(
                        padding: const EdgeInsets.all(0),
                        child: Text(
                          'Create Gig',
                          style:
                              TextStyle(color: FyreworkrColors.fyreworkBlack),
                        ),
                      ),
                    ),
                    body: Container(
                      color: Colors.grey[50],
                      child: Form(
                        key: _createGigFormKey,
                        // autovalidate: true,
                        // color: Colors.white,
                        child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: SingleChildScrollView(
                            child: Column(
                              children: <Widget>[
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey.shade400,
                                            width: 1)),
                                  ),
                                  height: 50,
                                  // child: hashtagsTextFormField(),
                                  child: TextFormField(
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.all(0),
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
                                      onSaved: (value) => gigHashtags = value),
                                ),
                                Container(
                                  height: 100,
                                  decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey.shade400,
                                            width: 1)),
                                  ),
                                  child: ListView(
                                    children: <Widget>[
                                      TextFormField(
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.all(0),
                                          border: InputBorder.none,
                                          hintText: 'Describe your gig...',
                                          // hintStyle: TextStyle(fontSize: 14),
                                          fillColor: Colors.transparent,
                                          filled: true,
                                        ),
                                        inputFormatters: [
                                          new LengthLimitingTextInputFormatter(
                                              500),
                                        ],
                                        validator: (value) =>
                                            value.isEmpty ? '*' : null,
                                        onSaved: (value) => gigPost = value,
                                        maxLines: null,
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 10, 10, 10),
                                  child: AppointmentCard(
                                    onCardTapped: () {
                                      if (slidingCardController
                                              .isCardSeparated ==
                                          true) {
                                        slidingCardController.collapseCard();
                                      } else {
                                        slidingCardController.expandCard();
                                      }
                                    },
                                    slidingCardController:
                                        slidingCardController,
                                  ),
                                ),
                                // child: whoWillDoTheGig(context),
                                //configure your rear card here

                                Container(
                                  // height: 100,
                                  decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey.shade400)),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        0, 10, 10, 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Container(
                                          width: 100,
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButtonFormField(
                                              dropdownColor: Theme.of(context)
                                                  .primaryColor,
                                              decoration: InputDecoration(
                                                border: InputBorder.none,
                                                focusedBorder: InputBorder.none,
                                                enabledBorder: InputBorder.none,
                                                errorBorder: InputBorder.none,
                                                disabledBorder:
                                                    InputBorder.none,
                                              ),
                                              items: _currencies
                                                  .map((value) =>
                                                      DropdownMenuItem(
                                                        child: Container(
                                                          width: 25,
                                                          height: 25,
                                                          decoration:
                                                              BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
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
                                                  gigCurrency =
                                                      selectedCurrency;
                                                });
                                              },
                                              value: gigCurrency,
                                              isExpanded: false,
                                              hint: Text(
                                                'Currency',
                                                style: TextStyle(fontSize: 17),
                                              ),
                                              validator: (value) =>
                                                  value == null ? '*' : null,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.fromLTRB(
                                              0,
                                              0,
                                              MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  6,
                                              0),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              3,
                                          child: TextFormField(
                                            decoration: InputDecoration(
                                              hintText: 'Budget',
                                              border: InputBorder.none,
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      vertical: 7),
                                            ),
                                            // Only numbers can be entered
                                            keyboardType: TextInputType.number,
                                            inputFormatters: <
                                                TextInputFormatter>[
                                              WhitelistingTextInputFormatter
                                                  .digitsOnly
                                            ],
                                            onSaved: (value) =>
                                                gigBudget = value,
                                            validator: (value) =>
                                                value.isEmpty ? '*' : null,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                      // border: Border(
                                      //     bottom: BorderSide(
                                      //         color: Colors.grey.shade400)),
                                      ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      SizedBox(
                                        width: 20,
                                        child: Checkbox(
                                          materialTapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                          value: adultContentBool,
                                          onChanged: (bool value) {
                                            setState(() {
                                              adultContentBool =
                                                  !adultContentBool;
                                              if (adultContentBool == true) {
                                                adultContentText =
                                                    "Adult content";
                                              } else {
                                                adultContentText = '';
                                              }
                                            });
                                          },
                                          activeColor:
                                              FyreworkrColors.fyreworkBlack,
                                          checkColor: FyreworkrColors.white,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Flexible(
                                        child: Text(
                                          "Adult content that should not be visible to minors.",
                                          style: TextStyle(
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
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
    );
  }

  @override
  void dispose() {
    // Additional disposal code
    super.dispose();
  }
}

//Appointment card
class AppointmentCard extends StatefulWidget {
  AppointmentCard({
    Key key,
    this.slidingCardController,
    @required this.onCardTapped,
  }) : super(key: key);

  final SlidingCardController slidingCardController;
  final Function onCardTapped;

  static String gigValue;
  static dynamic gigDeadline =
      new DateFormat.yMMMd().format(new DateTime.now().add(Duration(days: 30)));

  @override
  _AppointmentCardState createState() => _AppointmentCardState();
}

class _AppointmentCardState extends State<AppointmentCard> {
  TextEditingController _deadLineController = new TextEditingController();

  DateTime _initialDeadline = new DateTime.now().add(Duration(days: 30));
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
            primaryColor: Theme.of(context).primaryColor, //Head background
            // accentColor: Colors.white //selection color
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
  Widget build(BuildContext context) {
    String _formattedDate = new DateFormat.yMMMd().format(_initialDeadline);

    _deadLineController.value = new TextEditingValue(
      text: _formattedDate,
      selection: TextSelection.fromPosition(
        TextPosition(offset: _formattedDate.length),
      ),
    );

    return SlidingCard(
      slimeCardElevation: 0.5,
      // slidingAnimationReverseCurve: Curves.bounceInOut,
      cardsGap: SizeConfig.safeBlockVertical,
      controller: widget.slidingCardController,
      slidingCardWidth: SizeConfig.horizontalBloc * 90,
      visibleCardHeight: SizeConfig.safeBlockVertical * 17,
      hiddenCardHeight: SizeConfig.safeBlockVertical * 15,
      frontCardWidget: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: 20,
                  child: Radio(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    value: 'I need a provider',
                    groupValue: AppointmentCard.gigValue,
                    activeColor: Theme.of(context).primaryColor,
                    onChanged: (T) {
                      widget.onCardTapped();
                      setState(() {
                        AppointmentCard.gigValue = T;
                        AppointmentCard.gigDeadline = _formattedDate;
                        print('deadline: ${AppointmentCard.gigDeadline}');
                        // Gig().gigValue = gigValue;
                      });
                    },
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  'I need a provider',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 17,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width / 3,
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: 20,
                  child: Radio(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      value: 'Gigs I can do',
                      groupValue: AppointmentCard.gigValue,
                      activeColor: Theme.of(context).primaryColor,
                      onChanged: (T) {
                        widget.slidingCardController.collapseCard();
                        setState(() {
                          AppointmentCard.gigValue = T;
                          AppointmentCard.gigDeadline = null;
                          print('deadline: ${AppointmentCard.gigDeadline}');
                          // Gig().gigValue = gigValue;
                        });
                      }),
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  'Gigs I can do',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 17,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      backCardWidget: Container(
        // height: 100,
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey.shade400)),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.40,
                child: ButtonTheme(
                  padding: EdgeInsets.all(0),
                  child: FlatButton(
                    onPressed: () {
                      _selectedDate(context);
                    },
                    child: TextFormField(
                      style: TextStyle(color: Colors.grey, fontSize: 17),
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
                          AppointmentCard.gigDeadline = deadline;
                        });
                      },
                      onSaved: (value) => AppointmentCard.gigDeadline != null
                          ? AppointmentCard.gigDeadline = value
                          : AppointmentCard.gigDeadline = null,
                    ),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width / 3,
                child: Text(
                  'Deadline',
                  style: TextStyle(fontSize: 17, color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Additional disposal code
    _deadLineController.dispose();
    AppointmentCard.gigValue = null;
    AppointmentCard.gigDeadline = null;
    super.dispose();
  }
}
