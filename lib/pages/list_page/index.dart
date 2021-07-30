import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:haniwa/pages/timer_page/index.dart';
import 'package:haniwa/pages/timer_page/content.dart';
import 'package:haniwa/pages/result_page/index.dart';
import 'package:haniwa/models/prefs_timer_data.dart';
import 'package:haniwa/common/notification.dart';
import 'components/list_app_bar.dart';
import 'components/quest_list.dart';
import 'components/menu.dart';
import 'components/list_page_fab.dart';
import 'package:haniwa/common/firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:haniwa/common/progress.dart';
import 'package:haniwa/common/snackbar.dart';

class ListPage extends StatefulWidget {
  static const id = 'list';

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      init();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: CustomScrollView(
        slivers: [
          ListAppBar(
            scaffoldKey: _scaffoldKey,
          ),
          QuestList(),
          SliverList(delegate: SliverChildListDelegate([Container(height: 30)]))
        ],
      ),
      drawer: Menu(),
      floatingActionButton: ListPageFAB(),
    );
  }

  void init() async {
    // ダイナミックリンクをリッスン
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
    //==========================================================
    // タイマーのデータが残存している場合はタイマー画面にとばす
    final prefs = await SharedPreferences.getInstance();
    final currentTimer = prefs.getString(timerKey);
    if (currentTimer != null) {
      final data = PrefsTimerData.decode(currentTimer);
      prefs.remove(timerKey);
      cancelLocalNotification();
      if (data.endTime != null && DateTime.now().isAfter(data.endTime)) {
        Navigator.pushNamed(
          context,
          ResultPage.id,
          arguments: ResultArguments(quest: data.quest),
        );
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
        final _quest = await fetchTagQuest(context, idList[1]);
        _navigator.pop();
        if (_quest.id == null) {
          showSnackBar(context, 'このタグにはクエストがリンクされていません');
        } else {
          // 終了したらタイマー画面へプッシュ
          _navigator.pushNamed(
            TimerPage.id,
            arguments: TimerArguments(quest: _quest),
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
