import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_model.dart';

class NameInputPage extends StatelessWidget {
  const NameInputPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _height = MediaQuery.of(context).size.height;
    final _viewModel = Provider.of<DeadlineGamblingCreateViewModel>(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '何をがんばりますか？？',
          style: TextStyle(
            fontSize: 33,
          ),
        ),
        SizedBox(
          height: _height * 0.03,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 30,
          ),
          child: TextField(
            onChanged: _viewModel.editName,
            onEditingComplete: () {
              FocusScope.of(context).unfocus();
              _viewModel.nextPage();
            },
            decoration: InputDecoration(
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: _theme.primaryColor,
                  width: 2.0,
                ),
              ),
              hintText: '朝の散歩、勉強をがんばる、etc...',
            ),
            autofocus: true,
          ),
        ),
      ],
    );
  }
}
