import 'package:flutter/foundation.dart';
import 'package:haniwa/models/quest.dart';

class QuestInfoViewModel extends ChangeNotifier {
  Quest _quest;
  Quest get quest => _quest;

  void init(Quest quest) {
    _quest = quest;
    print(_quest.name);
  }
}
