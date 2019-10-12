import 'dart:async';
import 'dart:io';

import 'package:kumpulan_lirik_lagu_kebangsaan/src/models/api/lyric_api.dart';
import 'package:kumpulan_lirik_lagu_kebangsaan/src/models/entity/lyric_entity.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';

class LyricDatabase {
  static final LyricDatabase _lyricDatabase = LyricDatabase._internal();

  final String tableName = "lyrics";

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

  Future<int> lyricsCount() async {
    Database db = await _getDatabase();
    List<Map<String, dynamic>> data =
        await db.rawQuery('SELECT * FROM $tableName');

    return data.length;
  }

  Future<Null> removeFavoriteLyric(String id) async {
    Database db = await _getDatabase();

    int value = await db.rawUpdate(
      'UPDATE $tableName SET ${LyricEntity.DB_IS_FAVORED} = "0" WHERE ${LyricEntity.DB_ID} = "$id"',
    );
    print('removed state: '+value.toString());
  }

  Future<Null> makeFavoriteLyric(String id) async {
    Database db = await _getDatabase();
    print('here is id : '+id);
    List<Map<String, dynamic>> lyrics = await db.rawQuery('SELECT * FROM $tableName WHERE ${LyricEntity.DB_ID} = ("$id")');
    // List<Map<String, dynamic>> lyrics2 = await db.query(tableName, where: '${LyricEntity.DB_ID} = ?', whereArgs: ['$id']);
    // print(lyrics[0]);

    int value = await db.rawUpdate(
        'UPDATE $tableName SET ${LyricEntity.DB_IS_FAVORED} = "1" WHERE ${LyricEntity.DB_ID} = "$id"');

    print('added state: '+value.toString());
  }

  Future<List<LyricEntity>> getFavoriteLyrics() async {
    Database db = await _getDatabase();
    List<Map<String, dynamic>> result = await db.rawQuery(
        'SELECT * FROM $tableName WHERE ${LyricEntity.DB_IS_FAVORED} = "1"');

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
      result = await db.rawQuery('SELECT * FROM $tableName');
    } else {
      result = await db.rawQuery(
          'SELECT * FROM $tableName WHERE ${LyricEntity.DB_TITLE} LIKE "%$title%"');
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
        await t.rawInsert('INSERT OR REPLACE INTO $tableName'
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

  Future _init() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "lyrics.db");

    db = await openDatabase(path, version: 1, onCreate: _createDB);

    didInit = true;
  }

  void _createDB(Database db, int version) async {
    await db.execute("CREATE TABLE $tableName"
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
  }
}
