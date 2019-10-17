class AdsEntity {
  static const COLUMN_DATE = "date"; // primary key
  static const COLUMN_COUNTER = "counter";
  static const COLUMN_CYCLE_COUNTER = "cycle_counter"; // to count how many completed counter was made

  final String _date;
  int counter;
  int _cyclerCounter;

  AdsEntity.fromMap(Map map) :
    _date = map['date'],
    counter = map['counter'],
    _cyclerCounter = map['cycle_counter'];

  String get date => _date;

  int get cyclerCounter => _cyclerCounter;

}