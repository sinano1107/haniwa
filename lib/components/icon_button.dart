import 'package:flutter/material.dart';

class IconButtonWidget extends StatelessWidget {
  final Icon icon;
  final String text;
  final Color color;
  final Function onPressed;
  IconButtonWidget({
    @required this.icon,
    @required this.text,
    @required this.color,
    @required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        minimumSize: Size(300, 50),
        primary: color,
        shape: StadiumBorder(),
      ),
      icon: icon,
      label: Text(
        text,
        style: TextStyle(fontSize: 17),
      ),
      onPressed: onPressed,
    );
  }
}
