import 'dart:async';
import 'dart:core';
import 'package:Fyrework/services/database.dart';
import 'package:Fyrework/services/places_autocomplete.dart';
import 'package:Fyrework/services/popularHashtags.dart';
import 'package:Fyrework/ui/shared/constants.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:Fyrework/screens/add_gig/assets_picker/src/constants/constants.dart';
import 'package:Fyrework/services/firestore_service.dart';
import 'package:Fyrework/ui/widgets/gig_item_media_previewer.dart';
import 'package:geolocator/geolocator.dart';
import 'package:timeago/timeago.dart' as timeAgo;

class EditYourGig extends StatefulWidget {
  final gigId;
  final currentUserId;
  final gigOwnerId;
  final gigOwnerEmail;
  final gigOwnerAvatarUrl;
  final gigOwnerUsername;
  final gigTime;
  final gigOwnerLocation;
  final gigLocation;
  final gigHashtags;
  final gigMediaFilesDownloadUrls;
  final gigPost;
  final gigDeadline;
  final gigCurrency;
  final gigBudget;
  final gigValue;
  final adultContentText;
  final adultContentBool;

  EditYourGig({
    Key key,
    @required this.gigId,
    @required this.currentUserId,
    @required this.gigOwnerId,
    @required this.gigOwnerEmail,
    @required this.gigOwnerAvatarUrl,
    @required this.gigOwnerUsername,
    @required this.gigTime,
    @required this.gigOwnerLocation,
    @required this.gigLocation,
    @required this.gigHashtags,
    @required this.gigMediaFilesDownloadUrls,
    @required this.gigPost,
    @required this.gigDeadline,
    @required this.gigCurrency,
    @required this.gigBudget,
    @required this.gigValue,
    @required this.adultContentText,
    @required this.adultContentBool,
  }) : super(key: key);
  @override
  _EditYourGigState createState() => _EditYourGigState();
}

class _EditYourGigState extends State<EditYourGig> {
  final _editYourGigFormKey = GlobalKey<FormState>();
  ScrollController scrollController = ScrollController();
  String clientSideWarning;

  TextEditingController _myFavoriteHashtagsController = TextEditingController();
  TextEditingController _editedGigPostController = TextEditingController();
  TextEditingController _editedBudgetController = TextEditingController();

