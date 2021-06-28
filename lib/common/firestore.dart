import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:haniwa/models/tag.dart';
import 'package:haniwa/models/member.dart';

// tagを取得
Future<Tag> fetchTag(String groupId, String tagId) async {
  final then = (DocumentSnapshot docSnap) {
    if (docSnap.exists) {
      print(docSnap.data());
      return Tag(
        name: docSnap['name'],
      );
    } else {
      throw StateError('タグが存在しませんでした');
    }
  };
  return FirebaseFirestore.instance
      .doc('groups/$groupId/tags/$tagId')
      .get()
      .then(then);
}

// groupを作成
Future createGroup(String name) async {
  final uid = FirebaseAuth.instance.currentUser.uid;

  FirebaseFirestore.instance.collection('groups').add({
    'name': name,
    'members': [uid],
    'createdAt': FieldValue.serverTimestamp(),
  });
}

//-↑旧Haniwa-----------------------------------------------

// グループに自分を追加
Future addMe(String uid) async {
  final groupId = 'cho12345678912345678';
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
  final groupId = 'cho12345678912345678';
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
  final groupId = 'cho12345678912345678';
  final path = 'groups/$groupId/members/$uid';

  await FirebaseFirestore.instance
      .doc(path)
      .update(newData)
      .catchError((e) => StateError('自分のデータをアップデートできませんでした'));
}
