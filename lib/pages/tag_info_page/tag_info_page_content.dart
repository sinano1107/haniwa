import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:haniwa/common/snackbar.dart';
import 'components/timer_text.dart';
import 'components/card_header.dart';
import 'components/history_sliver.dart';
import 'components/pause_dialog.dart';
import 'tag_info_page.dart';
import 'tag_info_view_model.dart';

const kPadding = 20.0;

class TagInfoPageContent extends StatefulWidget {
  @override
  _TagInfoPageContentState createState() => _TagInfoPageContentState();
}

class _TagInfoPageContentState extends State<TagInfoPageContent>
    with WidgetsBindingObserver {
  TagInfoArguments _args;

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _args = ModalRoute.of(context).settings.arguments;
      final viewModel = Provider.of<TagInfoViewModel>(context, listen: false);
      viewModel.init(_args);
      // タグデータ読み込み
      viewModel.fetchTagData(_args.groupTagId);
      // 色変更
      viewModel.changeColors([Colors.lightBlueAccent[100], Colors.blue]);
      // ダイアログのリッスン
      viewModel.showDialogAction.stream.listen((_) {
        showDialog(
          context: context,
          builder: (_) => PauseDialog(),
        );
      });
      // スナックバーのリッスン
      viewModel.showSnackbarAction.stream
          .listen((event) => showSnackBar(context, event.text));
    });
    // バックグラウンド化イベントをリッスン
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    // バックグラウンド化イベントをクローズ
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final _viewModel = Provider.of<TagInfoViewModel>(context, listen: false);
    if (state == AppLifecycleState.paused) {
      // ポーズ時
      print('ポーズ');
      _viewModel.pausedAction(_args.groupTagId);
    } else if (state == AppLifecycleState.resumed) {
      // 復帰時
      _viewModel.resumedAction();
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    final _viewModel = Provider.of<TagInfoViewModel>(context);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          stops: [0.2, 0.8],
          colors: _viewModel.colors,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          iconTheme:
              IconThemeData(color: Theme.of(context).textTheme.bodyText1.color),
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          actions: [
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {},
            ),
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TimerText(),
            SizedBox(height: 40),
            Container(
              height: 630,
              padding: EdgeInsets.symmetric(vertical: 20),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: kPadding),
                    child: CardHeader(),
                  ),
                  SizedBox(height: 10),
                  Divider(),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: kPadding),
                      child: CustomScrollView(
                        slivers: [
                          HistorySliver(),
                          HistorySliver(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon((_viewModel.timer != null && _viewModel.timer.isActive)
              ? Icons.stop
              : Icons.play_arrow),
          backgroundColor: Theme.of(context).primaryColor,
          onPressed:
              Provider.of<TagInfoViewModel>(context, listen: false).toggleTimer,
        ),
      ),
    );
  }
}
