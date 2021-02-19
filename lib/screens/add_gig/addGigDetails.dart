import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:Fyrework/models/myUser.dart';
import 'package:Fyrework/screens/add_gig/assets_picker/pages/multi_assets_picker.dart';
import 'package:Fyrework/screens/add_gig/sizeConfig.dart';
import 'package:Fyrework/services/places_autocomplete.dart';
import 'package:Fyrework/ui/shared/constants.dart';
import 'package:Fyrework/ui/shared/fyreworkTheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:Fyrework/models/gig.dart';
import 'package:Fyrework/viewmodels/create_gig_view_model.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:sliding_card/sliding_card.dart';
import 'package:Fyrework/services/popularHashtags.dart';

class AddGigDetails extends StatefulWidget {
  // final gigHashtagsController = TextEditingController();
  final Gig edittingGig;
  AddGigDetails({Key key, this.edittingGig, Gig edittinGig}) : super(key: key);

  @override
  _AddGigDetailsState createState() => _AddGigDetailsState();
}

TextEditingController locationController = TextEditingController();
SlidingCardController slidingCardController;
TextEditingController typeAheadController = TextEditingController();

class _AddGigDetailsState extends State<AddGigDetails> {
  @override
  void initState() {
    super.initState();
    slidingCardController = SlidingCardController();
  }

  String _userId = MyUser.uid;
  String _userProfilePictureDownloadUrl = MyUser.userAvatarUrl;
  String _username = MyUser.name;
  String _userLocation = MyUser.location;

  final _createGigFormKey = GlobalKey<FormState>();
  List _myFavoriteHashtags = List();

  TextEditingController _myFavoriteHashtagsController = TextEditingController();
  ScrollController scrollController = ScrollController();

  String _gigLocation;

  // instantiating GigModel value here to work with...
  String _gigPost;
  String _gigCurrency;
  dynamic _gigBudget;
  String _adultContentText;
  bool _adultContentBool = false;
  bool _appointed = false;

  String clientSideWarning;

  List<String> _currencies = <String>[
    'AUD',
    'BRL',
    'CAD',
    'CZK',
    'DKK',
    'EUR',
    'HKD',
    'HUF',
    'ILS',
    'JPY',
    'MYR',
    'MXN',
    'NOK',
    'NZD',
    'PHP',
    'PLN',
    'GBP',
    'RUB',
    'SGD',
    'SEK',
    'CHF',
    'TWD',
    'THB',
    'TRY',
    'USD',
  ];

  final _gigValueSnackBar = SnackBar(
    content: Text(
      'who will do the Gig!!!',
      style: TextStyle(fontSize: 16),
    ),
  );

  Future saveFormValuesAndPickMediaFiles() async {
    _gigLocation = PlacesAutocomplete.placesAutoCompleteController.text;
    _userProfilePictureDownloadUrl = MyUser.userAvatarUrl;
    if (AppointmentCard.gigValue == null) {
      Scaffold.of(context).showSnackBar(_gigValueSnackBar);
    } else if (AppointmentCard.gigValue != null &&
        _createGigFormKey.currentState.validate()) {
      _createGigFormKey.currentState.save();

      var proceedToMultiAssetPicker = new MaterialPageRoute(
        builder: (BuildContext context) => MultiAssetsPicker(
          appointed: _appointed,
          userId: _userId,
          userProfilePictureDownloadUrl: _userProfilePictureDownloadUrl,
          username: _username,
          userLocation: _userLocation,
          gigLocation: _gigLocation,
          gigHashtags: _myFavoriteHashtags,
          gigPost: _gigPost,
          gigDeadLine: AppointmentCard.gigDeadline != null
              ? (AppointmentCard.gigDeadline.toUtc().millisecondsSinceEpoch)
              : AppointmentCard.gigDeadline,
          gigCurrency: _gigCurrency,
          gigBudget: _gigBudget,
          adultContentText: _adultContentText,
          adultContentBool: _adultContentBool,
          gigValue: AppointmentCard.gigValue,
        ),
      );
      Navigator.of(context).push(proceedToMultiAssetPicker);
    }
  }

  getUserLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemarks = await Geolocator()
        .placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark placemark = placemarks[0];
    // String completeAddress =
    //     '${placemark.subThoroughfare} ${placemark.thoroughfare}, ${placemark.subLocality} ${placemark.locality}, ${placemark.subAdministrativeArea}, ${placemark.administrativeArea} ${placemark.postalCode}, ${placemark.country}';
    // print(completeAddress);
    String formattedAddress = "${placemark.locality}, ${placemark.country}";
    setState(() {
      // locationController.text = formattedAddress;
      PlacesAutocomplete.placesAutoCompleteController.text = formattedAddress;
      print(
          'PlacesAutocomplete().placesAutoCompleteController.text: ${PlacesAutocomplete.placesAutoCompleteController.text}');
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Container(
      child: ViewModelProvider<CreateGigViewModel>.withConsumer(
        viewModelBuilder: () {
          return CreateGigViewModel();
        },
        builder: (context, model, child) => GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.grey[50],
              iconTheme: IconThemeData(
                  color: Theme.of(context).primaryColor //change your color here
                  ),
              actions: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 10, 15, 10),
                  child: OutlineButton(
                    borderSide:
                        BorderSide(color: Theme.of(context).primaryColor),
                    child: Text('Next',
                        style: Theme.of(context).textTheme.bodyText1),
                    onPressed: () async {
                      await saveFormValuesAndPickMediaFiles();
                    },
                  ),
                ),
              ],
              title: Padding(
                padding: const EdgeInsets.all(0),
                child: Text(
                  'Create Gig',
                  style: Theme.of(context).textTheme.headline1,
                ),
              ),
            ),
            body: Container(
              color: Colors.grey[50],
              child: Form(
                key: _createGigFormKey,
                // autovalidate: true,
                // color: Colors.white,
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    children: <Widget>[
                      clientSideAlert(),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Flex(
                          direction: Axis.vertical,
                          children: [
                            Container(
                              width: double.infinity,
                              child: Wrap(
                                children: _myFavoriteHashtags
                                    .map((e) => Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 0, 2.5, 2.5),
                                          child: Chip(
                                            materialTapTargetSize:
                                                MaterialTapTargetSize
                                                    .shrinkWrap,
                                            backgroundColor: Colors.black,
                                            label: Text(
                                              '$e',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1
                                                  .copyWith(
                                                      color: Colors.white),
                                            ),
                                            onDeleted: () {
                                              setState(() {
                                                _myFavoriteHashtags.removeWhere(
                                                    (item) => item == e);
                                                print(
                                                    _myFavoriteHashtags.length);
                                              });
                                            },
                                            deleteIconColor: Colors.white,
                                          ),
                                        ))
                                    .toList(),
                              ),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: TypeAheadFormField(
                                    validator: (value) =>
                                        _myFavoriteHashtags.length < 1
                                            ? ''
                                            : null,
                                    // onSaved: (value) => _myHashtag = value,
                                    textFieldConfiguration:
                                        TextFieldConfiguration(
                                      controller: _myFavoriteHashtagsController,
                                      // style: TextStyle(fontSize: 16),
                                      inputFormatters: [
                                        new LengthLimitingTextInputFormatter(
                                            20),
                                        FilteringTextInputFormatter.allow(
                                            RegExp("[a-z0-9_]")),
                                      ],

                                      decoration: buildSignUpInputDecoration(
                                          context, 'Favorite #Hashtags'),
                                    ),
                                    suggestionsCallback: (pattern) async {
                                      return await PopularHashtagsService
                                          .fetchPopularHashtags(pattern);
                                    },
                                    itemBuilder: (context, suggestions) {
                                      return ListTile(
                                        title: Text(suggestions),
                                      );
                                    },
                                    onSuggestionSelected: (suggestion) {
                                      // _myHashtagController.text = suggestion;
                                      // _myHashtag = suggestion;
                                      if (_myFavoriteHashtags.length < 20 !=
                                          true) {
                                        setState(() {
                                          clientSideWarning =
                                              'Only 20 #Hashtags allowed';
                                        });
                                      } else if (_myFavoriteHashtags
                                          .contains(suggestion)) {
                                        setState(() {
                                          clientSideWarning =
                                              'Duplicate #Hashtags are not allowed';
                                        });
                                        _myFavoriteHashtagsController.clear();
                                      } else if (!_myFavoriteHashtags
                                              .contains(suggestion) &&
                                          _myFavoriteHashtags.length < 20) {
                                        setState(() {
                                          _myFavoriteHashtags.add(suggestion);
                                          _myFavoriteHashtagsController.clear();
                                          print(_myFavoriteHashtags);
                                        });
                                      }
                                    },
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 5, 10, 0),
                                  child: GestureDetector(
                                    child: Text(
                                      'Add',
                                      style: TextStyle(
                                        shadows: [
                                          Shadow(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              offset: Offset(0, -2.5))
                                        ],
                                        fontSize: 14,
                                        color: Colors.transparent,
                                        decoration: TextDecoration.underline,
                                        decorationThickness: 2,
                                        decorationColor:
                                            Theme.of(context).primaryColor,
                                        decorationStyle:
                                            TextDecorationStyle.dotted,
                                      ),
                                    ),
                                    onTap: () {
                                      if (_myFavoriteHashtags.length < 20 !=
                                          true) {
                                        setState(() {
                                          clientSideWarning =
                                              'Only 20 #Hashtags allowed';
                                          _myFavoriteHashtagsController.clear();
                                        });
                                      } else if (_myFavoriteHashtags.contains(
                                          '#' +
                                              _myFavoriteHashtagsController
                                                  .text)) {
                                        setState(() {
                                          clientSideWarning =
                                              'Duplicate #Hashtags are not allowed';
                                        });
                                        _myFavoriteHashtagsController.clear();
                                      } else if (_myFavoriteHashtagsController
                                              .text.isNotEmpty &&
                                          !_myFavoriteHashtags.contains('#' +
                                              _myFavoriteHashtagsController
                                                  .text) &&
                                          _myFavoriteHashtags.length < 20) {
                                        setState(() {
                                          _myFavoriteHashtags.add('#' +
                                              _myFavoriteHashtagsController
                                                  .text);
                                          _myFavoriteHashtagsController.clear();
                                          FocusScope.of(context).unfocus();
                                          print(_myFavoriteHashtags);
                                        });
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(0, 8.0, 0, 8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  PlacesAutocomplete(
                                    signUpDecoraiton: true,
                                  ),
                                  IconButton(
                                    color: Theme.of(context).primaryColor,
                                    onPressed: () {
                                      getUserLocation();
                                    },
                                    icon: Icon(Icons.gps_fixed),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
                              child: TextFormField(
                                decoration: buildSignUpInputDecoration(
                                    context, 'Describe your gig...'),
                                inputFormatters: [
                                  new LengthLimitingTextInputFormatter(500),
                                ],
                                validator: (value) =>
                                    value.isEmpty ? '*' : null,
                                onSaved: (value) => _gigPost = value,
                                maxLines: null,
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Colors.black26, width: 0.5))),
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 10, 10, 10),
                                child: AppointmentCard(
                                  onCardTapped: () {
                                    if (slidingCardController.isCardSeparated ==
                                        true) {
                                      slidingCardController.collapseCard();
                                    } else {
                                      slidingCardController.expandCard();
                                    }
                                  },
                                  slidingCardController: slidingCardController,
                                ),
                              ),
                            ),
                            Container(
                              // height: 100,
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Colors.black26, width: 0.5))),
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 10, 10, 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Container(
                                      width: 100,
                                      child: DropdownButtonHideUnderline(
                                        child: Container(
                                          child: DropdownButtonFormField(
                                            // dropdownColor: Theme.of(context)
                                            //     .primaryColor,
                                            dropdownColor:
                                                Theme.of(context).primaryColor,
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              focusedBorder: InputBorder.none,
                                              enabledBorder: InputBorder.none,
                                              errorBorder: InputBorder.none,
                                              disabledBorder: InputBorder.none,
                                            ),
                                            items: _currencies
                                                .map((value) =>
                                                    DropdownMenuItem(
                                                      child: Container(
                                                        width: 40,
                                                        height: 40,
                                                        decoration:
                                                            BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          color: Colors.white,
                                                        ),
                                                        child: Center(
                                                            child:
                                                                TextFormField(
                                                          enabled: false,
                                                          decoration: buildSignUpInputDecoration(
                                                                  context,
                                                                  value)
                                                              .copyWith(
                                                                  enabledBorder:
                                                                      InputBorder
                                                                          .none),
                                                        )),
                                                      ),
                                                      value: value,
                                                    ))
                                                .toList(),
                                            onChanged: (selectedCurrency) {
                                              setState(() {
                                                _gigCurrency = selectedCurrency;
                                              });
                                            },
                                            value: _gigCurrency,
                                            isExpanded: false,
                                            hint: Text('Currency',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .caption),
                                            validator: (value) =>
                                                value == null ? '*' : null,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.fromLTRB(
                                          0,
                                          0,
                                          MediaQuery.of(context).size.width / 6,
                                          0),
                                      width:
                                          MediaQuery.of(context).size.width / 3,
                                      child: TextFormField(
                                        decoration: buildSignUpInputDecoration(
                                                context, 'Budget')
                                            .copyWith(
                                                enabledBorder:
                                                    InputBorder.none),
                                        // Only numbers can be entered
                                        keyboardType: TextInputType.number,
                                        inputFormatters: <TextInputFormatter>[
                                          WhitelistingTextInputFormatter
                                              .digitsOnly
                                        ],
                                        onSaved: (value) => _gigBudget = value,
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
                              decoration: BoxDecoration(),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(
                                    width: 20,
                                    child: Checkbox(
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      value: _adultContentBool,
                                      onChanged: (bool value) {
                                        setState(() {
                                          _adultContentBool =
                                              !_adultContentBool;
                                          if (_adultContentBool == true) {
                                            _adultContentText = "Adult content";
                                          } else {
                                            _adultContentText = '';
                                          }
                                        });
                                      },
                                      activeColor:
                                          Theme.of(context).primaryColor,
                                      checkColor: Theme.of(context).accentColor,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Flexible(
                                    child: Text(
                                        "Adult content that should not be visible to minors.",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6),
                                  ),
                                ],
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
      ),
    );
  }

  Widget clientSideAlert() {
    if (clientSideWarning != null) {
      scrollController.animateTo(0,
          duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
      return Container(
        color: Theme.of(context).primaryColor,
        width: double.infinity,
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(
                Icons.error_outline,
                color: Colors.white,
              ),
            ),
            Expanded(
              child: Text(
                clientSideWarning,
                maxLines: 3,
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: IconButton(
                icon: Icon(
                  Icons.close,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    clientSideWarning = null;
                  });
                },
              ),
            )
          ],
        ),
      );
    }
    return SizedBox(
      height: 0,
    );
  }

