import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:haniwa/pages/timer_page/index.dart';
import 'package:haniwa/pages/timer_page/content.dart';
import 'package:haniwa/pages/result_page/index.dart';
import 'package:haniwa/models/prefs_timer_data.dart';
import 'package:haniwa/common/notification.dart';
import 'components/list_app_bar.dart';
import 'components/quest_list.dart';
import 'components/menu.dart';
// import 'components/list_page_fab.dart';

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
      // floatingActionButton: ListPageFAB(),
    );
  }

  void init() async {
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
