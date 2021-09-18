import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:haniwa/components/icon_button.dart';
import '../view_model.dart';

class NameInput extends StatelessWidget {
  const NameInput({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<QuestCreateViewModel>(context, listen: false);
    final theme = Theme.of(context);
    final height = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '何をがんばりますか？？',
              style: TextStyle(
                fontSize: 33,
              ),
            ),
            SizedBox(height: height * 0.03),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: TextFormField(
                initialValue: viewModel.name,
                onChanged: viewModel.editName,
                maxLength: 20,
                onEditingComplete: () {
                  if (viewModel.name.length > 0) {
                    FocusScope.of(context).unfocus();
                    viewModel.nextPage();
                  }
                },
                decoration: InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: theme.primaryColor,
                      width: 2.0,
                    ),
                  ),
                  hintText: 'メンバーに共有したいタスク',
                ),
                autofocus: true,
              ),
            ),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: viewModel.previousBranchButton(context),
            ),
          ],
        ),
      ],
    );
  }
}
