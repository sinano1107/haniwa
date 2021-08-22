import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:haniwa/components/icon_button.dart';
import '../view_model.dart';

class LebelInput extends StatelessWidget {
  const LebelInput({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<QuestCreateViewModel>(context, listen: false);
    final theme = Theme.of(context);
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    String name() {
      const max = 8;
      final name = viewModel.name;
      return (name.length > 5) ? name.substring(0, max) + '...' : name;
    }

    return Stack(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Text(
                'それってどれくらい大変？？',
                style: TextStyle(
                  fontSize: 30,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: height * 0.03),
            Center(
              child: RatingBar.builder(
                initialRating: viewModel.lebel,
                minRating: 0.5,
                allowHalfRating: true,
                glowColor: Colors.red,
                itemCount: 5,
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                itemSize: width * 0.15,
                itemBuilder: (_, __) => Icon(
                  Icons.local_fire_department,
                  color: Colors.orange,
                ),
                onRatingUpdate: viewModel.editLebel,
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
                text: '「${name()}」を編集する',
                color: Colors.grey,
                icon: Icon(Icons.arrow_back),
                onPressed: viewModel.previousPage,
                size: Size(0, 40),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 200),
                child: IconButtonWidget(
                  icon: Icon(Icons.check),
                  text: '次へ',
                  color: theme.primaryColor,
                  size: Size(330, 50),
                  onPressed: () {
                    viewModel.editPoint((viewModel.lebel * 150).toInt());
                    viewModel.nextPage();
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
