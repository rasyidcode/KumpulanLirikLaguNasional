class Lyric {
  String id;
  final String _title;
  final String _maker;
  final String _lyrics;
  final String _desc;
  final String _videoId;
  final String _audioUrl;
  final CoverImage _coverImage;
  bool isFavored;

  Lyric.fromMap(Map map) :
  id = '',
  _title = map['title'],
  _maker = map['maker'],
  _lyrics = map['lyrics'],
  _desc = map['desc'],
  _videoId = map['video_id'],
  _audioUrl = map['audio_url'],
  _coverImage = CoverImage.fromMap(map['cover_image']),
  isFavored = false;

  String get title => _title;
  String get maker => _maker;
  String get lyrics => _lyrics;
  String get desc => _desc;
  String get videoId => _videoId;
  String get audioUrl => _audioUrl;
}

class CoverImage {
  final String url;
  final String source;

  CoverImage.fromMap(Map map) :
    url = map['url'],
    source = map['source'];
}