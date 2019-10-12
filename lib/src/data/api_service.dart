import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kumpulan_lirik_lagu_kebangsaan/src/models/api/lyric_api.dart';


class ApiService {
  static final ApiService apiService = ApiService._internal();

  final Firestore _db = Firestore.instance;

  static ApiService get() => apiService;

  ApiService._internal();

  Future<List<LyricApi>> fetchLyrics() async {
    List<LyricApi> lyrics = <LyricApi>[];

    await _db.collection('lirik_lagu_nasional').getDocuments().then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((DocumentSnapshot document) {
        LyricApi lyric = LyricApi.fromMap(document.data);
        lyric.id = document.documentID;
        lyric.lyrics = lyric.lyrics.replaceAll('\n', '\\n');

        lyrics.add(lyric);
      });
    });

    return lyrics;
  }
}