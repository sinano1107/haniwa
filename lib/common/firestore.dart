import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:haniwa/models/quest.dart';
import 'package:haniwa/models/member.dart';

// 今のところグループIDを固定
const groupId = 'cho12345678912345678';

// グループに自分を追加
Future addMe(String uid) async {
  final path = 'groups/$groupId';
  //-memberに追加-
  List data = await FirebaseFirestore.instance
      .doc(path)
      .get()
      .then((snap) => snap.exists ? snap['members'] : null);
  if (data != null) {
    data.add(uid);
    await FirebaseFirestore.instance.doc(path).update({'members': data});
    //-membersコレクションにデータを追加-
    await FirebaseFirestore.instance
        .doc(path + '/members/$uid')
        .set({'point': 0});
  } else {
    throw StateError('新規ユーザーデータの作成に失敗しました');
  }
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
