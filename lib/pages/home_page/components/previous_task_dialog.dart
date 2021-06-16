import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:haniwa/pages/tag_info_page/tag_info_page.dart';
import 'package:haniwa/pages/tag_info_page/tag_info_view_model.dart';

class PreviousTaskDialog extends StatelessWidget {
  PreviousTaskDialog(this.timerData);
  final String timerData;

  @override
  Widget build(BuildContext context) {
    void _continuation() {
      final data = jsonDecode(timerData);
      Navigator.pushReplacementNamed(
        context,
        TagInfoPage.id,
        arguments: TagInfoArguments(
          groupTagId: data[TagInfoViewModel.groupTagIdKey],
          elapsedTime: data[TagInfoViewModel.elapsedTimeKey],
          wasOngoing: data[TagInfoViewModel.wasOngoingKey],
          endTime: data[TagInfoViewModel.endTimeKey],
        ),
      );
    }

    void _cancel() async {
      final _prefs = await SharedPreferences.getInstance();
      _prefs.remove(TagInfoViewModel.timerKey);
      Navigator.pop(context);
    }

    return AlertDialog(
      title: Text('タスク中にアプリが終了したようです'),
      content: Text('タスクを継続しますか？'),
      actions: [
        TextButton(
          child: Text(
            '破棄する',
            style: TextStyle(
              color: Colors.red,
            ),
          ),
          onPressed: _cancel,
        ),
        TextButton(
          child: Text('継続する'),
          onPressed: _continuation,
        ),
      ],
    );
  }
}
