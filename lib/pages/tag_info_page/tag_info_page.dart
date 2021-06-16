import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'tag_info_view_model.dart';
import 'tag_info_page_content.dart';

class TagInfoPage extends StatelessWidget {
  static const id = 'tag_info';

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TagInfoViewModel()),
      ],
      child: TagInfoBranch(),
    );
  }
}

class TagInfoBranch extends StatefulWidget {
  @override
  _TagInfoBranchState createState() => _TagInfoBranchState();
}

class _TagInfoBranchState extends State<TagInfoBranch> {
  @override
  Widget build(BuildContext context) {
    final TagInfoArguments _args = ModalRoute.of(context).settings.arguments;
    final _viewModel = Provider.of<TagInfoViewModel>(context, listen: false);
    final _future = _viewModel.fetchTagData(_args.groupTagId);

    return FutureBuilder(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        return (_viewModel.isError)
            ? Scaffold(
                body: Center(
                  child: Text('このタグはあなたのグループに存在しません'),
                ),
              )
            : TagInfoPageContent();
      },
    );
  }
}

class TagInfoArguments {
  TagInfoArguments({
    @required this.groupTagId,
    @required this.elapsedTime,
    @required this.wasOngoing,
    @required this.endTime,
  });
  final String groupTagId;
  final String elapsedTime;
  final bool wasOngoing;
  final String endTime;
}
