import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:haniwa/models/report_quest.dart';
import 'package:haniwa/models/member.dart';
import 'package:haniwa/models/history.dart';
import 'package:haniwa/models/record.dart';
import 'package:haniwa/models/badge.dart';

import 'provider.dart';

const version = 'versions/v2';

// パスの系統ごとにクラスを分ける

// /users/{uid}
class UserFirestore {
  static const version = 'versions/v2';
  String get _userPath {
    final uid = FirebaseAuth.instance.currentUser.uid;
    return '$version/users/$uid';
  }

  // usersコレクションに新規ユーザーを追加
  Future initUser() async {
    await FirebaseFirestore.instance.doc(_userPath).set({'groupId': null});
  }

  // userデータを取得
  Future<String> fetchMyGroupId() async {
    final data = await FirebaseFirestore.instance.doc(_userPath).get();
    return data['groupId'];
  }

  // userデータをアップデート
  Future update(Map<String, Object> newValue) async {
    await FirebaseFirestore.instance.doc(_userPath).update(newValue);
  }
}

// /groups/{groupId}
class GroupFirestore {
  GroupFirestore(this.context);
  final BuildContext context;
  // inputGroupIdに何も代入されなかった場合fetchGroupIdが代入される
  String groupPath({String inputGroupId}) {
    final groupId = inputGroupId ?? fetchGroupId(context);
    return '$version/groups/$groupId';
  }

  // グループのデータを取得
  Future get({String groupId}) async {
    final data = await FirebaseFirestore.instance
        .doc(groupPath(inputGroupId: groupId))
        .get();
    return data;
  }

  // グループに自分を追加して、自分のuserデータを編集
  Future addMe({String inputGroupId}) async {
    final groupSnap = await FirebaseFirestore.instance
        .doc(groupPath(inputGroupId: inputGroupId))
        .get();
    // groupが存在しなかったらエラー
    if (!groupSnap.exists) throw StateError('グループが存在しません');
    // groupに自分を追加
    final user = FirebaseAuth.instance.currentUser;
    await groupSnap.reference
        .collection('members')
        .doc(user.uid)
        .set({'name': user.displayName});
    // userDataを編集
    final groupId = inputGroupId ?? fetchGroupId(context);
    await UserFirestore().update({'groupId': groupId});
  }
}

// /groups/{groupId}/members
class MembersColFirestore {
  MembersColFirestore(this.context);
  final BuildContext context;
  String get path => GroupFirestore(context).groupPath() + '/members';

  Future<List<Member>> get() async {
    final then = (QuerySnapshot qss) => qss.docs.map((ss) {
          final Map<String, dynamic> data = ss.data();
          data['uid'] = ss.id;
          return Member.decode(data);
        }).toList();
    return FirebaseFirestore.instance.collection(path).get().then(then);
  }
}

// /groups/{groupId}/members/{uid}
class MemberFirestore {
  MemberFirestore(this.context);
  final BuildContext context;
  String get path {
    final uid = FirebaseAuth.instance.currentUser.uid;
    return GroupFirestore(context).groupPath() + '/members/$uid';
  }

  // メンバーのデータを取得
  Future<Member> get() async {
    final then = (DocumentSnapshot docSnap) {
      if (docSnap.exists) {
        final Map<String, dynamic> data = docSnap.data();
        data['id'] = docSnap.id;
        return Member.decode(data);
      }
      throw StateError('メンバーが存在しませんでした');
    };
    return FirebaseFirestore.instance.doc(path).get().then(then);
  }

  // メンバーのデータをアップデート
  Future update(Map<String, Object> newData) async {
    await FirebaseFirestore.instance
        .doc(path)
        .update(newData)
        .catchError((e) => StateError('メンバーのデータをアップデートできませんでした'));
  }
}

// /groups/{groupId}/members/{uid}/badges
class BadgesColFirestore {
  BadgesColFirestore(this.context);
  final BuildContext context;
  String get path => MemberFirestore(context).path + '/badges';

