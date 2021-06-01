import 'package:flutter/material.dart';

class DateHeader extends StatelessWidget {
  DateHeader(this.date);

  final String date;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 5,
        ),
        child: Text(
          date,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).highlightColor,
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
