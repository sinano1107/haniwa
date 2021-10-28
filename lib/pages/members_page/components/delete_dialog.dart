import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:haniwa/common/snackbar.dart';
import 'package:haniwa/common/progress.dart';
import 'package:haniwa/providers/haniwa_provider.dart';
import 'package:haniwa/pages/select_group_page/index.dart';
import '../index.dart';

class DeleteDialog extends StatefulWidget {
  const DeleteDialog({
    Key key,
    @required this.isAdmin,
  }) : super(key: key);
  final bool isAdmin;

  @override
  State<DeleteDialog> createState() => _DeleteDialogState();
}

class _DeleteDialogState extends State<DeleteDialog> {
  final functions = FirebaseFunctions.instanceFor(region: 'asia-northeast1');
  bool checked = false;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HaniwaProvider>(context, listen: false);

    Future deleteGroup() async {
      final callable = functions.httpsCallable('deleteGroup');
      final res = await callable.call(<String, dynamic>{
        'groupId': provider.groupId,
      });
      if (res.data != 'finishedNormally') throw StateError('正常に終了しませんでした');
    }

    Future withdrawal() async {
      final callable = functions.httpsCallable('withdrawal');
      final res = await callable.call(<String, dynamic>{
        'uid': FirebaseAuth.instance.currentUser.uid,
        'groupId': provider.groupId,
      });
      if (res.data != 'finishedNormally') throw StateError('正常に終了しませんでした');
    }

    return AlertDialog(
      title: Text(widget.isAdmin ? 'グループを完全に削除しますか？' : 'グループから脱退しますか？'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.isAdmin
                ? 'この操作を取り消すことはできません。\n他のグループのメンバーもこのグループから強制的に退出させられます\nそれでもよろしいですか？'
                : 'グループから退出します。\nまたこのグループに参加することは可能です。',
            style: TextStyle(color: Colors.red),
          ),
          SizedBox(height: 10),
          widget.isAdmin
              ? Row(
                  children: [
                    Checkbox(
                      value: checked,
                      onChanged: (v) => setState(() => checked = v),
                    ),
                    Text(
                      '確認しました！',
                    ),
                  ],
                )
              : Container(),
        ],
      ),
      actions: [
        widget.isAdmin
            ? TextButton(
                child: Text(
                  'グループを完全に削除する',
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
                onPressed: () async {
                  if (!checked) {
                    showSnackBar(context, '確認されていません');
                    return;
                  }
                  showProgressDialog(context);
                  try {
                    await deleteGroup();
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      SelectGroupPage.id,
                      (route) => false,
                    );
                    showSnackBar(context, 'グループを削除しました');
                  } catch (e) {
                    print('グループ削除エラー: $e');
                    showSnackBar(context, '正常に終了しませんでした');
                    Navigator.popUntil(
                      context,
                      ModalRoute.withName(MembersPage.id),
                    );
                  }
                },
              )
            : TextButton(
                child: Text(
                  'グループから退出する',
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
                onPressed: () async {
                  showProgressDialog(context);
                  try {
                    await withdrawal();
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      SelectGroupPage.id,
                      (route) => false,
                    );
                    showSnackBar(context, 'グループを退出しました');
                  } catch (e) {
                    print('グループ削除エラー: $e');
                    showSnackBar(context, '正常に終了しませんでした');
                    Navigator.popUntil(
                      context,
                      ModalRoute.withName(MembersPage.id),
                    );
                  }
                },
              ),
      ],
    );
  }
}
