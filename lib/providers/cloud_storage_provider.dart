import 'package:flutter/foundation.dart';
import 'package:firebase_storage/firebase_storage.dart';

class CloudStorageProvider extends ChangeNotifier {
  Map<String, String> _store = {};
  Map<String, String> get store => _store;

  void requestLoading(String path) async {
    if (_store.containsKey(path)) return; // 既に存在するなら離脱
    _store[path] = 'loading';
    String url;
    try {
      url = await FirebaseStorage.instance.ref(path).getDownloadURL();
      print('ダウンロード完了');
      _store[path] = url;
    } catch (e) {
      print('ストレージからのインストールエラー: $e');
      _store[path] = 'error';
    }
  }
}
