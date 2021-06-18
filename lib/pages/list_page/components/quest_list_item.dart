import 'package:flutter/material.dart';
import 'package:haniwa/models/quest.dart';
import 'package:haniwa/pages/quest_info_page/quest_info_page.dart';

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
            backgroundColor: Colors.blue,
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
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        onTap: () => _showInfoPage(context),
      ),
    );
  }
}

void _showInfoPage(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (_) => QuestInfoPage(),
    backgroundColor: Colors.transparent,
  );
}
