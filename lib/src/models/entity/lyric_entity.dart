class LyricEntity {
  static const String DB_ID = "id";
  static const String DB_TITLE = "title";
  static const String DB_MAKER = "maker";
  static const String DB_LYRICS = "lyrics";
  static const String DB_DESC = "desc";
  static const String DB_VIDEO_ID = "video_id";
  static const String DB_AUDIO_URL = "audio_url";
  static const String DB_IS_FAVORED = "is_favored";
  static const String DB_COVER_IMAGE_URL = "cover_image_url";
  static const String DB_COVER_IMAGE_SOURCE = "cover_image_source";


  final String _id;
  final String _lyrics;
  final String _title;
  final String _maker;
  final String _desc;
  final String _videoId;
  final String _audioUrl;
  bool isFavored;
  final String _coverImageUrl;
  final String _coverImageSource;

  LyricEntity.fromMap(Map map) :
  _id = map['id'],
  _title = map['title'],
  _maker = map['maker'],
  _lyrics = map['lyrics'],
  _desc = map['desc'],
  _videoId = map['video_id'],
  _audioUrl = map['audio_url'],
  isFavored = map['is_favored'] == 1 ? true : false,
  _coverImageUrl = map['cover_image_url'],
  _coverImageSource = map['cover_image_source'];

  String get id => _id;
  String get title => _title;
  String get maker => _maker;
  String get desc => _desc;
  String get lyrics => _lyrics;
  String get videoId => _videoId;
  String get audioUrl => _audioUrl;
  String get coverImageUrl => _coverImageUrl;
  String get coverImageSource => _coverImageSource;

  @override
  String toString() {
    return "This is Lyric Entity with id of $id";
  }
}