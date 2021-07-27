import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:haniwa/models/quest.dart';
import 'package:haniwa/models/member.dart';
import 'package:haniwa/models/user.dart' as user;

// 今のところグループIDを固定
const groupId = 'cho12345678912345678';

// usersコレクションに新規ユーザーを追加
Future initUser(String uid) async {
  final path = 'users/$uid';
  await FirebaseFirestore.instance.doc(path).set({'groupId': null});
}

// userデータを取得
Future<user.User> fetchUser(String uid) async {
  final path = 'users/$uid';
  final data = await FirebaseFirestore.instance.doc(path).get();
  return user.User(groupId: data['groupId']);
}

// userデータを編集
Future editUser(String uid, String groupId) async {
  final path = 'users/$uid';
  await FirebaseFirestore.instance.doc(path).update({'groupId': groupId});
}

// グループに自分を追加
Future addMe(String uid, String groupId) async {
  final path = 'groups/$groupId/members/$uid';
  await FirebaseFirestore.instance.doc(path).set({'point': 0});
}

// メンバーのデータを取得
Future<Member> fetchMemberData(String uid) async {
  final path = 'groups/$groupId/members/$uid';
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
Future updateMyData(Map<String, Object> newData) async {
  final uid = FirebaseAuth.instance.currentUser.uid;
  final path = 'groups/$groupId/members/$uid';

  await FirebaseFirestore.instance
      .doc(path)
      .update(newData)
      .catchError((e) => StateError('自分のデータをアップデートできませんでした'));
}

// クエストを取得
Stream<QuerySnapshot> streamQuests() {
  final path = 'groups/$groupId/quests';
  return FirebaseFirestore.instance
      .collection(path)
      .orderBy('createdAt', descending: true)
      .snapshots();
}

// クエストを作成
Future createQuest(String name, int minutes, int point) async {
  final path = 'groups/$groupId/quests';
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
Future updateQuest(String questId, String name, int minutes, int point) async {
  final path = 'groups/$groupId/quests/$questId';
  await FirebaseFirestore.instance.doc(path).update({
    'updatedAt': FieldValue.serverTimestamp(),
    'name': name,
    'minutes': minutes,
    'point': point,
  });
}

// クエストを削除
Future deleteQuest(String questId) async {
  final path = 'groups/$groupId/quests/$questId';
  await FirebaseFirestore.instance.doc(path).delete();
}

// タグのクエストを取得
Future<Quest> fetchTagQuest(String tagId) async {
  final path = 'groups/$groupId/tags/$tagId';
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
Future updateTagQuest(String tagId, Quest quest) async {
  final path = 'groups/$groupId/tags/$tagId';
  await FirebaseFirestore.instance.doc(path).update(quest.encode);
}