  @override
  void dispose() {
    // Additional disposal code
    // _gigLocationController.dispose();
    // typeAheadController.dispose();
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
  // static dynamic gigDeadline = new DateFormat('yyyy-MM-dd')
  //     .format(new DateTime.now().add(Duration(days: 30)));
  static DateTime gigDeadline = new DateTime.now().add(Duration(days: 30));

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

    return Padding(
      padding: MediaQuery.of(context).orientation == Orientation.landscape
          ? EdgeInsets.only(bottom: 30)
          : EdgeInsets.zero,
      child: SlidingCard(
        slimeCardElevation: 0,
        // slidingAnimationReverseCurve: Curves.bounceInOut,
        cardsGap: SizeConfig.safeBlockVertical,
        controller: widget.slidingCardController,
        slidingCardWidth: SizeConfig.horizontalBloc * 90,
        visibleCardHeight: SizeConfig.safeBlockVertical * 17,
        hiddenCardHeight: SizeConfig.safeBlockVertical * 15,
        frontCardWidget: Container(
          color: Colors.grey[50],
          child: Row(
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
                            // AppointmentCard.gigDeadline = _formattedDate;
                            AppointmentCard.gigDeadline =
                                new DateTime.now().add(Duration(days: 30));

                            // Gig().gigValue = gigValue;
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text('I need a provider',
                        style: Theme.of(context).textTheme.caption),
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
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          value: 'Gig I can do',
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
                    Text('Gig I can do',
                        style: Theme.of(context).textTheme.caption),
                  ],
                ),
              ),
            ],
          ),
        ),
        backCardWidget: Container(
          color: Colors.grey[50],
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.40,
                  child: ButtonTheme(
                    padding: EdgeInsets.all(0),
                    child: GestureDetector(
                      onTap: () {
                        _selectedDate(context);
                      },
                      child: Text('${AppointmentCard.gigDeadline}',
                          style: Theme.of(context).textTheme.caption),
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 3,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      'Deadline',
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Additional disposal code
    AppointmentCard.gigValue = null;
    AppointmentCard.gigDeadline = null;
    _deadLineController.dispose();
    super.dispose();
  }
}
