import 'dart:io';

import 'package:google_mobile_ads/google_mobile_ads.dart';

class MobileAdsState {
  Future<InitializationStatus> adStateInitialization;

  MobileAdsState(this.adStateInitialization);

  String get testBannerAdUnit => Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/6300978111'
      : 'ca-app-pub-3940256099942544/2934735716';

  AdListener get adListener => _adListener;

  AdListener _adListener = AdListener(
    onAdLoaded: (ad) => print('advertisement Ad Loaded: ${ad.adUnitId}'),
    onAdClosed: (ad) => print('advertisement Ad Closed: ${ad.adUnitId}'),
    onAdFailedToLoad: (ad, error) =>
        print('advertisement Ad failed to load: ${ad.adUnitId}, $error.'),
    onAdOpened: (ad) => print('advertisement Ad Opened: ${ad.adUnitId}'),
    onAppEvent: (ad, name, data) =>
        print('advertisement Ad event: ${ad.adUnitId}, $name, $data'),
    onApplicationExit: (ad) => print('advertisement App Exit: ${ad.adUnitId}'),
    onNativeAdClicked: (nativeAd) =>
        print('advertisement Native ad Cliclied: ${nativeAd.adUnitId}'),
    onNativeAdImpression: (nativeAd) =>
        print('advertisement Native ad Impression: ${nativeAd.adUnitId}'),
    onRewardedAdUserEarnedReward: (ad, reward) =>
        print('advertisement User rewarded: ${ad.adUnitId}, ${reward.type}'),
  );
}
