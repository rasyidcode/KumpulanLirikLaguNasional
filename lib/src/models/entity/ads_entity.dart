class AdsEntity {
  static const COLUMN_ID = "id";
  static const COLUMN_COUNTER = "counter";

  final String _id;
  final int _counter;

  AdsEntity(this._id, this._counter);

  String get id => _id;
  int get counter => _counter;
}