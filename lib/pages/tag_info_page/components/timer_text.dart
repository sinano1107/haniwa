import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../tag_info_view_model.dart';

class TimerText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _viewModel = Provider.of<TagInfoViewModel>(context);

    return Expanded(
      child: Center(
        child: Text(
          DateFormat.Hms().format(_viewModel.time),
          style: TextStyle(
            fontSize: 70,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
