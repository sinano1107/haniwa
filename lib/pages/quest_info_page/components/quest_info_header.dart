import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_model.dart';

class QuestInfoHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _viewModel = Provider.of<QuestInfoViewModel>(context, listen: false);

    return Row(
      children: [
        CircleAvatar(
          backgroundColor: Colors.blue,
          radius: 30,
        ),
        SizedBox(width: 15),
        Expanded(
          child: Text(
            _viewModel.quest.name,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
