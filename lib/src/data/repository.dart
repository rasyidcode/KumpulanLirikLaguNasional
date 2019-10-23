import 'package:kumpulan_lirik_lagu_kebangsaan/src/data/api_service.dart';
import 'package:kumpulan_lirik_lagu_kebangsaan/src/data/database.dart';
import 'package:kumpulan_lirik_lagu_kebangsaan/src/models/api/lyric_api.dart';
import 'package:kumpulan_lirik_lagu_kebangsaan/src/models/entity/ads_entity.dart';
import 'package:kumpulan_lirik_lagu_kebangsaan/src/models/entity/lyric_entity.dart';
import 'package:kumpulan_lirik_lagu_kebangsaan/src/utils.dart';

class Repository {
  static final Repository _repo = Repository._internal();
  ApiService _apiService;
  LyricDatabase _database;

  static Repository get() => _repo;

  Repository._internal() {
    _apiService = ApiService.get();
    _database = LyricDatabase.get();
  }

  Future<Null> fetchLyrics() async {
    await _database.lyricsCount().then((counter) async {
      if (counter == 0) {
        await _apiService.fetchLyrics().then((data) async {
          await _database.insertLyrics(data);
        });
      }
    });
  }

  Future<List<LyricEntity>> getLyrics(title) async {
    return _database.getLyrics(title);
  }

  Future<List<LyricEntity>> getFavoriteLyrics() async {
    return _database.getFavoriteLyrics();
  }

  Future close() async {
    return _database.close();
  }

  void makeItFavorite(String id) async {
    _database.makeFavoriteLyric(id);
  }

  void removeItAsFavorite(String id) async {
    _database.removeFavoriteLyric(id);
  }

  Future<AdsEntity> getAdsCounter(String date) async {
    return _database.getAds(date);
  }

  void createAdsCounter(String date) async {
    await _database.addAds(date);
  }

  Future<Null> updateAdsCounter(String date) async {
    AdsEntity ads = await _database.getAds(date);

    if (ads.counter >= 3) {
      AdsUtil.showInterstitialAd();
      ads.counter = 0;

      await _database.updateAds(ads.date, ads.counter, ads.cyclerCounter + 1);
    }

    await _database.updateAds(date, ads.counter + 1, ads.cyclerCounter);
  }
}
