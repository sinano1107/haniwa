import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../tag_info_view_model.dart';

class CardHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          Provider.of<TagInfoViewModel>(context).tag.name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
      ],
    );
  }
}
