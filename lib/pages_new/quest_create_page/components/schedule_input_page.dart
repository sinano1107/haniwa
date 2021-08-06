import 'package:flutter/material.dart';
import 'package:haniwa/common/snackbar.dart';
import 'package:provider/provider.dart';
import '../view_model.dart';
import 'package:haniwa/components/icon_button.dart';

class ScheduleInputPage extends StatelessWidget {
  const ScheduleInputPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _height = MediaQuery.of(context).size.height;
    final _viewModel = Provider.of<QuestCreateViewModel>(context);

    return Stack(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Text(
                'いつまでにがんばりますか？？',
                style: TextStyle(
                  fontSize: 33,
                ),
              ),
            ),
            SizedBox(
              height: _height * 0.03,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 30,
              ),
              child: IconButtonWidget(
                text: '日時を入力する',
                color: _theme.primaryColor,
                icon: Icon(Icons.calendar_today),
                onPressed: () async {
                  // 日付を取得
                  final selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(Duration(days: 60)),
                  );
                  if (selectedDate == null) return;

                  // 時刻を取得
                  final selectedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay(
                      hour: TimeOfDay.now().hour,
                      minute: TimeOfDay.now().minute + 1,
                    ),
                  );
                  if (selectedTime == null) return;

                  final selectedDateTime = selectedDate.add(Duration(
                    hours: selectedTime.hour,
                    minutes: selectedTime.minute,
                  ));
                  // 入力日時が現在より前だった場合にエラー
                  if (selectedDateTime.isBefore(DateTime.now())) {
                    showSnackBar(context, 'この日時はすでに過ぎています');
                    return;
                  }
                  _viewModel.editSchedule(selectedDateTime);
                  _viewModel.nextPage();
                },
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(left: 8),
          child: IconButtonWidget(
            text: '名前「${_viewModel.name}」を編集する',
            color: Colors.grey[400],
            icon: Icon(Icons.arrow_back),
            onPressed: _viewModel.previousPage,
            size: Size(0, 40),
          ),
        ),
      ],
    );
  }
}
