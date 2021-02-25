import 'dart:async';
import 'dart:core';
import 'package:Fyrework/models/myUser.dart';
import 'package:Fyrework/screens/add_gig/addGigDetails.dart';
import 'package:Fyrework/services/places_autocomplete.dart';
import 'package:Fyrework/services/popularHashtags.dart';
import 'package:Fyrework/ui/shared/constants.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:Fyrework/screens/add_gig/assets_picker/src/constants/constants.dart';
import 'package:Fyrework/services/firestore_service.dart';
import 'package:Fyrework/ui/views/add_comments_view.dart';
import 'package:Fyrework/ui/widgets/gig_item_media_previewer.dart';
import 'package:Fyrework/ui/widgets/user_profile.dart';
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
  dynamic gigDeadline;
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
  final _createGigFormKey = GlobalKey<FormState>();
  ScrollController scrollController = ScrollController();
  String clientSideWarning;
  List _myFavoriteHashtags = List();
  TextEditingController _myFavoriteHashtagsController = TextEditingController();
  TextEditingController _gigPostController = TextEditingController();
  TextEditingController _editedBudgetController = TextEditingController();
  bool myGig;
  String _gigPost;
  String _editedGigDeadline;
  String _editedGigCurrency;

  String _gigCurrency;
  dynamic _gigBudget;
  String _adultContentText;
  bool _adultContentBool = false;
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
        ? DateFormat('yyyy-MM-dd')
            .format(DateTime.fromMillisecondsSinceEpoch(widget.gigDeadline))
        : null;

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
        _editedGigDeadline = DateFormat('yyyy-MM-dd').format(_selectedDeadline);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    myGig = widget.gigOwnerId == MyUser.uid ? true : false;
    _myFavoriteHashtags = widget.gigHashtags;
    _gigPostController.text = widget.gigPost;
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
      child: Container(
        margin: const EdgeInsets.only(top: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                  child: Column(
                    children: <Widget>[
                      Row(
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
                                      mainAxisAlignment: MainAxisAlignment.end,
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
                                        // Flexible(
                                        //   child: Text(
                                        //     '${widget.gigLocation}',
                                        //     overflow: TextOverflow.ellipsis,
                                        //     style: Theme.of(context)
                                        //         .textTheme
                                        //         .bodyText2,
                                        //   ),
                                        // )
                                        // Flexible(
                                        //   child: Padding(
                                        //     padding: const EdgeInsets.fromLTRB(
                                        //         0, 8.0, 0, 8.0),
                                        //     child: Row(
                                        //       mainAxisAlignment:
                                        //           MainAxisAlignment
                                        //               .spaceBetween,
                                        //       children: <Widget>[
                                        //         PlacesAutocomplete(
                                        //           signUpDecoraiton: true,
                                        //         ),
                                        //         IconButton(
                                        //           color: Theme.of(context)
                                        //               .primaryColor,
                                        //           onPressed: () {
                                        //             getUserLocation();
                                        //           },
                                        //           icon: Icon(Icons.gps_fixed),
                                        //         ),
                                        //       ],
                                        //     ),
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                  ),
                                )
                              : Container(width: 0, height: 0),
                          // Container(
                          //   decoration: BoxDecoration(
                          //       border: Border.all(
                          //         width: 1,
                          //         color: Theme.of(context).primaryColor,
                          //       ),
                          //       borderRadius:
                          //           BorderRadius.all(Radius.circular(2))),
                          //   child: Padding(
                          //     padding: const EdgeInsets.all(8.0),
                          //     child: GestureDetector(
                          //         child: Text(
                          //           widget.gigOwnerId == widget.currentUserId
                          //               ? 'Edit Your gig'
                          //               : widget.gigValue == 'Gigs I can do'
                          //                   ? 'Hire me'
                          //                   : 'Apply',
                          //           style:
                          //               Theme.of(context).textTheme.bodyText1,
                          //         ),
                          //         onTap: () {}),
                          //   ),
                          // )
                        ],
                      ),
                      // SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
              GigItemMediaPreviewer(
                receivedGigMediaFilesUrls: widget.gigMediaFilesDownloadUrls,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 16.0),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),

                    SizedBox(height: 10),
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
                                        ?
                                        // DateFormat('yyyy-MM-dd').format(
                                        //     DateTime.fromMillisecondsSinceEpoch(
                                        //         widget.gigDeadline))
                                        _editedGigDeadline
                                        : "Book Gig",
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
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
                          // height: 100,
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: Colors.black26, width: 0.5))),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                            .map((value) => DropdownMenuItem(
                                                  child: Container(
                                                    width: 40,
                                                    height: 40,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Colors.white,
                                                    ),
                                                    child: Center(
                                                      // child: TextFormField(
                                                      //   enabled: false,
                                                      //   decoration: buildSignUpInputDecoration(
                                                      //           context,
                                                      //           value)
                                                      //       .copyWith(
                                                      //           enabledBorder:
                                                      //               InputBorder
                                                      //                   .none),
                                                      // ),
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
                                        value: _gigCurrency,
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
                                    controller: _editedBudgetController,
                                    decoration: buildSignUpInputDecoration(
                                            context, 'Budget')
                                        .copyWith(
                                            enabledBorder: InputBorder.none),
                                    // Only numbers can be entered
                                    keyboardType: TextInputType.number,
                                    inputFormatters: <TextInputFormatter>[
                                      WhitelistingTextInputFormatter.digitsOnly
                                    ],
                                    onSaved: (value) => _gigBudget = value,
                                    validator: (value) =>
                                        value.isEmpty ? '' : null,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Container(
                        //   child: RichText(
                        //     overflow: TextOverflow.ellipsis,
                        //     text: TextSpan(
                        //         style: Theme.of(context).textTheme.bodyText1,
                        //         children: <TextSpan>[
                        //           TextSpan(
                        //             text: "${widget.gigCurrency} ",
                        //           ),
                        //           TextSpan(
                        //             text: "${widget.gigBudget}",
                        //           ),
                        //         ]),
                        //   ),
                        // )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    //new code for gig editing
                    Form(
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
                                                            color:
                                                                Colors.white),
                                                  ),
                                                  onDeleted: () {
                                                    setState(() {
                                                      _myFavoriteHashtags
                                                          .removeWhere((item) =>
                                                              item == e);
                                                      print(_myFavoriteHashtags
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
                                              _myFavoriteHashtags.length < 1
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
                                            if (_myFavoriteHashtags.length <
                                                    20 !=
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
                                              _myFavoriteHashtagsController
                                                  .clear();
                                            } else if (!_myFavoriteHashtags
                                                    .contains(suggestion) &&
                                                _myFavoriteHashtags.length <
                                                    20) {
                                              setState(() {
                                                _myFavoriteHashtags
                                                    .add(suggestion);
                                                _myFavoriteHashtagsController
                                                    .clear();
                                                print(_myFavoriteHashtags);
                                              });
                                            }
                                          },
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 5, 10, 0),
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
                                              decorationColor: Theme.of(context)
                                                  .primaryColor,
                                              decorationStyle:
                                                  TextDecorationStyle.dotted,
                                            ),
                                          ),
                                          onTap: () {
                                            if (_myFavoriteHashtags.length <
                                                    20 !=
                                                true) {
                                              setState(() {
                                                clientSideWarning =
                                                    'Only 20 #Hashtags allowed';
                                                _myFavoriteHashtagsController
                                                    .clear();
                                              });
                                            } else if (_myFavoriteHashtags
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
                                                !_myFavoriteHashtags.contains('#' +
                                                    _myFavoriteHashtagsController
                                                        .text) &&
                                                _myFavoriteHashtags.length <
                                                    20) {
                                              setState(() {
                                                _myFavoriteHashtags.add('#' +
                                                    _myFavoriteHashtagsController
                                                        .text);
                                                _myFavoriteHashtagsController
                                                    .clear();
                                                FocusScope.of(context)
                                                    .unfocus();
                                                print(_myFavoriteHashtags);
                                              });
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        0, 10, 10, 10),
                                    child: TextFormField(
                                      controller: _gigPostController,
                                      decoration: buildSignUpInputDecoration(
                                          context, 'Describe your gig...'),
                                      inputFormatters: [
                                        new LengthLimitingTextInputFormatter(
                                            500),
                                      ],
                                      validator: (value) =>
                                          value.isEmpty ? '' : null,
                                      onSaved: (value) => _gigPost = value,
                                      maxLines: null,
                                    ),
                                  ),
                                  Container(
                                    height: 50,
                                    decoration: BoxDecoration(),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        SizedBox(
                                          width: 20,
                                          child: Checkbox(
                                            materialTapTargetSize:
                                                MaterialTapTargetSize
                                                    .shrinkWrap,
                                            value: _adultContentBool,
                                            onChanged: (bool value) {
                                              setState(() {
                                                _adultContentBool =
                                                    !_adultContentBool;
                                                if (_adultContentBool == true) {
                                                  _adultContentText =
                                                      "Adult content";
                                                } else {
                                                  _adultContentText = '';
                                                }
                                              });
                                            },
                                            activeColor:
                                                Theme.of(context).primaryColor,
                                            checkColor:
                                                Theme.of(context).accentColor,
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
                    //end new code for gig editing
                    Row(
                      children: [
                        Text(
                          timeAgo.format(widget.gigTime.toDate()),
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      ],
                    ),
                    // SizedBox(height: 10.0),
                    widget.adultContentBool
                        ? Container(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              children: [
                                SizedBox(height: 5),
                                Row(
                                  children: [
                                    FaIcon(
                                      FontAwesomeIcons.asterisk,
                                      size: 12,
                                    ),
                                    Container(
                                      width: 5.0,
                                    ),
                                    Expanded(
                                      child: Text(
                                        "${widget.adultContentText}",
                                        style: TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        : Container(
                            width: 0,
                            height: 0,
                          ),
                    SizedBox(height: 5),
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
              BoxShadow(blurRadius: 8, color: Colors.grey[200], spreadRadius: 3)
            ]),
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
