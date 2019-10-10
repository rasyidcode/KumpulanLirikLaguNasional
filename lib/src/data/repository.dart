import 'package:kumpulan_lirik_lagu_kebangsaan/src/data/api_service.dart';
import 'package:kumpulan_lirik_lagu_kebangsaan/src/data/database.dart';
import 'package:kumpulan_lirik_lagu_kebangsaan/src/models/lyric.dart';

class Repository {
  static final Repository _repo = Repository._internal();
  ApiService _apiService;
  LyricDatabase _database;

  static Repository get() => _repo;

  void _storeDataToDatabase() async {
    _apiService.fetchLyrics().then((lyrics) {
      _database.insertLyrics(lyrics);
    });
  }

  Repository._internal() {
    _apiService = ApiService.get();
    _database = LyricDatabase.get();

    _storeDataToDatabase();
  }

  Future<List<Lyric>> getLyrics() async {
    return _database.getLyrics();
  }

  Future<List<Lyric>> getFavoriteLyrics() async {
    return _database.getFavoriteLyrics();
  }

  Future close() async {
    return _database.close();
  }
}