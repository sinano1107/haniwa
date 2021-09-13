import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'view_model.dart';
import 'content.dart';

class QuestCreatePage extends StatelessWidget {
  static const id = 'quest_create';
  const QuestCreatePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => QuestCreateViewModel()),
      ],
      builder: (context, child) {
        final viewModel = Provider.of<QuestCreateViewModel>(
          context,
          listen: false,
        );
        return FutureBuilder(
          future: viewModel.init(context),
          builder: (context, ss) {
            if (ss.connectionState != ConnectionState.done) {
              return Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            } else if (!ss.hasError) {
              return child;
            } else {
              print('メンバー読み込みエラー: ${ss.error}');
              return Scaffold(
                appBar: AppBar(
                  iconTheme: IconThemeData(color: theme.iconTheme.color),
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                ),
                body: Center(child: Text('エラーが発生しました')),
              );
            }
          },
        );
      },
      child: QuestCreateContent(),
    );
  }
}
