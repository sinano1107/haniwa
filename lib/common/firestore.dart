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
