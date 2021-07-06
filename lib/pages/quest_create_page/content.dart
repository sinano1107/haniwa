import 'package:flutter/material.dart';
import 'package:haniwa/common/progress.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'view_model.dart';
import 'package:haniwa/theme/colors.dart';
import 'package:haniwa/components/icon_button.dart';

class QuestCreateContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _viewModel = context.watch<QuestCreateViewModel>();

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 30,
        horizontal: 20,
      ),
      decoration: BoxDecoration(
        color: _theme.canvasColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(
                  FirebaseAuth.instance.currentUser.photoURL,
                ),
                radius: 25,
              ),
              SizedBox(width: 15),
              Expanded(
                child: TextField(
                  onChanged: _viewModel.setName,
                  decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: _theme.primaryColor,
                        width: 2.0,
                      ),
                    ),
                    hintText: 'クエストの名前を入力してください',
                  ),
                  autofocus: true,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: DropdownButton(
                    isExpanded: true,
                    value: _viewModel.minutes,
                    onChanged: _viewModel.setMinutes,
                    items: List.generate(
                      15,
                      (i) => DropdownMenuItem(
                        value: i + 1,
                        child: Center(
                            child: Text(
                          '${i + 1}分間がんばる',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Colors.blue,
                          ),
                        )),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 5),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: DropdownButton(
                    isExpanded: true,
                    value: _viewModel.point,
                    onChanged: _viewModel.setPoint,
                    items: List.generate(
                      20,
                      (i) => DropdownMenuItem(
                        value: (i + 1) * 50,
                        child: Center(
                            child: Text(
                          '${(i + 1) * 50}pt',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: kPointColor,
                          ),
                        )),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 30),
          IconButtonWidget(
            icon: Icon(Icons.send),
            text: 'クエストを作成',
            color: _theme.primaryColor,
            onPressed: _viewModel.name != ''
                ? () => _viewModel.createNewQuest(context)
                : null,
            size: Size(300, 45),
          )
        ],
      ),
    );
  }
}
