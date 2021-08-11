import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:haniwa/models/quest.dart';
import 'package:haniwa/models/member.dart';
import 'package:haniwa/models/user.dart' as user;
import 'package:haniwa/providers/user_provider.dart';

String fetchGroupId(BuildContext context) {
  final userProvider = Provider.of<UserProvider>(context, listen: false);
  return userProvider.user.groupId;
}

// usersコレクションに新規ユーザーを追加
Future initUser(String uid) async {
  final path = 'versions/v1/users/$uid';
  await FirebaseFirestore.instance.doc(path).set({'groupId': null});
}

// userデータを取得
Future<user.User> fetchUser(String uid) async {
  final path = 'versions/v1/users/$uid';
  final data = await FirebaseFirestore.instance.doc(path).get();
  return user.User(groupId: data['groupId']);
}

// 自分のuserデータを編集して、グループに自分を追加
Future addMe(String uid, String groupId) async {
  final groupPath = 'versions/v1/groups/$groupId';
  final groupSnap = await FirebaseFirestore.instance.doc(groupPath).get();
  // groupが存在しなかったらエラー
  if (!groupSnap.exists) throw StateError('グループが存在しません');
  // groupに自分を追加
  await groupSnap.reference.collection('members').doc(uid).set({'point': 0});
  // userDataを編集
  final userDataPath = 'versions/v1/users/$uid';
  await FirebaseFirestore.instance
      .doc(userDataPath)
      .update({'groupId': groupId});
}

// メンバーのデータを取得
Future<Member> fetchMemberData(BuildContext context, String uid) async {
  final groupId = fetchGroupId(context);
  final path = 'versions/v1/groups/$groupId/members/$uid';
  final then = (DocumentSnapshot docSnap) {
    if (docSnap.exists) {
      print(docSnap.data);
      return Member(
        point: docSnap['point'],
      );
    } else {
      throw StateError('メンバーが存在しませんでした');
    }
  };

  return FirebaseFirestore.instance.doc(path).get().then(then);
}

// 自分のデータをアップデート
Future updateMyData(BuildContext context, Map<String, Object> newData) async {
  final groupId = fetchGroupId(context);
  final uid = FirebaseAuth.instance.currentUser.uid;
  final path = 'versions/v1/groups/$groupId/members/$uid';

  await FirebaseFirestore.instance
      .doc(path)
      .update(newData)
      .catchError((e) => StateError('自分のデータをアップデートできませんでした'));
}

// クエストを取得
Stream<QuerySnapshot> streamQuests(BuildContext context) {
  final groupId = fetchGroupId(context);
  final path = 'versions/v1/groups/$groupId/quests';
  return FirebaseFirestore.instance
      .collection(path)
      .orderBy('createdAt', descending: true)
      .snapshots();
}

// クエストを作成
Future createQuest(
    BuildContext context, String name, int minutes, int point) async {
  final groupId = fetchGroupId(context);
  final path = 'versions/v1/groups/$groupId/quests';
  await FirebaseFirestore.instance.collection(path).add({
    'createdAt': FieldValue.serverTimestamp(),
    'updatedAt': FieldValue.serverTimestamp(),
    'uid': FirebaseAuth.instance.currentUser.uid,
    'name': name,
    'minutes': minutes,
    'point': point,
  });
}

// クエストを編集
Future updateQuest(BuildContext context, String questId, String name,
    int minutes, int point) async {
  final groupId = fetchGroupId(context);
  final path = 'versions/v1/groups/$groupId/quests/$questId';
  await FirebaseFirestore.instance.doc(path).update({
    'updatedAt': FieldValue.serverTimestamp(),
    'name': name,
    'minutes': minutes,
    'point': point,
  });
}

// クエストを削除
Future deleteQuest(BuildContext context, String questId) async {
  final groupId = fetchGroupId(context);
  final path = 'versions/v1/groups/$groupId/quests/$questId';
  await FirebaseFirestore.instance.doc(path).delete();
}

// タグのクエストを取得
Future<Quest> fetchTagQuest(BuildContext context, String tagId) async {
  final groupId = fetchGroupId(context);
  final path = 'versions/v1/groups/$groupId/tags/$tagId';
  final then = (DocumentSnapshot docSnap) {
    if (docSnap.exists) {
      return Quest(
        id: docSnap['id'],
        uid: docSnap['uid'],
        name: docSnap['name'],
        minutes: docSnap['minutes'],
        point: docSnap['point'],
      );
    } else {
      throw StateError('タグが存在しませんでした');
    }
  };

  return await FirebaseFirestore.instance.doc(path).get().then(then);
}

// タグのクエストを編集
Future updateTagQuest(BuildContext context, String tagId, Quest quest) async {
  final groupId = fetchGroupId(context);
  final path = 'versions/v1/groups/$groupId/tags/$tagId';
  await FirebaseFirestore.instance.doc(path).update(quest.encode);
}
