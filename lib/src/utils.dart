import 'package:firebase_admob/firebase_admob.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kumpulan_lirik_lagu_kebangsaan/src/personal/admob.dart'
    show APP_ID, BANNER_ID, INTERSTITIAL_ID;
class SprefUtil {
  static void storeFavorite(String id) {
    SharedPreferences.getInstance().then((spref) {
      if (spref.getStringList('favs').isEmpty) {
        List<String> currentFavs = [];
        currentFavs.add(id);
        spref.setStringList('favs', currentFavs);
      } else {
        List<String> currentFavs = spref.getStringList('favs');
        currentFavs.add(id);
        spref.setStringList('favs', currentFavs);
      }
    });
  }

  static void removeFavorite(String id) {
    SharedPreferences.getInstance().then((spref) {
      List<String> currentFavs = spref.getStringList('favs');
      currentFavs.removeWhere((sprefId) => sprefId == id);
      spref.setStringList('favs', currentFavs);
    });
  }

  static void adsCounter() async {
    SharedPreferences spref = await SharedPreferences.getInstance();
    int currentCounter = spref.getInt('ads_counter') ?? 0;

    if (currentCounter < 5) {
      currentCounter++;
      spref.setInt('ads_counter', currentCounter);
    } else {
      AdsUtil.showInterstitialAd();
      spref.setInt('ads_counter', 0);
    }
  }

  static getCurrentAdsCounter() async {
    SharedPreferences spref = await SharedPreferences.getInstance();
    int counter = spref.getInt('ads_counter');

    return counter;
  }

  static void resetAdsCounter() async {
    SharedPreferences spref = await SharedPreferences.getInstance();
    int counter = spref.getInt('ads_counter') ?? 0;
    print('hohohoho: '+counter.toString());
    spref.setInt('ads_counter', counter);
  }
}

class AdsUtil {
  static BannerAd _bannerAd;
  static InterstitialAd _interstitialAd;

  static void initialize() {
    FirebaseAdMob.instance.initialize(appId: APP_ID);
  }

  static BannerAd _createBannerAd() {
    return BannerAd(
      // adUnitId: BANNER_ID,
      adUnitId: BannerAd.testAdUnitId,
      size: AdSize.smartBanner,
      listener: (MobileAdEvent event) {
        print('BannerAd event $event');
      }
    );
  }

  static InterstitialAd _createInterstitialAds() {
    return InterstitialAd(
      // adUnitId: INTERSTITIAL_ID,
      adUnitId: InterstitialAd.testAdUnitId,
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
