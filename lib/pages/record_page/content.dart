import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'components/count_page.dart';
import 'components/continuation_page.dart';
import 'view_model.dart';

class RecordContent extends StatelessWidget {
  const RecordContent({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<RecordViewModel>(context, listen: false);

    return Scaffold(
      body: SafeArea(
        child: Stack(
          fit: StackFit.loose,
          children: [
            PageView(
              controller: viewModel.controller,
              physics: NeverScrollableScrollPhysics(),
              children: [
                CountPage(),
                ContinuationPage(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
