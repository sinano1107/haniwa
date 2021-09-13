import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:haniwa/components/icon_button.dart';
import '../view_model.dart';

class Branch extends StatelessWidget {
  const Branch({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<QuestCreateViewModel>(context, listen: false);
    final theme = Theme.of(context);
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'クエストの種類は？',
          style: TextStyle(
            fontSize: width * 0.08,
          ),
        ),
        SizedBox(height: height * 0.05),
        IconButtonWidget(
          color: theme.primaryColor,
          text: '通常のクエスト',
          icon: Icon(Icons.star),
          onPressed: () {
            viewModel.editIsUrgent(false);
            viewModel.nextPage();
          },
        ),
        SizedBox(height: height * 0.03),
        IconButtonWidget(
          color: theme.accentColor,
          text: '緊急クエスト！！',
          icon: Icon(Icons.alarm),
          onPressed: () {
            viewModel.editIsUrgent(true);
            viewModel.controller.jumpToPage(3);
          },
        ),
      ],
    );
  }
}
