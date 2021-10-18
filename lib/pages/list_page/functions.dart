import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:haniwa/common/progress.dart';
import 'package:haniwa/common/snackbar.dart';
import 'package:haniwa/common/firestore.dart';
import 'package:haniwa/components/report_dialog.dart';
import 'package:haniwa/providers/haniwa_provider.dart';

// ダイナミックリンクをリッスン
void listenDynamicLink(BuildContext context) async {
  final data = await FirebaseDynamicLinks.instance.getInitialLink();
  if (data?.link != null) {
    _navigatePage(context, data?.link);
  }
  FirebaseDynamicLinks.instance.onLink(
    onSuccess: (PendingDynamicLinkData dynamicLink) async {
      _navigatePage(context, dynamicLink?.link);
    },
    onError: (OnLinkErrorException e) async {
      print('DynamiLinkエラー ${e.message}');
      showSnackBar(context, e.message);
    },
  );
}

void _navigatePage(
  BuildContext context,
  Uri deeplink,
) async {
  try {
    final provider = Provider.of<HaniwaProvider>(context, listen: false);
    // タグのデータを読み込む
    showProgressDialog(context);
    final id = deeplink.queryParameters['id'];
    if (id == null) throw StateError('フォーマットが正しくありません');
    final ids = id.split('-');
    final groupId = ids[0];
    final questId = ids[1];
    // tagのgroupIdが等しくなければ弾く
    if (provider.groupId != groupId) throw StateError('このグループのタグではありません');
    // questを取得
    final quest = await QuestFirestore(context, questId).get();
    // questが存在しなければ弾く
    if (quest == null) throw StateError('このクエストは削除されたようです');
    // 正常
    Navigator.pop(context);
    showDialog(context: context, builder: (_) => ReportDialog(quest: quest));
  } catch (e) {
    print('ダイナミックリンク対応エラー: $e');
    showSnackBar(context, e.message);
    Navigator.pop(context);
  }
}
