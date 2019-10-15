import 'package:kumpulan_lirik_lagu_kebangsaan/src/data/api_service.dart';
import 'package:kumpulan_lirik_lagu_kebangsaan/src/data/database.dart';
import 'package:kumpulan_lirik_lagu_kebangsaan/src/models/api/lyric_api.dart';
import 'package:kumpulan_lirik_lagu_kebangsaan/src/models/entity/lyric_entity.dart';

class Repository {
  static final Repository _repo = Repository._internal();
  List<LyricApi> _lyricsApi;
  ApiService _apiService;
  LyricDatabase _database;

  static Repository get() => _repo;

  Repository._internal() {
    _apiService = ApiService.get();
    _database = LyricDatabase.get();

    _apiService.fetchLyrics().then((data) {
      _lyricsApi = data;
    });
  }

  Future<List<LyricEntity>> getLyrics(title) async {
    await _database.lyricsCount().then((counter) {
      if (counter == 0) {
        _database.insertLyrics(_lyricsApi);
      }
    });

    return _database.getLyrics(title);
  }

  Future<List<LyricEntity>> getFavoriteLyrics() async {
    return _database.getFavoriteLyrics();
  }

  Future close() async {
    return _database.close();
  }

  Future<Null> makeItFavorite(String id) async {
    return _database.makeFavoriteLyric(id);
  }

  Future<Null> removeItAsFavorite(String id) async {
    return _database.removeFavoriteLyric(id);
  }
}
