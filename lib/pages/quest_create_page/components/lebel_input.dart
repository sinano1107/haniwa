import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:haniwa/components/icon_button.dart';
import '../view_model.dart';

class LebelInput extends StatelessWidget {
  const LebelInput({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<QuestCreateViewModel>(context, listen: false);

    String name() {
      const max = 5;
      final name = viewModel.name;
      return (name.length > 5) ? name.substring(0, max) : name;
    }

    return Stack(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Text(
                'それってどれくらい大変？？',
                style: TextStyle(
                  fontSize: 30,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(left: 8),
          child: IconButtonWidget(
            text: '「${name()}」を編集する',
            color: Colors.grey,
            icon: Icon(Icons.arrow_back),
            onPressed: viewModel.previousPage,
            size: Size(0, 40),
          ),
        ),
      ],
    );
  }
}
