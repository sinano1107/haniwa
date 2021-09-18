import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:haniwa/components/icon_button.dart';
import '../view_model.dart';

const daysOfWeek = [
  '月',
  '火',
  '水',
  '木',
  '金',
  '土',
  '日',
];

class SelectDay extends StatelessWidget {
  const SelectDay({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final viewModel = Provider.of<QuestCreateViewModel>(context, listen: false);
    final listenViewModel = Provider.of<QuestCreateViewModel>(context);
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Text(
                '何曜日にやる？',
                style: TextStyle(
                  fontSize: width * 0.1,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: height * 0.05),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.02),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  daysOfWeek.length,
                  (index) => DayButton(index: index),
                ),
              ),
            ),
            SizedBox(height: height * 0.05),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: IconButtonWidget(
                text: '難易度「${viewModel.star}」を編集する',
                color: Colors.grey,
                icon: Icon(Icons.arrow_back),
                onPressed: viewModel.previousPage,
                size: Size(0, 40),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 150),
                child: IconButtonWidget(
                  icon: Icon(Icons.create),
                  text: 'クエストを作る',
                  color: theme.primaryColor,
                  size: Size(330, 50),
                  onPressed: listenViewModel.workingDays.length != 0
                      ? () => viewModel.createQuest(context)
                      : null,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class DayButton extends StatelessWidget {
  const DayButton({
    Key key,
    @required this.index,
  }) : super(key: key);
  final int index;

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<QuestCreateViewModel>(context, listen: false);
    final listenViewModel = Provider.of<QuestCreateViewModel>(context);
    final width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () => viewModel.toggleWorkingDays(index),
      child: CircleAvatar(
        backgroundColor: listenViewModel.workingDays.contains(index)
            ? Colors.blue
            : Colors.grey,
        child: Text(
          daysOfWeek[index],
          style: TextStyle(
            fontSize: width * 0.06,
            fontWeight: FontWeight.bold,
          ),
        ),
        radius: width * 0.05,
      ),
    );
  }
}
