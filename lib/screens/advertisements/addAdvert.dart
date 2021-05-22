import 'dart:io';

import 'package:Fyrework/screens/add_gig/assets_picker/constants/picker_model.dart';
import 'package:Fyrework/screens/add_gig/assets_picker/src/widget/asset_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:Fyrework/models/myUser.dart';
import 'package:Fyrework/screens/add_gig/sizeConfig.dart';
import 'package:Fyrework/services/places_autocomplete.dart';
import 'package:Fyrework/ui/shared/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:Fyrework/models/gig.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:Fyrework/services/popularHashtags.dart';
import 'package:geocoding/geocoding.dart';

class AddAdvert extends StatefulWidget {
  // final gigHashtagsController = TextEditingController();
  final Gig edittingGig;
  AddAdvert({Key key, this.edittingGig, Gig edittinGig}) : super(key: key);

  @override
  _AddAdvertState createState() => _AddAdvertState();
}

TextEditingController typeAheadController = TextEditingController();

class _AddAdvertState extends State<AddAdvert> {
  @override
  void initState() {
    super.initState();
  }

  String _userId = MyUser.uid;
  String _userProfilePictureDownloadUrl = MyUser.userAvatarUrl;
  String _username = MyUser.name;
  String _userLocation = MyUser.location;

  final _createGigFormKey = GlobalKey<FormState>();
  List _myFavoriteHashtags = List();

  TextEditingController _myFavoriteHashtagsController = TextEditingController();
  TextEditingController _advertTextController = TextEditingController();
  ScrollController scrollController = ScrollController();

  String _gigLocation;

  // instantiating GigModel value here to work with...
  String _gigPost;
  String _gigCurrency;
  dynamic _gigBudget;
  String _adultContentText;
  bool _adultContentBool = false;
  bool _appointed = false;
  String _superImposedText;
  String clientSideWarning;
  String _addPhoto = 'assets/svgs/flaticon/add_photo.svg';
  List<AssetEntity> selectedAdvertImagesList;
  File extractedAdvertImageFromList;
  final int maxAssetsCount = 1;
  File _advertImage;

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

  getUserLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark placemark = placemarks[0];
    // String completeAddress =
    //     '${placemark.subThoroughfare} ${placemark.thoroughfare}, ${placemark.subLocality} ${placemark.locality}, ${placemark.subAdministrativeArea}, ${placemark.administrativeArea} ${placemark.postalCode}, ${placemark.country}';
    // print(completeAddress);
    String formattedAddress = "${placemark.locality}, ${placemark.country}";
    setState(() {
      // locationController.text = formattedAddress;
      PlacesAutocomplete.placesAutoCompleteController.text = formattedAddress;
    });
  }

  List<PickMethodModel> get pickMethods => <PickMethodModel>[
        PickMethodModel(
          // icon: '📹',
          // name: 'Common picker',
          // description: 'Pick images and videos.',
          method: (
            BuildContext context,
            List<AssetEntity> assets,
          ) async {
            return await AssetPicker.pickAssets(
              context,
              maxAssets: maxAssetsCount,
              selectedAssets: assets,
              requestType: RequestType.image,
            );
          },
        ),
      ];

  selectAdvertImage() async {
    (BuildContext context, int index) async {
      final PickMethodModel model = pickMethods[index];

      final List<AssetEntity> retrievedAssets = await model.method(
        context,
        selectedAdvertImagesList,
      );
      if (retrievedAssets != null &&
          retrievedAssets != selectedAdvertImagesList) {
        selectedAdvertImagesList = retrievedAssets;
        () async {
          extractedAdvertImageFromList =
              await selectedAdvertImagesList.first.originFile;
          if (mounted) {
            setState(() {});
            _advertImage = extractedAdvertImageFromList;
          }
        }();
      }
    }(context, 0);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.all(0),
          child: Text(
            'Create Advert',
            style: Theme.of(context).textTheme.headline1,
          ),
        ),
      ),
      body: Container(
        // color: Colors.grey[50],
        child: Form(
          key: _createGigFormKey,
          // autovalidate: true,
          // color: Colors.white,
          child: SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: <Widget>[
                  clientSideAlert(),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Container(
                      width: double.infinity,
                      child: Wrap(
                        children: _myFavoriteHashtags
                            .map((e) => Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 2.5, 2.5),
                                  child: Chip(
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      backgroundColor:
                                          Theme.of(context).primaryColor,
                                      label: Text(
                                        '$e',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            .copyWith(
                                                color: Theme.of(context)
                                                    .accentColor),
                                      ),
                                      onDeleted: () {
                                        setState(() {
                                          _myFavoriteHashtags
                                              .removeWhere((item) => item == e);
                                          print(_myFavoriteHashtags.length);
                                        });
                                      },
                                      deleteIconColor:
                                          Theme.of(context).accentColor),
                                ))
                            .toList(),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TypeAheadFormField(
                          validator: (value) =>
                              _myFavoriteHashtags.length < 1 ? '' : null,
                          // onSaved: (value) => _myHashtag = value,
                          textFieldConfiguration: TextFieldConfiguration(
                            controller: _myFavoriteHashtagsController,
                            // style: TextStyle(fontSize: 16),
                            inputFormatters: [
                              new LengthLimitingTextInputFormatter(20),
                              FilteringTextInputFormatter.allow(
                                  RegExp("[a-z0-9_]")),
                            ],

                            decoration: signUpInputDecoration(
                                context, 'Advert #Hashtags'),
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
                            if (_myFavoriteHashtags.length < 20 != true) {
                              setState(() {
                                clientSideWarning = 'Only 20 #Hashtags allowed';
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
                              });
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                        child: GestureDetector(
                          child: Text(
                            'Add',
                            style: TextStyle(
                              shadows: [
                                Shadow(
                                    color: Theme.of(context).primaryColor,
                                    offset: Offset(0, -2.5))
                              ],
                              fontSize: 14,
                              color: Colors.transparent,
                              decoration: TextDecoration.underline,
                              decorationThickness: 2,
                              decorationColor: Theme.of(context).primaryColor,
                              decorationStyle: TextDecorationStyle.dotted,
                            ),
                          ),
                          onTap: () {
                            if (_myFavoriteHashtags.length < 20 != true) {
                              setState(() {
                                clientSideWarning = 'Only 20 #Hashtags allowed';
                                _myFavoriteHashtagsController.clear();
                              });
                            } else if (_myFavoriteHashtags.contains(
                                '#' + _myFavoriteHashtagsController.text)) {
                              setState(() {
                                clientSideWarning =
                                    'Duplicate #Hashtags are not allowed';
                              });
                              _myFavoriteHashtagsController.clear();
                            } else if (_myFavoriteHashtagsController
                                    .text.isNotEmpty &&
                                !_myFavoriteHashtags.contains(
                                    '#' + _myFavoriteHashtagsController.text) &&
                                _myFavoriteHashtags.length < 20) {
                              setState(() {
                                _myFavoriteHashtags.add(
                                    '#' + _myFavoriteHashtagsController.text);
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
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _advertTextController,
                            style: Theme.of(context).textTheme.bodyText1,
                            decoration:
                                signUpInputDecoration(context, 'Advert Text'),
                            inputFormatters: [
                              new LengthLimitingTextInputFormatter(100),
                            ],
                            validator: (value) => value.isEmpty ? '' : null,
                            onSaved: (value) => _gigPost = value,
                            maxLines: null,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                          child: GestureDetector(
                            child: Text(
                              'Use',
                              style: TextStyle(
                                shadows: [
                                  Shadow(
                                      color: Theme.of(context).primaryColor,
                                      offset: Offset(0, -2.5))
                                ],
                                fontSize: 14,
                                color: Colors.transparent,
                                decoration: TextDecoration.underline,
                                decorationThickness: 2,
                                decorationColor: Theme.of(context).primaryColor,
                                decorationStyle: TextDecorationStyle.dotted,
                              ),
                            ),
                            onTap: () {
                              //assign the text to the _superImposed variable with setState()
                              setState(() {
                                _superImposedText = _advertTextController.text;
                                _advertTextController.clear();
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height / 2,
                      decoration: BoxDecoration(
                        color: Theme.of(context).inputDecorationTheme.fillColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Stack(
                        children: [
                          _advertImage == null
                              ? Center(
                                  child: GestureDetector(
                                    child: SizedBox(
                                      width: 100,
                                      height: 100,
                                      child: SvgPicture.asset(
                                        _addPhoto,
                                        semanticsLabel: 'add_photo',
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                    onTap: () {
                                      selectAdvertImage();
                                    },
                                  ),
                                )
                              : Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: FileImage(
                                        File(_advertImage.path),
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Text(
                                    _superImposedText == null ||
                                            _superImposedText == ''
                                        ? ''
                                        : '$_superImposedText',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .copyWith(fontSize: 20),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 1,
                                    color: Theme.of(context).primaryColor),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(2))),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Change image',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(
                                      color: Theme.of(context).primaryColor,
                                    ),
                              ),
                            ),
                          ),
                          onTap: () {
                            selectAdvertImage();
                          },
                        ),
                        GestureDetector(
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 1,
                                    color: Theme.of(context).primaryColor),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(2))),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Next',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(
                                      color: Theme.of(context).primaryColor,
                                    ),
                              ),
                            ),
                          ),
                          onTap: () {},
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
                color: Theme.of(context).accentColor,
              ),
            ),
            Expanded(
              child: Text(
                clientSideWarning,
                maxLines: 3,
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    .copyWith(color: Theme.of(context).accentColor),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: IconButton(
                icon: Icon(
                  Icons.close,
                  color: Theme.of(context).hintColor,
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
    _advertTextController.clear();
    _advertImage = null;
    super.dispose();
  }
}
