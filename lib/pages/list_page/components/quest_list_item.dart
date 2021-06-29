import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:haniwa/theme/colors.dart';
import 'package:haniwa/models/quest.dart';
import 'package:haniwa/pages/quest_info_page/index.dart';

class QuestListItem extends StatelessWidget {
  QuestListItem({
    @required this.quest,
    this.showBorder = false,
  });
  final Quest quest;
  final bool showBorder;

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _border = Border(
      bottom: BorderSide(
        width: 1.0,
        color: Colors.grey[300],
      ),
    );
    final _subscribedText = Text(
      '${quest.subscriber}が予約済み',
      style: TextStyle(color: _theme.accentColor, fontWeight: FontWeight.bold),
    );

    return Container(
      decoration: BoxDecoration(
        border: showBorder ? _border : null,
      ),
      child: ListTile(
        leading: SizedBox(
          height: 35,
          child: CircleAvatar(
            backgroundImage:
                NetworkImage(FirebaseAuth.instance.currentUser.photoURL),
          ),
        ),
        title: Text(
          quest.name,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: quest.subscriber != null ? _subscribedText : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${quest.minutes}分',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            SizedBox(width: 10),
            Text(
              '${quest.point}pt',
              style: TextStyle(
                color: kPointColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        onTap: () => _showInfoPage(context, quest),
      ),
    );
  }
}

void _showInfoPage(BuildContext context, Quest quest) {
  showModalBottomSheet(
    context: context,
    builder: (_) => QuestInfoPage(quest),
    backgroundColor: Colors.transparent,
  );
}