  String _editedGigLocation;
  DateTime _editedGigDeadline;
  String _editedGigCurrency;
  String _editedGigBudget;
  List _myEditedFavoriteHashtags = List();
  String _editedGigPost;

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
  final String mapMarkerAlt = 'assets/svgs/light/map-marker-alt.svg';
  final String hourglassStart = 'assets/svgs/light/hourglass-start.svg';
  @override
  void initState() {
    super.initState();

    _editedGigDeadline = widget.gigDeadline != null
        ? DateTime.fromMillisecondsSinceEpoch(widget.gigDeadline)
        : null;
    // widget.gigDeadline != null
    //     ? DateFormat('yyyy-MM-dd')
    //         .format(DateTime.fromMillisecondsSinceEpoch(widget.gigDeadline))
    //     : null;

    _editedGigCurrency = widget.gigCurrency;
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

  // Editing the deadline date
  Future<Null> _selectedDate(BuildContext context) async {
    final DateTime _selectedDeadline = await showDatePicker(
      context: context,
      initialDate: DateTime.fromMillisecondsSinceEpoch(widget.gigDeadline),
      firstDate: DateTime.fromMillisecondsSinceEpoch(widget.gigDeadline),
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
        _editedGigDeadline = _selectedDeadline;
        // DateFormat('yyyy-MM-dd').format(_selectedDeadline);
      });
    }
  }

  Future saveGigEdits() async {
    if (_editYourGigFormKey.currentState.validate()) {
      EasyLoading.show();
      _editedGigLocation = PlacesAutocomplete.placesAutoCompleteController.text;
      _editYourGigFormKey.currentState.save();

      await DatabaseService().updateMyGigByGigId(
        gigId: widget.gigId,
        editedGigLocation: _editedGigLocation,
        editedGigDeadline: _editedGigDeadline,
        editedGigCurrency: _editedGigCurrency,
        editedGigBudget: _editedGigBudget,
        editedFavoriteHashtags: _myEditedFavoriteHashtags,
        editedGigPost: _editedGigPost,
      );

      EasyLoading.showSuccess('');
    }
  }

  @override
  Widget build(BuildContext context) {
    // myGig = widget.gigOwnerId == MyUser.uid ? true : false;
    _myEditedFavoriteHashtags = widget.gigHashtags;
    _editedGigPostController.text = widget.gigPost;
    _editedBudgetController.text = widget.gigBudget;

    timeAgo.setLocaleMessages('de', timeAgo.DeMessages());
    timeAgo.setLocaleMessages('dv', timeAgo.DvMessages());
    timeAgo.setLocaleMessages('dv_short', timeAgo.DvShortMessages());
    timeAgo.setLocaleMessages('fr', timeAgo.FrMessages());
    timeAgo.setLocaleMessages('fr_short', timeAgo.FrShortMessages());
    timeAgo.setLocaleMessages('gr', timeAgo.GrMessages());
    timeAgo.setLocaleMessages('gr_short', timeAgo.GrShortMessages());
    timeAgo.setLocaleMessages('ca', timeAgo.CaMessages());
    timeAgo.setLocaleMessages('ca_short', timeAgo.CaShortMessages());
    timeAgo.setLocaleMessages('cs', timeAgo.CsMessages());
    timeAgo.setLocaleMessages('cs_short', timeAgo.CsShortMessages());
    timeAgo.setLocaleMessages('ja', timeAgo.JaMessages());
    timeAgo.setLocaleMessages('km', timeAgo.KmMessages());
    timeAgo.setLocaleMessages('km_short', timeAgo.KmShortMessages());
    timeAgo.setLocaleMessages('ko', timeAgo.KoMessages());
    timeAgo.setLocaleMessages('id', timeAgo.IdMessages());
    timeAgo.setLocaleMessages('pt_BR', timeAgo.PtBrMessages());
    timeAgo.setLocaleMessages('pt_BR_short', timeAgo.PtBrShortMessages());
    timeAgo.setLocaleMessages('zh_CN', timeAgo.ZhCnMessages());
    timeAgo.setLocaleMessages('zh', timeAgo.ZhMessages());
    timeAgo.setLocaleMessages('it', timeAgo.ItMessages());
    timeAgo.setLocaleMessages('it_short', timeAgo.ItShortMessages());
    timeAgo.setLocaleMessages('fa', timeAgo.FaMessages());
    timeAgo.setLocaleMessages('ru', timeAgo.RuMessages());
    timeAgo.setLocaleMessages('tr', timeAgo.TrMessages());
    timeAgo.setLocaleMessages('pl', timeAgo.PlMessages());
    timeAgo.setLocaleMessages('th', timeAgo.ThMessages());
    timeAgo.setLocaleMessages('th_short', timeAgo.ThShortMessages());
    timeAgo.setLocaleMessages('nb_NO', timeAgo.NbNoMessages());
    timeAgo.setLocaleMessages('nb_NO_short', timeAgo.NbNoShortMessages());
    timeAgo.setLocaleMessages('nn_NO', timeAgo.NnNoMessages());
    timeAgo.setLocaleMessages('nn_NO_short', timeAgo.NnNoShortMessages());
    timeAgo.setLocaleMessages('ku', timeAgo.KuMessages());
    timeAgo.setLocaleMessages('ku_short', timeAgo.KuShortMessages());
    timeAgo.setLocaleMessages('ar', timeAgo.ArMessages());
    timeAgo.setLocaleMessages('ar_short', timeAgo.ArShortMessages());
    timeAgo.setLocaleMessages('ko', timeAgo.KoMessages());
    timeAgo.setLocaleMessages('vi', timeAgo.ViMessages());
    timeAgo.setLocaleMessages('vi_short', timeAgo.ViShortMessages());
    timeAgo.setLocaleMessages('tr', timeAgo.TrMessages());
    timeAgo.setLocaleMessages('ta', timeAgo.TaMessages());
    timeAgo.setLocaleMessages('ro', timeAgo.RoMessages());
    timeAgo.setLocaleMessages('ro_short', timeAgo.RoShortMessages());
    timeAgo.setLocaleMessages('sv', timeAgo.SvMessages());
    timeAgo.setLocaleMessages('sv_short', timeAgo.SvShortMessages());
    var locale = 'en';

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Container(
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              children: [
                clientSideAlert(),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                  color: Theme.of(context).primaryColor,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(2))),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Back',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                            ),
                          ),
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        GestureDetector(
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                  color: Theme.of(context).primaryColor,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(2))),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Save edits',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                            ),
                          ),
                          onTap: () async {
                            await saveGigEdits();

                            EasyLoading.dismiss();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Form(
                  key: _editYourGigFormKey,
                  // autovalidate: true,
                  // color: Colors.white,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              width: 200,
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    maxRadius: 20,
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                    backgroundImage: NetworkImage(
                                        "${widget.gigOwnerAvatarUrl}"),
                                  ),
                                  Container(
                                    width: 10,
                                    height: 0,
                                  ),
                                  Flexible(
                                    child: Text(
                                      "${widget.gigOwnerUsername}".capitalize(),
                                      overflow: TextOverflow.ellipsis,
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            widget.gigLocation != null
                                ? Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          GestureDetector(
                                            child: SizedBox(
                                              width: 16,
                                              height: 16,
                                              child: SvgPicture.asset(
                                                mapMarkerAlt,
                                                semanticsLabel: 'Location',
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                            ),
                                            onTap: () {
                                              getUserLocation();
                                            },
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          PlacesAutocomplete(
                                            signUpDecoraiton: true,
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : Container(width: 0, height: 0),
                          ],
                        ),
                      ),
                      GigItemMediaPreviewer(
                        preferredHeight: 250.0,
                        receivedGigMediaFilesUrls:
                            widget.gigMediaFilesDownloadUrls,
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(8, 0, 8, 16),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                GestureDetector(
                                  child: Row(
                                    children: <Widget>[
                                      SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: SvgPicture.asset(
                                          hourglassStart,
                                          semanticsLabel: 'hourglass-start',
                                        ),
                                      ),
                                      Container(
                                        width: 5.0,
                                        height: 0,
                                      ),
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        child: FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Text(
                                            _editedGigDeadline != null
                                                ? DateFormat('yyyy-MM-dd')
                                                    .format(_editedGigDeadline)
                                                    .toString()
                                                : "Book Gig",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  onTap: () {
                                    _selectedDate(context);
                                  },
                                ),
                                SizedBox(height: 5),
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Colors.black26,
                                              width: 0.5))),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Container(
                                        width: 100,
                                        child: DropdownButtonHideUnderline(
                                          child: Container(
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
                                                          width: 40,
                                                          height: 40,
                                                          decoration:
                                                              BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            color: Colors.white,
                                                          ),
                                                          child: Center(
                                                            child: Text(value),
                                                          ),
                                                        ),
                                                        value: value,
                                                      ))
                                                  .toList(),
                                              onChanged: (selectedCurrency) {
                                                setState(() {
                                                  _editedGigCurrency =
                                                      selectedCurrency;
                                                });
                                              },
                                              value: _editedGigCurrency,
                                              isExpanded: false,
                                              hint: Text(
                                                widget.gigCurrency,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1,
                                              ),
                                              validator: (value) =>
                                                  value == null ? '*' : null,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 70,
                                        child: TextFormField(
                                          textAlign: TextAlign.center,
                                          controller: _editedBudgetController,
                                          decoration:
                                              buildSignUpInputDecoration(
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
                                          onSaved: (value) =>
                                              _editedGigBudget = value,
                                          validator: (value) =>
                                              value.isEmpty ? '' : null,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Flex(
                              direction: Axis.vertical,
                              children: [
                                Container(
                                  width: double.infinity,
                                  child: Wrap(
                                    children: _myEditedFavoriteHashtags
                                        .map((e) => Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
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
                                                    _myEditedFavoriteHashtags
                                                        .removeWhere((item) =>
                                                            item == e);
                                                    print(
                                                        _myEditedFavoriteHashtags
                                                            .length);
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
                                            _myEditedFavoriteHashtags.length < 1
                                                ? ''
                                                : null,
                                        // onSaved: (value) => _myHashtag = value,
                                        textFieldConfiguration:
                                            TextFieldConfiguration(
                                          controller:
                                              _myFavoriteHashtagsController,
                                          // style: TextStyle(fontSize: 16),
                                          inputFormatters: [
                                            new LengthLimitingTextInputFormatter(
                                                20),
                                            FilteringTextInputFormatter.allow(
                                                RegExp("[a-z0-9_]")),
                                          ],

                                          decoration:
                                              buildSignUpInputDecoration(
                                                  context,
                                                  'Favorite #Hashtags'),
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
                                          if (_myEditedFavoriteHashtags.length <
                                                  20 !=
                                              true) {
                                            setState(() {
                                              clientSideWarning =
                                                  'Only 20 #Hashtags allowed';
                                            });
                                          } else if (_myEditedFavoriteHashtags
                                              .contains(suggestion)) {
                                            setState(() {
                                              clientSideWarning =
                                                  'Duplicate #Hashtags are not allowed';
                                            });
                                            _myFavoriteHashtagsController
                                                .clear();
                                          } else if (!_myEditedFavoriteHashtags
                                                  .contains(suggestion) &&
                                              _myEditedFavoriteHashtags.length <
                                                  20) {
                                            setState(() {
                                              _myEditedFavoriteHashtags
                                                  .add(suggestion);
                                              _myFavoriteHashtagsController
                                                  .clear();
                                              print(_myEditedFavoriteHashtags);
                                            });
                                          }
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 5, 20, 0),
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
                                            decoration:
                                                TextDecoration.underline,
                                            decorationThickness: 2,
                                            decorationColor:
                                                Theme.of(context).primaryColor,
                                            decorationStyle:
                                                TextDecorationStyle.dotted,
                                          ),
                                        ),
                                        onTap: () {
                                          if (_myEditedFavoriteHashtags.length <
                                                  20 !=
                                              true) {
                                            setState(() {
                                              clientSideWarning =
                                                  'Only 20 #Hashtags allowed';
                                              _myFavoriteHashtagsController
                                                  .clear();
                                            });
                                          } else if (_myEditedFavoriteHashtags
                                              .contains('#' +
                                                  _myFavoriteHashtagsController
                                                      .text)) {
                                            setState(() {
                                              clientSideWarning =
                                                  'Duplicate #Hashtags are not allowed';
                                            });
                                            _myFavoriteHashtagsController
                                                .clear();
                                          } else if (_myFavoriteHashtagsController
                                                  .text.isNotEmpty &&
                                              !_myEditedFavoriteHashtags
                                                  .contains('#' +
                                                      _myFavoriteHashtagsController
                                                          .text) &&
                                              _myEditedFavoriteHashtags.length <
                                                  20) {
                                            setState(() {
                                              _myEditedFavoriteHashtags.add('#' +
                                                  _myFavoriteHashtagsController
                                                      .text);
                                              _myFavoriteHashtagsController
                                                  .clear();
                                              FocusScope.of(context).unfocus();
                                              print(_myEditedFavoriteHashtags);
                                            });
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 10, 10, 10),
                                  child: TextFormField(
                                    controller: _editedGigPostController,
                                    decoration: buildSignUpInputDecoration(
                                        context, 'Describe your gig...'),
                                    inputFormatters: [
                                      new LengthLimitingTextInputFormatter(500),
                                    ],
                                    validator: (value) =>
                                        value.isEmpty ? '' : null,
                                    onSaved: (value) => _editedGigPost = value,
                                    maxLines: null,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      timeAgo.format(widget.gigTime.toDate()),
                                      style:
                                          Theme.of(context).textTheme.bodyText2,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
              boxShadow: [
                BoxShadow(
                    blurRadius: 8, color: Colors.grey[200], spreadRadius: 3)
              ]),
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
    super.dispose();
  }
}
