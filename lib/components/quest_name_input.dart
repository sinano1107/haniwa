import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:haniwa/components/cloud_storage_avatar.dart';

class QuestNameInput extends StatefulWidget {
  QuestNameInput({
    @required this.value,
    @required this.onChanged,
  });
  final String value;
  final Function(String) onChanged;

  @override
  _QuestNameInputState createState() => _QuestNameInputState();
}

class _QuestNameInputState extends State<QuestNameInput> {
  TextEditingController _textEditingController;

  @override
  void initState() {
    _textEditingController = TextEditingController(text: widget.value);
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);

    return Row(
      children: [
        CloudStorageAvatar(
          path:
              'versions/v2/users/${FirebaseAuth.instance.currentUser.uid}/icon.png',
          radius: 25,
        ),
        SizedBox(width: 15),
        Expanded(
          child: TextField(
            controller: _textEditingController,
            onChanged: widget.onChanged,
            decoration: InputDecoration(
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: _theme.primaryColor,
                  width: 2.0,
                ),
              ),
              hintText: 'クエストの名前を入力してください',
            ),
            autofocus: true,
          ),
        ),
      ],
    );
  }
}
