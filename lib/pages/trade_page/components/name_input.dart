import 'package:flutter/material.dart';

class NameInput extends StatelessWidget {
  const NameInput({
    Key key,
    this.initialValue = '',
    @required this.onChanged,
  }) : super(key: key);
  final String initialValue;
  final Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      maxLength: 20,
      decoration: InputDecoration(
        labelText: 'なまえ',
        hintText: '欲しいものを書いてね',
      ),
      onChanged: onChanged,
    );
  }
}
