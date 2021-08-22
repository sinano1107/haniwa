import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_model.dart';

class NameInput extends StatelessWidget {
  const NameInput({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<QuestCreateViewModel>(context, listen: false);
    final theme = Theme.of(context);
    final height = MediaQuery.of(context).size.height;

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
          height: height * 0.03,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: TextFormField(
            initialValue: viewModel.name,
            onChanged: viewModel.editName,
            onEditingComplete: () {
              FocusScope.of(context).unfocus();
              viewModel.nextPage();
            },
            decoration: InputDecoration(
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: theme.primaryColor,
                  width: 2.0,
                ),
              ),
              hintText: 'メンバーに共有したいタスクを入力してください',
            ),
            autofocus: true,
          ),
        ),
      ],
    );
  }
}
