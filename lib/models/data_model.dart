import 'dart:ui';

class DataModel {
  double? value;
  String? label;
  Color? color;

  DataModel(this.value, this.label, this.color);
}

class DataScoreModel {
  double? value;
  DateTime? dateTime;

  DataScoreModel(this.value, this.dateTime);
}