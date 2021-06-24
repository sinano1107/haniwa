import 'package:flutter/foundation.dart';
import 'package:haniwa/models/member.dart';

class ResultViewModel extends ChangeNotifier {
  Member _member;
  Member get member => _member;

  void setMember(Member newMember) {
    _member = newMember;
  }
}
