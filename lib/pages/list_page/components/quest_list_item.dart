import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:haniwa/common/firestore.dart';
import 'package:haniwa/common/progress.dart';
import 'package:haniwa/common/snackbar.dart';
import 'package:haniwa/common/nfc.dart';
import 'package:haniwa/theme/colors.dart';
import 'package:haniwa/models/quest.dart';
import 'package:haniwa/pages/quest_info_page/index.dart';
import 'package:haniwa/pages/quest_edit_page/index.dart';
import 'package:haniwa/pages/list_page/index.dart';
import 'package:haniwa/components/cloud_storage_avatar.dart';

class QuestListItem extends StatelessWidget {
  const QuestListItem({
    Key key,
    @required this.quest,
    this.showBorder = false,
  }) : super(key: key);
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
    final _tagAction = IconSlideAction(
      caption: 'タグにリンクする',
      color: Colors.lightGreen,
      foregroundColor: Colors.white,
      icon: Icons.nfc,
      onTap: () {
        getTagId(
          handle: (tagId) async {
            // print(tagId);
            // showProgressDialog(context);
            // try {
            //   await updateTagQuest(context, tagId.split('-').last, quest);
            //   showSnackBar(context, 'タグとのリンクに成功しました！');
            // } catch (e) {
            //   print('タグアップデートエラー: $e');
            //   showSnackBar(context, 'タグとのリンクに失敗しました');
            // }
            // Navigator.pop(context);
          },
          context: context,
        );
      },
    );

    return Container(
      decoration: BoxDecoration(
        border: showBorder ? _border : null,
      ),
      child: Slidable(
        key: ValueKey(quest.id),
        actionPane: SlidableScrollActionPane(),
        actions:
            quest.uid == FirebaseAuth.instance.currentUser.uid && showBorder
                ? [
                    IconSlideAction(
                      caption: '編集',
                      color: Colors.blue,
                      icon: Icons.edit,
                      onTap: () => _showEditPage(context, quest),
                    ),
                    _tagAction,
                  ]
                : [
                    _tagAction,
                  ],
        secondaryActions:
            quest.uid == FirebaseAuth.instance.currentUser.uid && showBorder
                ? [
                    IconSlideAction(
                      caption: '削除',
                      color: Colors.red,
                      icon: Icons.delete,
                      onTap: () => showDialog(
                        context: context,
                        builder: (context) => _deleteDialog(context, quest),
                      ),
                    ),
                  ]
                : [],
        child: ListTile(
          key: ValueKey(quest.id),
          leading: SizedBox(
            height: 35,
            child: CircleAvatar(
              child: CloudStorageAvatar(
                path: 'versions/v2/users/${quest.uid}/icon.png',
              ),
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

void _showEditPage(BuildContext context, Quest quest) {
  final _theme = Theme.of(context);
  showModalBottomSheet(
    context: context,
    builder: (context) => SingleChildScrollView(
      child: Column(
        children: [
          QuestEditPage(quest),
          Container(
            color: _theme.canvasColor,
            height: MediaQuery.of(context).viewInsets.bottom,
          ),
        ],
      ),
    ),
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
  );
}

Widget _deleteDialog(BuildContext context, Quest quest) {
  return AlertDialog(
    title: Text('${quest.name}を本当に削除しますか？'),
    content: Text(
      'この操作は取り消せません。本当によろしいですか？',
      style: TextStyle(
        color: Colors.red,
        fontWeight: FontWeight.bold,
      ),
    ),
    actions: [
      TextButton(
        child: Text(
          'キャンセル',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: () => Navigator.pop(context),
      ),
      TextButton(
        child: Text(
          '削除する',
          style: TextStyle(
            color: Colors.red,
          ),
        ),
        onPressed: () => deleteQuestAction(context, quest),
      ),
    ],
  );
}

void deleteQuestAction(BuildContext context, Quest quest) async {
  showProgressDialog(context);
  try {
    await QuestFirestore(context, quest.id).deleteQuest();
  } catch (e) {
    print('クエスト削除エラー $e');
    showSnackBar(context, 'クエストの削除に失敗しました');
  }
  Navigator.popUntil(context, ModalRoute.withName(ListPage.id));
}
