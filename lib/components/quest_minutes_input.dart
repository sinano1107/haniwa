import 'package:flutter/material.dart';

class QuestMinutesInput extends StatelessWidget {
  QuestMinutesInput({
    @required this.value,
    @required this.onChanged,
  });
  final int value;
  final Function(int) onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: DropdownButton<int>(
              isExpanded: true,
              value: value,
              onChanged: onChanged,
              items: List.generate(
                15,
                (i) => DropdownMenuItem(
                  value: i + 1,
                  child: Center(
                      child: Text(
                    '${i + 1}分間がんばる',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.blue,
                    ),
                  )),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
