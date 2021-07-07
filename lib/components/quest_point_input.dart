import 'package:flutter/material.dart';
import 'package:haniwa/theme/colors.dart';

class QuestPointInput extends StatelessWidget {
  QuestPointInput({
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
                20,
                (i) => DropdownMenuItem(
                  value: (i + 1) * 50,
                  child: Center(
                      child: Text(
                    '${(i + 1) * 50}pt',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: kPointColor,
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
