import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class QuestNameInput extends StatelessWidget {
  QuestNameInput({
    @required this.onChanged,
  });
  final Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);

    return Row(
      children: [
        CircleAvatar(
          backgroundImage: NetworkImage(
            FirebaseAuth.instance.currentUser.photoURL,
          ),
          radius: 25,
        ),
        SizedBox(width: 15),
        Expanded(
          child: TextField(
            onChanged: onChanged,
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
