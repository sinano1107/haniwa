import 'package:flutter/material.dart';
import 'package:haniwa/common/firestore.dart';
import 'package:haniwa/models/tag.dart';

class TagInfoViewModel extends ChangeNotifier {
  Tag _tag;
  Tag get tag => _tag;

  bool _isError = false;
  bool get isError => _isError;

  List<Color> _colors = [Colors.grey, Colors.grey];
  List<Color> get colors => _colors;

  void changeColors(List<Color> newColors) {
    _colors = newColors;
    notifyListeners();
  }

  dynamic fetchTagData(String groupTagId) async {
    final ids = groupTagId.split('-');
    final groupId = ids[0];
    final tagId = ids[1];
    try {
      final tag = await fetchTag(groupId, tagId);
      _tag = tag;
      notifyListeners();
    } catch (e) {
      print('エラー $e');
      _isError = true;
    }
  }
}
