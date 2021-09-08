import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:haniwa/pages/record_page/index.dart';
import '../view_model.dart';

class FinishButton extends StatelessWidget {
  FinishButton(this.name);
  final String name;

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);

    return ElevatedButton(
      child: Text(
        'おつかれさま！🎉',
        style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      ),
      style: ElevatedButton.styleFrom(
        minimumSize: Size(300, 60),
        primary: _theme.primaryColor,
        shape: StadiumBorder(),
      ),
      onPressed: () {
        final viewModel = Provider.of<ResultViewModel>(context, listen: false);
        Navigator.pushReplacementNamed(
          context,
          RecordPage.id,
          arguments: RecordArguments(record: viewModel.record, name: name),
        );
      },
    );
  }
}
