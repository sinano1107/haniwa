import 'package:flutter/foundation.dart';
import 'package:haniwa/models/record.dart';

class ResultViewModel extends ChangeNotifier {
  int _newStar;
  int get newStar => _newStar;
  void setNewStar(int value) => _newStar = value;

  Record _record;
  Record get record => _record;
  void setRecord(Record value) => _record = value;
}
