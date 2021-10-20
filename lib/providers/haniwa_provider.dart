import 'package:flutter/foundation.dart';

class HaniwaProvider extends ChangeNotifier {
  // 初期化(下記の変数の編集を統合したもの)
  void init({
    @required String groupId,
    @required String admin,
    @required String adminName,
  }) {
    _groupId = groupId;
    _admin = admin;
    _adminName = adminName;
  }

  // データ全削除
  void clear() {
    _groupId = null;
    _admin = null;
    _adminName = null;
  }

  // グループid
  String _groupId;
  String get groupId => _groupId;

  // グループ権限保有者のuid
  String _admin;
  String get admin => _admin;

  // グループ権限保有者の名前
  String _adminName;
  String get adminName => _adminName;
}
