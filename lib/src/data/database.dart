import 'dart:async';
import 'dart:io';

import 'package:kumpulan_lirik_lagu_kebangsaan/src/models/lyric.dart';
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

  Future<Null> removeFavoriteLyric(String id) async {
    Database db = await _getDatabase();

    await db.rawUpdate(
      'UPDATE $tableName SET ${Lyric.DB_IS_FAVORED} = ? WHERE ${Lyric.DB_ID} = $id',
      [0],
    );
  }

  Future<Null> makeFavoriteLyric(String id) async {
    Database db = await _getDatabase();

    await db.rawUpdate(
        'UPDATE $tableName SET ${Lyric.DB_IS_FAVORED} = ? WHERE ${Lyric.DB_ID} = $id',
        [1]);
  }

  Future<List<Lyric>> getFavoriteLyrics() async {
    Database db = await _getDatabase();
    List<Map<String, dynamic>> result = await db.rawQuery(
        'SELECT * FROM $tableName WHERE ${Lyric.DB_IS_FAVORED} = "1"');

    if (result.length == 0) return [];

    List<Lyric> lyrics = [];

    for (Map<String, dynamic> map in result) {
      lyrics.add(Lyric.fromMap(map));
    }

    return lyrics;
  }

  Future<List<Lyric>> getLyrics() async {
    List<Lyric> lyrics = <Lyric>[];
    Database db = await _getDatabase();

    List<Map<String, dynamic>> result =
        await db.rawQuery('SELECT * FROM $tableName');

    for (Map<String, dynamic> map in result) {
      lyrics.add(Lyric.fromMap(map));
    }

    return lyrics;
  }

  Future<Null> insertLyrics(List<Lyric> lyrics) async {
    Database db = await _getDatabase();

    await db.transaction((t) async {
      for (Lyric lyric in lyrics) {
        await t.rawInsert('$tableName'
            '('
            '${Lyric.DB_ID},'
            '${Lyric.DB_TITLE},'
            '${Lyric.DB_MAKER},'
            '${Lyric.DB_LYRICS},'
            '${Lyric.DB_DESC},'
            '${Lyric.DB_VIDEO_ID},'
            '${Lyric.DB_AUDIO_URL},'
            '${Lyric.DB_IS_FAVORED},'
            '${Lyric.DB_COVER_IMAGE_URL},'
            '${Lyric.DB_COVER_IMAGE_SOURCE}'
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
        "${Lyric.DB_ID} STRING PRIMARY_KEY,"
        "${Lyric.DB_TITLE} TEXT,"
        "${Lyric.DB_MAKER} TEXT,"
        "${Lyric.DB_LYRICS} TEXT,"
        "${Lyric.DB_DESC} TEXT,"
        "${Lyric.DB_VIDEO_ID} TEXT,"
        "${Lyric.DB_AUDIO_URL} TEXT,"
        "${Lyric.DB_IS_FAVORED} BIT,"
        "${Lyric.DB_COVER_IMAGE_URL} TEXT,"
        "${Lyric.DB_COVER_IMAGE_SOURCE} TEXT"
        ")");
  }
}
