import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kumpulan_lirik_lagu_kebangsaan/src/models/lyric.dart';

class ApiService {
  static final ApiService apiService = ApiService._internal();

  final Firestore _db = Firestore.instance;

  static ApiService get() => apiService;

  ApiService._internal();

  Future<List<Lyric>> fetchLyrics() async {
    List<Lyric> lyrics = <Lyric>[];

    await _db.collection('lirik_lagu_nasional').getDocuments().then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((DocumentSnapshot document) {
        Lyric lyric = Lyric.fromMap(document.data);
        lyric.id = document.documentID;

        lyrics.add(lyric);
      });
    });

    return lyrics;
  }
}