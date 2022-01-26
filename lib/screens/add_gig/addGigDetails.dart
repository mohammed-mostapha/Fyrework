import 'dart:io';

import 'package:Fyrework/screens/home/home.dart';
import 'package:Fyrework/services/bunny_service.dart';
import 'package:Fyrework/services/database.dart';
import 'package:Fyrework/viewmodels/create_gig_view_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:Fyrework/models/myUser.dart';
import 'package:Fyrework/screens/add_gig/sizeConfig.dart';
import 'package:Fyrework/services/places_autocomplete.dart';
import 'package:Fyrework/ui/shared/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:Fyrework/models/gig.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:sliding_card/sliding_card.dart';
import 'package:Fyrework/services/popularHashtags.dart';
import 'package:geocoding/geocoding.dart';

import 'assets_picker/src/provider/asset_entity_image_provider.dart';
import 'assets_picker/src/widget/asset_picker.dart';
import 'assets_picker/src/widget/asset_picker_viewer.dart';

class AddGigDetails extends StatefulWidget {
  @required
  List<AssetEntity> selectedAssets = <AssetEntity>[];

  AddGigDetails({
    Key key,
    this.selectedAssets,
  }) : super(key: key);

  @override
  _AddGigDetailsState createState() => _AddGigDetailsState();
}

TextEditingController locationController = TextEditingController();
SlidingCardController slidingCardController;
TextEditingController typeAheadController = TextEditingController();

