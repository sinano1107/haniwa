import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:haniwa/providers/haniwa_provider.dart';
import 'components/list_app_bar.dart';
import 'components/quest_list.dart';
import 'components/menu.dart';
import 'components/list_page_fab.dart';
import 'functions.dart';

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
    final haniwaProvider = Provider.of<HaniwaProvider>(context, listen: false);

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
    listenDynamicLink(context);
    // タイマーのデータが残存している場合はタイマー画面にとばす
    // checkTimer(context);
  }
}
