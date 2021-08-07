import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../view_model.dart';
import 'package:haniwa/components/icon_button.dart';
import 'package:haniwa/theme/colors.dart';

class BetInputPage extends StatefulWidget {
  const BetInputPage({Key key}) : super(key: key);

  @override
  _BetInputPageState createState() => _BetInputPageState();
}

class _BetInputPageState extends State<BetInputPage> {
  // 現在所持しているポイントを仮定義
  final _havePoint = 200;

  @override
  void initState() {
    final viewModel = Provider.of<DeadlineGamblingCreateViewModel>(
      context,
      listen: false,
    );
    viewModel.editBetPoint(_havePoint ~/ 4);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _viewModel = Provider.of<DeadlineGamblingCreateViewModel>(context);
    final _notListenViewModel = Provider.of<DeadlineGamblingCreateViewModel>(
      context,
      listen: false,
    );
    final formatter = DateFormat('M/d(E) HH:mm', 'ja_JP');
    final _height = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Text(
                'ポイントを賭けよう！',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
            ),
            SizedBox(height: _height * 0.05),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () => _notListenViewModel.removeBetPoint(10),
                  icon: Icon(Icons.remove),
                  iconSize: 40,
                  color: Colors.blue,
                ),
                IconButton(
                  onPressed: () => _notListenViewModel.removeBetPoint(1),
                  icon: Icon(Icons.remove),
                  iconSize: 20,
                  color: Colors.blue[200],
                ),
                Text(
                  '${_viewModel.betPoint}pt',
                  style: TextStyle(
                    color: kPointColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 55,
                  ),
                ),
                IconButton(
                  onPressed: () => _notListenViewModel.addBetPoint(
                    _havePoint ~/ 2,
                    1,
                    context,
                  ),
                  icon: Icon(Icons.add),
                  iconSize: 20,
                  color: Colors.red[200],
                ),
                IconButton(
                  onPressed: () => _notListenViewModel.addBetPoint(
                    _havePoint ~/ 2,
                    10,
                    context,
                  ),
                  icon: Icon(Icons.add),
                  iconSize: 40,
                  color: Colors.red,
                ),
              ],
            ),
            Center(
              child: Text(
                '現在${_havePoint}ptを所持しています',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 20,
                ),
              ),
            ),
            SizedBox(height: _height * 0.03),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 80),
              child: IconButtonWidget(
                text: 'OK!',
                onPressed: _viewModel.nextPage,
                icon: Icon(Icons.check),
                color: _theme.primaryColor,
              ),
            ),
            SizedBox(height: _height * 0.08),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 8),
              child: IconButtonWidget(
                text: '日時「${formatter.format(_viewModel.deadline)}」を編集する',
                color: Colors.grey[400],
                icon: Icon(Icons.arrow_back),
                onPressed: _viewModel.previousPage,
                size: Size(0, 40),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    color: Colors.blue[200],
                    child: Column(
                      children: [
                        Text(
                          '失敗してしまうと',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          '-${_viewModel.betPoint}pt',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    color: Colors.red[200],
                    child: Column(
                      children: [
                        Text(
                          '成功できたら',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          '+${_viewModel.betPoint ~/ 2}pt',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