  // バッジを取得
  Future<List<BadgeData>> get() async {
    final then = (QuerySnapshot qss) =>
        qss.docs.map((ss) => BadgeData.decode(ss.id, ss.data())).toList();
    return FirebaseFirestore.instance.collection(path).get().then(then);
  }
}

// /groups/{groupId}/members/{uid}/histories
class HistoriesColFirestore {
  HistoriesColFirestore(this.context);
  final BuildContext context;
  String get historiesPath => MemberFirestore(context).path + '/histories';

  // 履歴を保存
  Future saveHistory(ReportQuest quest) async {
    return await FirebaseFirestore.instance.collection(historiesPath).add({
      'id': quest.id,
      'name': quest.name,
      'star': quest.star,
      'time': FieldValue.serverTimestamp(),
    });
  }

  // 履歴を取得
  Future<List<History>> get() async {
    final then = (QuerySnapshot qss) =>
        qss.docs.map((ss) => History.decode(ss.data())).toList();
    return FirebaseFirestore.instance
        .collection(historiesPath)
        .orderBy('time', descending: true)
        .get()
        .then(then);
  }
}

// /groups/{groupId}/members/{uid}/records/{questId}
class RecordFirestore {
  RecordFirestore(this.context, this.questId);
  final BuildContext context;
  final String questId;
  String get recordPath {
    return MemberFirestore(context).path + '/records/$questId';
  }

  Future<Record> get() async {
    final then = (DocumentSnapshot docSnap) {
      if (docSnap.exists) {
        Map<String, dynamic> data = docSnap.data();
        data['questId'] = docSnap.id;
        return Record.decode(data);
      }
      // レコードがなかったら全て初期値のものを返す
      return Record(
        count: 0,
        continuation: 0,
        maxContinuation: 1,
        last: null,
      );
    };
    return await FirebaseFirestore.instance.doc(recordPath).get().then(then);
  }

  Future set(Record record) async {
    await FirebaseFirestore.instance.doc(recordPath).set(record.encode);
  }
}

// /groups/{groupId}/quests
class QuestColFirestore {
  QuestColFirestore(this.context);
  final BuildContext context;
  String get questColPath => GroupFirestore(context).groupPath() + '/quests';

  // クエストコレクションを取得
  Stream<QuerySnapshot> snapshots() {
    return FirebaseFirestore.instance
        .collection(questColPath)
        .orderBy('star', descending: true)
        .snapshots();
  }

  // クエストを作成
  Future createQuest(String name, int star, List<int> workingDays) async {
    await FirebaseFirestore.instance.collection(questColPath).add({
      'createdAt': FieldValue.serverTimestamp(),
      'uid': FirebaseAuth.instance.currentUser.uid,
      'name': name,
      'star': star,
      'workingDays': workingDays,
      'last': null,
    });
  }
}

// /groups/{groupId}/quests/{questId}
class QuestFirestore {
  QuestFirestore(this.context, this.questId);
  final BuildContext context;
  final String questId;
  String get questPath => QuestColFirestore(context).questColPath + '/$questId';

  // クエストを編集
  Future update(Map<String, Object> newData) async {
    await FirebaseFirestore.instance.doc(questPath).update(newData);
  }

  // クエストを削除
  Future delete() async {
    await FirebaseFirestore.instance.doc(questPath).delete();
  }
}

// /groups/{groupId}/tags/{tagId}
class TagFirestore {
  TagFirestore(this.context, this.tagId);
  final BuildContext context;
  final String tagId;
  String get tagPath => GroupFirestore(context).groupPath() + '/tags/$tagId';

  // タグのクエストを取得
  Future<ReportQuest> get() async {
    final then = (DocumentSnapshot docSnap) {
      if (docSnap.exists) return ReportQuest.decode(docSnap.data());
      throw StateError('タグが存在しませんでした');
    };
    return await FirebaseFirestore.instance.doc(tagPath).get().then(then);
  }

  // タグのクエストを編集
  Future update(ReportQuest quest) async {
    await FirebaseFirestore.instance.doc(tagPath).update(quest.encode);
  }
}
