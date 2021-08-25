import 'package:flutter/material.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:haniwa/models/prefs_timer_data.dart';
// import 'package:haniwa/pages/result_page/index.dart';
import 'package:haniwa/pages/timer_page/index.dart';
import 'package:haniwa/pages/timer_page/content.dart';
import 'index.dart';
import 'package:haniwa/common/progress.dart';
import 'package:haniwa/common/snackbar.dart';
import 'package:haniwa/common/firestore.dart';
import 'package:haniwa/common/notification.dart';
import 'package:haniwa/components/report_dialog.dart';

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
      print('DynamiLinkエラー');
      print(e.message);
    },
  );
}

void _navigatePage(
  BuildContext context,
  Uri deeplink,
) async {
  final _navigator = Navigator.of(context);
  final prefs = await SharedPreferences.getInstance();
  final currentTimer = prefs.getString(timerKey);
  try {
    if (currentTimer == null) {
      if (FirebaseAuth.instance.currentUser != null) {
        // リスト画面まで戻る
        _navigator.popUntil(ModalRoute.withName(ListPage.id));
        // プログレスを表示してクエストを取得
        showProgressDialog(context);
        final idList = deeplink.queryParameters['id'].split('-');
        final _quest = await TagFirestore(context, idList[1]).get();
        final today = DateTime.now();
        _navigator.pop();
        if (_quest.id == null) {
          showSnackBar(context, 'このタグにはクエストがリンクされていません');
        } else if (_quest.last != null &&
            _quest.last.difference(today).inDays == 0 &&
            _quest.last.day == today.day) {
          // 今日はもうこなしていた場合
          showSnackBar(context, 'このクエストはクリア済みです！おつかれさま！！');
        } else {
          // 正常な値
          print(_quest.name);
          showDialog(
            context: context,
            builder: (context) => ReportDialog(quest: _quest),
          );
        }
      } else {
        showSnackBar(context, 'サインインが完了していません');
      }
    } else {
      showSnackBar(context, '作業中のクエストがあります');
    }
  } catch (e) {
    print('タグ取得エラー $e');
    showSnackBar(context, 'このタグを所有するグループに参加してください');
    _navigator.popUntil(ModalRoute.withName(ListPage.id));
  }
}

// タイマーのデータが残存している場合はタイマー画面にとばす
void checkTimer(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  final currentTimer = prefs.getString(timerKey);
  if (currentTimer != null) {
    final data = PrefsTimerData.decode(currentTimer);
    prefs.remove(timerKey);
    cancelLocalNotification();
    if (data.endTime != null && DateTime.now().isAfter(data.endTime)) {
      // Navigator.pushNamed(
      //   context,
      //   ResultPage.id,
      //   arguments: ResultArguments(quest: data.quest),
      // );
    } else {
      Navigator.pushNamed(
        context,
        TimerPage.id,
        arguments: TimerArguments(
          quest: data.quest,
          progress: data.progress,
          pauseTime: data.pauseTime,
          endTime: data.endTime,
          isSharedData: true,
        ),
      );
    }
  }
}
