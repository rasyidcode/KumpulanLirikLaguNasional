import 'package:firebase_admob/firebase_admob.dart';
import 'package:kumpulan_lirik_lagu_kebangsaan/src/personal/admob.dart'
    show APP_ID, BANNER_ID, INTERSTITIAL_ID;

class AdsUtil {
  static BannerAd _bannerAd;
  static InterstitialAd _interstitialAd;

  static void initialize() {
    FirebaseAdMob.instance.initialize(appId: APP_ID);
  }

  static BannerAd _createBannerAd() {
    return BannerAd(
      adUnitId: BANNER_ID,
      // adUnitId: BannerAd.testAdUnitId,
      size: AdSize.banner,
      listener: (MobileAdEvent event) {
        print('BannerAd event $event');
      }
    );
  }

  static InterstitialAd _createInterstitialAds() {
    return InterstitialAd(
      adUnitId: INTERSTITIAL_ID,
      // adUnitId: InterstitialAd.testAdUnitId,
      listener: (MobileAdEvent event) {
        print('InterstitialAd event $event');
      }
    );
  }

  static void showBannerAd() {
    if (_bannerAd == null) _bannerAd = _createBannerAd();
    _bannerAd
      ..load()
      ..show();
  }

  static void showInterstitialAd() {
    _interstitialAd = _createInterstitialAds();
    
    _interstitialAd
      ..load()
      ..show();
  }

  static void hideBannerAd() async {
    await _bannerAd.dispose();
    _bannerAd = null;
  }
}
