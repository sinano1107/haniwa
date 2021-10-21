import 'package:flutter/material.dart';

class StarInput extends StatelessWidget {
  const StarInput({
    Key key,
    this.initialValue = '',
    @required this.onChanged,
  }) : super(key: key);
  final initialValue;
  final Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      keyboardType: TextInputType.number,
      maxLength: 2,
      cursorColor: Colors.amber,
      style: TextStyle(color: Colors.amber),
      decoration: InputDecoration(
        labelText: 'ひつようなスター',
        hintText: '「〇〇」は一スター得られます',
      ),
      onChanged: onChanged,
    );
  }
}
