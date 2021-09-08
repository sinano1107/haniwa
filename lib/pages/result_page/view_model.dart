import 'package:flutter/foundation.dart';
import 'package:haniwa/models/member.dart';
import 'package:haniwa/models/record.dart';

class ResultViewModel extends ChangeNotifier {
  Member _member;
  Member get member => _member;
  void setMember(Member newMember) {
    _member = newMember;
  }

  Record _record = Record(count: 0);
  Record get record => _record;
  void setRecord(Record value) => _record = value;
}
