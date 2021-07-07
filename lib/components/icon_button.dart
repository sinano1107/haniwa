import 'package:flutter/material.dart';

class IconButtonWidget extends StatelessWidget {
  IconButtonWidget({
    @required this.icon,
    @required this.text,
    @required this.color,
    @required this.onPressed,
    this.fontSize = 17,
    this.fontWeight,
    this.size = const Size(300, 50),
  });
  final Icon icon;
  final String text;
  final Color color;
  final Function onPressed;
  final double fontSize;
  final FontWeight fontWeight;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        minimumSize: size,
        primary: color,
        shape: StadiumBorder(),
      ),
      icon: icon,
      label: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: fontWeight,
        ),
      ),
      onPressed: onPressed,
    );
  }
}
