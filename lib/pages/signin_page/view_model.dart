import 'package:flutter/foundation.dart';

class SigninViewModel extends ChangeNotifier {
  String _nextPageId;
  String get nextPageId => _nextPageId;
  void setNextPageId(String value) => _nextPageId = value;
}
