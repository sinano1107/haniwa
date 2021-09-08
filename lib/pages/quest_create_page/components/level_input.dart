import 'package:flutter/material.dart';
import 'package:haniwa/theme/colors.dart';
import 'package:provider/provider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:haniwa/components/icon_button.dart';
import '../view_model.dart';

class LevelInput extends StatelessWidget {
  const LevelInput({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<QuestCreateViewModel>(context, listen: false);
    final theme = Theme.of(context);
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    String name() {
      const max = 8;
      final name = viewModel.name;
      return (name.length > max) ? name.substring(0, max) + '...' : name;
    }

    return Stack(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Text(
                'それってどれくらい大変？',
                style: TextStyle(
                  fontSize: width * 0.08,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: height * 0.05),
            Center(
              child: RatingBar.builder(
                initialRating: viewModel.star,
                minRating: 1,
                glowColor: Colors.orange,
                itemCount: 3,
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                itemSize: width * 0.25,
                itemBuilder: (_, __) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: viewModel.editStar,
              ),
            ),
            SizedBox(height: height * 0.07),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: IconButtonWidget(
                text: '「${name()}」を編集する',
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
                  icon: Icon(Icons.check),
                  text: '次へ',
                  color: theme.primaryColor,
                  size: Size(330, 50),
                  // onPressed: () {
                  //   viewModel.editPoint((viewModel.level * 100).toInt());
                  //   viewModel.nextPage();
                  // },
                  onPressed: () => viewModel.createQuest(context),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
