import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:haniwa/models/tag.dart';

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
