import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:haniwa/common/string.dart';
import 'package:haniwa/components/icon_button.dart';
import '../view_model.dart';

class UrgentLevelInput extends StatelessWidget {
  const UrgentLevelInput({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<QuestCreateViewModel>(context, listen: false);
    final theme = Theme.of(context);
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

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
                initialRating: 4,
                itemBuilder: (_, index) => Icon(
                  Icons.star,
                  color: index < 3 ? Colors.amber : theme.accentColor,
                ),
                onRatingUpdate: (_) {},
                minRating: 3,
                itemCount: 5,
                itemSize: width * 0.17,
                glowColor: theme.accentColor,
              ),
            ),
            SizedBox(height: height * 0.1),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: IconButtonWidget(
                text: '「${shortening(viewModel.name, 8)}」を編集する',
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
                  text: '緊急クエストを作る',
                  color: theme.accentColor,
                  size: Size(330, 50),
                  onPressed: () {},
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
