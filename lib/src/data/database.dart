import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:kumpulan_lirik_lagu_kebangsaan/src/models/api/lyric_api.dart';
import 'package:kumpulan_lirik_lagu_kebangsaan/src/models/entity/ads_entity.dart';
import 'package:kumpulan_lirik_lagu_kebangsaan/src/models/entity/lyric_entity.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';

class LyricDatabase {
  static final LyricDatabase _lyricDatabase = LyricDatabase._internal();

  final String lyricsTable = 'table_lyrics';
  final String adsTable = 'table_ads';

  Database db;
  bool didInit = false;

  static LyricDatabase get() {
    return _lyricDatabase;
  }

  LyricDatabase._internal();

  Future<Database> _getDatabase() async {
    if (!didInit) await _init();
    return db;
  }

  Future close() async {
    Database db = await _getDatabase();

    return db.close();
  }

  Future _init() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "lyrics.db");

    db = await openDatabase(path, version: 1, onCreate: _createDB);

    didInit = true;
  }

  void _createDB(Database db, int version) async {
    await db.execute("CREATE TABLE $lyricsTable"
        "("
        "${LyricEntity.DB_ID} TEXT PRIMARY_KEY, "
        "${LyricEntity.DB_TITLE} TEXT, "
        "${LyricEntity.DB_MAKER} TEXT, "
        "${LyricEntity.DB_LYRICS} TEXT, "
        "${LyricEntity.DB_DESC} TEXT, "
        "${LyricEntity.DB_VIDEO_ID} TEXT, "
        "${LyricEntity.DB_AUDIO_URL} TEXT, "
        "${LyricEntity.DB_IS_FAVORED} BIT, "
        "${LyricEntity.DB_COVER_IMAGE_URL} TEXT, "
        "${LyricEntity.DB_COVER_IMAGE_SOURCE} TEXT"
        ")");

    await db.execute(
      "CREATE TABLE $adsTable"
      "("
      "${AdsEntity.COLUMN_DATE} TEXT PRIMARY_KEY, "
      "${AdsEntity.COLUMN_COUNTER} INTEGER, "
      "${AdsEntity.COLUMN_CYCLE_COUNTER} INTEGER"
      ")"
      );
  }

  Future<AdsEntity> getAds(String date) async {
    Database db = await _getDatabase();

    List<Map<String, dynamic>> results = await db.rawQuery('SELECT * FROM $adsTable WHERE ${AdsEntity.COLUMN_DATE} = "$date"');

    if (results.length == 0) {
      var mapEmpty = '{"date": "0-0-0000", "counter": 0, "cycle_counter": 0}';

      return AdsEntity.fromMap(json.decode(mapEmpty));
    }

    return AdsEntity.fromMap(results[0]);
  }

  Future<Null> addAds(String date) async {
    Database db = await _getDatabase();
    await db.rawInsert(
      "INSERT INTO $adsTable"
      "("
      "${AdsEntity.COLUMN_DATE}, "
      "${AdsEntity.COLUMN_COUNTER}, "
      "${AdsEntity.COLUMN_CYCLE_COUNTER}"
      ")"
      "VALUES"
      "("
      "'$date', "
      "?, "
      "?"
      ")",
      [0, 0]
      );
  }

  Future<Null> updateAds(String date, int counter, int cyclerCounter) async {
    Database db = await _getDatabase();
    await db.rawUpdate(
      "UPDATE $adsTable "
      "SET "
      "${AdsEntity.COLUMN_COUNTER} = ?, "
      "${AdsEntity.COLUMN_CYCLE_COUNTER} = ? "
      "WHERE ${AdsEntity.COLUMN_DATE} = '$date'",
      [counter, cyclerCounter]
    );
  }

  Future<int> lyricsCount() async {
    Database db = await _getDatabase();
    List<Map<String, dynamic>> data =
        await db.rawQuery('SELECT * FROM $lyricsTable');

    return data == null ? 0 : data.length;
  }

  Future<Null> removeFavoriteLyric(String id) async {
    Database db = await _getDatabase();

    await db.rawUpdate(
      'UPDATE $lyricsTable SET ${LyricEntity.DB_IS_FAVORED} = ? WHERE ${LyricEntity.DB_ID} = "$id"', [0],
    );
  }

  Future<Null> makeFavoriteLyric(String id) async {
    Database db = await _getDatabase();

    await db.rawUpdate(
        'UPDATE $lyricsTable SET ${LyricEntity.DB_IS_FAVORED} = ? WHERE ${LyricEntity.DB_ID} = "$id"', [1]);
  }

  Future<List<LyricEntity>> getFavoriteLyrics() async {
    Database db = await _getDatabase();
    List<Map<String, dynamic>> result = await db.rawQuery(
        'SELECT * FROM $lyricsTable WHERE ${LyricEntity.DB_IS_FAVORED} = "1"');

    if (result.length == 0) return [];

    List<LyricEntity> lyrics = [];

    for (Map<String, dynamic> map in result) {
      lyrics.add(LyricEntity.fromMap(map));
    }

    return lyrics;
  }

  Future<List<LyricEntity>> getLyrics(String title) async {
    List<LyricEntity> lyrics = <LyricEntity>[];
    Database db = await _getDatabase();
    List<Map<String, dynamic>> result;

    if (title == '') {
      result = await db.rawQuery('SELECT * FROM $lyricsTable');
    } else {
      result = await db.rawQuery(
          'SELECT * FROM $lyricsTable WHERE ${LyricEntity.DB_TITLE} LIKE "%$title%"');
    }

    for (Map<String, dynamic> map in result) {
      lyrics.add(LyricEntity.fromMap(map));
    }

    return lyrics;
  }

  Future<Null> insertLyrics(List<LyricApi> lyrics) async {
    Database db = await _getDatabase();

    await db.transaction((t) async {
      for (LyricApi lyric in lyrics) {
        await t.rawInsert('INSERT OR REPLACE INTO $lyricsTable'
            '('
            '${LyricEntity.DB_ID}, '
            '${LyricEntity.DB_TITLE}, '
            '${LyricEntity.DB_MAKER}, '
            '${LyricEntity.DB_LYRICS}, '
            '${LyricEntity.DB_DESC}, '
            '${LyricEntity.DB_VIDEO_ID}, '
            '${LyricEntity.DB_AUDIO_URL}, '
            '${LyricEntity.DB_IS_FAVORED}, '
            '${LyricEntity.DB_COVER_IMAGE_URL}, '
            '${LyricEntity.DB_COVER_IMAGE_SOURCE}'
            ')'
            ' '
            'VALUES'
            '('
            '"${lyric.id}", '
            '"${lyric.title}", '
            '"${lyric.maker}", '
            '"${lyric.lyrics}", '
            '"${lyric.desc}", '
            '"${lyric.videoId}", '
            '"${lyric.audioUrl}", '
            '"${lyric.isFavored ? 1 : 0}", '
            '"${lyric.coverImage.url}", '
            '"${lyric.coverImage.source}"'
            ')');
      }
    });
  }
}
