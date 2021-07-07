import 'package:flutter/material.dart';
import 'package:haniwa/models/quest.dart';
import 'package:provider/provider.dart';
import 'view_model.dart';
import 'package:haniwa/components/quest_name_input.dart';
import 'package:haniwa/components/quest_minutes_input.dart';
import 'package:haniwa/components/quest_point_input.dart';
import 'package:haniwa/components/icon_button.dart';

class QuestEditContent extends StatefulWidget {
  QuestEditContent(this.quest);
  final Quest quest;

  @override
  _QuestEditContentState createState() => _QuestEditContentState();
}

class _QuestEditContentState extends State<QuestEditContent> {
  @override
  void initState() {
    final _viewModel = Provider.of<QuestEditViewModel>(context, listen: false);
    _viewModel.init(widget.quest);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _viewModel = context.watch<QuestEditViewModel>();

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 30,
        horizontal: 20,
      ),
      decoration: BoxDecoration(
        color: _theme.canvasColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          QuestNameInput(
            value: _viewModel.name,
            onChanged: _viewModel.setName,
          ),
          SizedBox(height: 10),
          QuestMinutesInput(
            value: _viewModel.minutes,
            onChanged: _viewModel.setMinutes,
          ),
          SizedBox(height: 5),
          QuestPointInput(
            value: _viewModel.point,
            onChanged: _viewModel.setPoint,
          ),
          SizedBox(height: 30),
          IconButtonWidget(
            icon: Icon(Icons.edit),
            text: 'クエストを編集',
            color: _theme.primaryColor,
            onPressed: _viewModel.name != ''
                ? () => _viewModel.editQuest(context)
                : null,
            size: Size(300, 45),
          )
        ],
      ),
    );
  }
}