class _AddGigDetailsState extends State<AddGigDetails> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isDisplayingDetail = true;
  List<AssetEntity> assetsForGig = <AssetEntity>[];
  int get assetsLength => widget.selectedAssets.length;
  List<File> gigMediaFiles = List();
  List<String> _gigMeidaFilesDownloadUrls = List<String>();
  String _gigId;

  @override
  void initState() {
    super.initState();
    slidingCardController = SlidingCardController();
  }

  Widget get selectedAssetsWidget => Container(
        height: 100,
        child: Row(
          children: [
            AnimatedContainer(
              duration: kThemeChangeDuration,
              curve: Curves.easeInOut,
              height: widget.selectedAssets.isNotEmpty
                  ? isDisplayingDetail
                      ? 250.0
                      : 80.0
                  : 40.0,
              child: Column(
                children: <Widget>[
                  selectedAssetsListView,
                ],
              ),
            ),
          ],
        ),
      );

  Widget get selectedAssetsListView => Expanded(
        child: ListView.builder(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          // padding: const EdgeInsets.symmetric(horizontal: 8.0),
          scrollDirection: Axis.horizontal,
          itemCount: assetsLength,
          itemBuilder: (BuildContext _, int index) {
            return Padding(
              // padding: const EdgeInsets.symmetric(
              //   // horizontal: 8.0,
              //   vertical: 16.0,
              // ),
              padding: EdgeInsets.fromLTRB(0, 16, 4, 16),
              child: AspectRatio(
                aspectRatio: 1.0,
                child: Stack(
                  children: <Widget>[
                    Positioned.fill(child: _selectedAssetWidget(index)),
                    AnimatedPositioned(
                      duration: kThemeAnimationDuration,
                      top: isDisplayingDetail ? 6.0 : -30.0,
                      right: isDisplayingDetail ? 6.0 : -30.0,
                      child: _selectedAssetDeleteButton(index),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );

  Widget _selectedAssetDeleteButton(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          widget.selectedAssets.remove(widget.selectedAssets.elementAt(index));
          if (assetsLength == 0) {
            isDisplayingDetail = false;
          }
        });
      },
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
          color: Theme.of(context).accentColor,
        ),
        child: Icon(
          Icons.close,
          color: Theme.of(context).primaryColor,
          size: 18.0,
        ),
      ),
    );
  }

  Widget _selectedAssetWidget(int index) {
    final AssetEntity asset = widget.selectedAssets.elementAt(index);
    return GestureDetector(
      onTap: isDisplayingDetail
          ? () async {
              final List<AssetEntity> result =
                  await AssetPickerViewer.pushToViewer(
                context,
                currentIndex: index,
                assets: widget.selectedAssets,
                themeData: AssetPicker.themeData(Colors.transparent),
              );
              if (result != widget.selectedAssets && result != null) {
                assetsForGig = List<AssetEntity>.from(result);
                if (mounted) {
                  setState(() {});
                }
              }
            }
          : null,
      child: RepaintBoundary(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: _assetWidgetBuilder(asset),
        ),
      ),
    );
  }

  Widget _assetWidgetBuilder(AssetEntity asset) {
    Widget widget;
    switch (asset.type) {
      case AssetType.audio:
        widget = _audioAssetWidget(asset);
        break;
      case AssetType.video:
        widget = _videoAssetWidget(asset);
        break;
      case AssetType.image:
      case AssetType.other:
        widget = _imageAssetWidget(asset);
        break;
    }
    return widget;
  }

  Widget _audioAssetWidget(AssetEntity asset) {
    return Container(width: 0, height: 0);
  }

  Widget _imageAssetWidget(AssetEntity asset) {
    return Image(
      image: AssetEntityImageProvider(asset, isOriginal: false),
      fit: BoxFit.cover,
    );
  }

  Widget _videoAssetWidget(AssetEntity asset) {
    return Stack(
      children: <Widget>[
        Positioned.fill(child: _imageAssetWidget(asset)),
        ColoredBox(
          color: Theme.of(context).accentColor,
          child: Center(
            child: Icon(
              Icons.video_library,
              color: Colors.white,
              size: isDisplayingDetail ? 24.0 : 16.0,
            ),
          ),
        ),
      ],
    );
  }

  int today = DateTime.now().day;
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
  final String overWork = 'assets/svgs/flaticon/overwork.svg';

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
      'Who will do the Gig...',
      style: TextStyle(fontSize: 16),
    ),
  );
  final _gigCurrencySnackBar = SnackBar(
    content: Text(
      'Please choose currency...',
      style: TextStyle(fontSize: 16),
    ),
  );

  Future saveFormValuesAndPublish() async {
    if (AppointmentCard.gigValue == null) {
      _scaffoldKey.currentState.showSnackBar(_gigValueSnackBar);
    } else if (_gigCurrency == null) {
      _scaffoldKey.currentState.showSnackBar(_gigCurrencySnackBar);
    } else if (AppointmentCard.gigValue != null &&
        _createGigFormKey.currentState.validate()) {
      _gigLocation = PlacesAutocomplete.placesAutoCompleteController.text;
      _createGigFormKey.currentState.save();

      EasyLoading.show();
      await prepareGigMediaFilesAndPublish();
      EasyLoading.dismiss();
    }
  }

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

  //Combining the next page in this page
  Future prepareGigMediaFilesAndPublish() async {
    // Future<List<File>> assignAssetsToGigMediaFiles = assigingLists();
    // await assignAssetsToGigMediaFiles;
    await assigingLists();
    await uploadMediaFiles();
    clearGigMediaFiles();
  }

  Future<List<File>> assigingLists() async {
    for (final mediaFile in widget.selectedAssets) {
      gigMediaFiles.add(await mediaFile.originFile);
    }
  }

  Future uploadMediaFiles() async {
    // String storageResult;
    String uploadResult;
    if (gigMediaFiles != null) {
      for (var i = 0; i < gigMediaFiles.length; i++) {
        uploadResult = await BunnyService().uploadMediaFileToBunny(
          fileToUpload: gigMediaFiles[i],
          storageZonePath: 'gigMediaFiles',
        );

        //adding each downloadUrl to downloadUrls list
        _gigMeidaFilesDownloadUrls.add(uploadResult);
      }

      CreateGigViewModel().createGig(
        appointed: _appointed,
        gigId: _gigId,
        userId: _userId,
        userProfilePictureDownloadUrl: _userProfilePictureDownloadUrl,
        username: _username,
        gigHashtags: _myFavoriteHashtags,
        userLocation: _userLocation,
        gigLocation: _gigLocation,
        gigMediaFilesDownloadUrls: _gigMeidaFilesDownloadUrls,
        gigPost: _gigPost,
        gigDeadLine: AppointmentCard.gigDeadline,
        gigCurrency: _gigCurrency,
        gigBudget: _gigBudget,
        gigValue: AppointmentCard.gigValue,
        adultContentText: _adultContentText,
        adultContentBool: _adultContentBool,
      );
      clearGigMediaFiles();
      await DatabaseService().addToPopularHashtags(_myFavoriteHashtags);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => Home(passedSelectedIndex: 0),
          ),
          (route) => false);
    }
  }

  clearGigMediaFiles() {
    widget.selectedAssets.clear();
  }
  //end combination

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return FutureBuilder(
        future: DatabaseService().fetchGigsByOwnerId(),
        builder: (context, gigsByOwnerIdSnapshot) {
          if (gigsByOwnerIdSnapshot.data != null) {
            List userGigsDocs = List.from(gigsByOwnerIdSnapshot.data.docs);

            List todayGigsCount = userGigsDocs
                .map(
                  (e) => DateTime.parse(
                    e.data()['createdAt'].toDate().toString(),
                  ),
                )
                .where((gigDate) => gigDate.day == today)
                .toList();

            print('your todays gigs count: ${todayGigsCount.length}');

            return todayGigsCount.length < 10
                ? GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                    },
                    child: Scaffold(
                      key: _scaffoldKey,
                      appBar: AppBar(
                        actions: <Widget>[
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 10, 15, 10),
                            child: OutlineButton(
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor),
                              child: Text('Publish',
                                  style: Theme.of(context).textTheme.bodyText1),
                              onPressed: () async {
                                await saveFormValuesAndPublish();
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
                        // color: Colors.grey[50],
                        child: SingleChildScrollView(
                          controller: scrollController,
                          child: Column(
                            children: [
                              Form(
                                key: _createGigFormKey,
                                // autovalidate: true,
                                // color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    children: <Widget>[
                                      clientSideAlert(),
                                      selectedAssetsWidget,
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        child: Container(
                                          width: double.infinity,
                                          child: Wrap(
                                            children: _myFavoriteHashtags
                                                .map((e) => Padding(
                                                      padding: const EdgeInsets
                                                              .fromLTRB(
                                                          0, 0, 2.5, 2.5),
                                                      child: Chip(
                                                          materialTapTargetSize:
                                                              MaterialTapTargetSize
                                                                  .shrinkWrap,
                                                          backgroundColor:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                          label: Text(
                                                            '$e',
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodyText1
                                                                .copyWith(
                                                                    color: Theme.of(
                                                                            context)
                                                                        .accentColor),
                                                          ),
                                                          onDeleted: () {
                                                            setState(() {
                                                              _myFavoriteHashtags
                                                                  .removeWhere(
                                                                      (item) =>
                                                                          item ==
                                                                          e);
                                                              print(
                                                                  _myFavoriteHashtags
                                                                      .length);
                                                            });
                                                          },
                                                          deleteIconColor:
                                                              Theme.of(context)
                                                                  .accentColor),
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
                                                  _myFavoriteHashtags.length < 1
                                                      ? ''
                                                      : null,
                                              // onSaved: (value) => _myHashtag = value,
                                              textFieldConfiguration:
                                                  TextFieldConfiguration(
                                                controller:
                                                    _myFavoriteHashtagsController,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1,
                                                inputFormatters: [
                                                  new LengthLimitingTextInputFormatter(
                                                      20),
                                                  FilteringTextInputFormatter
                                                      .allow(
                                                          RegExp("[a-z0-9_]")),
                                                ],
                                                decoration:
                                                    signUpInputDecoration(
                                                        context,
                                                        'Favorite #Hashtags'),
                                              ),
                                              suggestionsCallback:
                                                  (pattern) async {
                                                return await PopularHashtagsService
                                                    .fetchPopularHashtags(
                                                        pattern);
                                              },
                                              itemBuilder:
                                                  (context, suggestions) {
                                                return ListTile(
                                                  title: Text(suggestions),
                                                );
                                              },
                                              onSuggestionSelected:
                                                  (suggestion) {
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
                                                  });
                                                }
                                              },
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                10, 5, 10, 0),
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
                                                      Theme.of(context)
                                                          .primaryColor,
                                                  decorationStyle:
                                                      TextDecorationStyle
                                                          .dotted,
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
                                                    !_myFavoriteHashtags
                                                        .contains('#' +
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
                                            0, 8.0, 0, 8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            PlacesAutocomplete(
                                              signUpDecoraiton: true,
                                            ),
                                            IconButton(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              onPressed: () {
                                                getUserLocation();
                                              },
                                              icon: Icon(Icons.gps_fixed),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 10, 0, 10),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: TextFormField(
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1,
                                                decoration:
                                                    signUpInputDecoration(
                                                        context,
                                                        'Describe your gig...'),
                                                inputFormatters: [
                                                  new LengthLimitingTextInputFormatter(
                                                      500),
                                                ],
                                                validator: (value) =>
                                                    value.isEmpty ? '' : null,
                                                onSaved: (value) =>
                                                    _gigPost = value,
                                                maxLines: null,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 48.0,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                            // border: Border(
                                            //   bottom: BorderSide(
                                            //       color: Colors.black26,
                                            //       width: 0.5),
                                            // ),
                                            ),
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 10, 10, 10),
                                          child: AppointmentCard(
                                            onCardTapped: () {
                                              if (slidingCardController
                                                      .isCardSeparated ==
                                                  true) {
                                                slidingCardController
                                                    .collapseCard();
                                              } else {
                                                slidingCardController
                                                    .expandCard();
                                              }
                                            },
                                            slidingCardController:
                                                slidingCardController,
                                          ),
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Container(
                                            child: PopupMenuButton(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    "Currency: ${_gigCurrency == null ? '' : _gigCurrency}",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText1,
                                                  ),
                                                  Icon(
                                                    Icons.arrow_downward,
                                                    size: 15,
                                                  ),
                                                ],
                                              ),
                                              onSelected: (selectedCurrency) {
                                                setState(() {
                                                  _gigCurrency =
                                                      selectedCurrency;
                                                });
                                              },
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              10.0))),
                                              itemBuilder: (context) {
                                                return _currencies
                                                    .map((value) =>
                                                        PopupMenuItem(
                                                          value: value,
                                                          child: Text(
                                                            value,
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodyText1,
                                                          ),
                                                        ))
                                                    .toList();
                                              },
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.fromLTRB(
                                                0, 0, 48.0, 0),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                3,
                                            child: TextFormField(
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1,
                                              decoration: signUpInputDecoration(
                                                  context, 'Budget'),

                                              // Only numbers can be entered
                                              keyboardType:
                                                  TextInputType.number,
                                              inputFormatters: <
                                                  TextInputFormatter>[
                                                FilteringTextInputFormatter
                                                    .digitsOnly
                                              ],
                                              onSaved: (value) =>
                                                  _gigBudget = value,
                                              validator: (value) =>
                                                  value.isEmpty ? '' : null,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        height: 50,
                                        decoration: BoxDecoration(),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Container(
                                              width: 20,
                                              height: 20,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    width: 0.5,
                                                    color: Theme.of(context)
                                                        .primaryColor),
                                              ),
                                              child: Checkbox(
                                                materialTapTargetSize:
                                                    MaterialTapTargetSize
                                                        .shrinkWrap,
                                                value: _adultContentBool,
                                                onChanged: (bool value) {
                                                  setState(() {
                                                    _adultContentBool =
                                                        !_adultContentBool;
                                                    if (_adultContentBool ==
                                                        true) {
                                                      _adultContentText =
                                                          "Adult content";
                                                    } else {
                                                      _adultContentText = '';
                                                    }
                                                  });
                                                },
                                                activeColor: Theme.of(context)
                                                    .primaryColor,
                                                checkColor: Theme.of(context)
                                                    .accentColor,
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
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                : userGigsQuotaPerDay();
          }
          return Center(
            child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).primaryColor)),
          );
        });
  }

  Widget userGigsQuotaPerDay() {
    return Container(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 100,
                height: 100,
                child: SvgPicture.asset(
                  overWork,
                  semanticsLabel: 'gigQuotaPerDay',
                  color: Theme.of(context).primaryColor,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text('You have reached your daily gig  posting limit',
                  style: Theme.of(context).textTheme.headline1,
                  textAlign: TextAlign.center),
            ],
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
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).primaryColor,
        ),
        width: double.infinity,
        height: 50,
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
                padding: EdgeInsets.zero,
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
  static DateTime gigDeadline = new DateTime.now().add(Duration(days: 30));

  @override
  _AppointmentCardState createState() => _AppointmentCardState();
}

class _AppointmentCardState extends State<AppointmentCard> {
  TextEditingController _deadLineController = new TextEditingController();

  DateTime _initialDeadline = new DateTime.now().add(Duration(days: 30));

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
        AppointmentCard.gigDeadline = _selectedDeadline;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                child: Row(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            width: 0.5, color: Theme.of(context).primaryColor),
                      ),
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
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            width: 0.5, color: Theme.of(context).primaryColor),
                      ),
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
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.40,
                  child: ButtonTheme(
                    padding: EdgeInsets.all(0),
                    child: AppointmentCard.gigDeadline != null
                        ? GestureDetector(
                            onTap: () {
                              _selectedDate(context);
                            },
                            child: Text(
                                DateFormat('yyyy-MM-dd')
                                    .format(AppointmentCard.gigDeadline),
                                style: Theme.of(context).textTheme.bodyText1),
                          )
                        : Container(),
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

    super.dispose();
  }
}
