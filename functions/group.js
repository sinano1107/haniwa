const functions = require('firebase-functions');
const admin = require('firebase-admin');
const index = require('./index');
const common = require('./common');
const version = index.version;
const deleteDocumentRecursively = common.deleteDocumentRecursively;

// グループを脱退する
// usersのgroupIdをnullにしてgroupのmembersからユーザーを削除する
exports.withdrawal = functions.region('asia-northeast1').https.onRequest(async (req, res) => {
    const uid = req.body.data.uid;
    const groupId = req.body.data.groupId;
    await Promise.all([
        resetGroupId(uid),
        deleteMember(uid, groupId),
    ]);
    res.json({ result: 'finishedNormally' });
});

// グループを削除して脱退する
exports.deleteGroup = functions.region('asia-northeast1').https.onRequest(async (req, res) => {
    const groupId = req.body.data.groupId;
    const members = await getMembers(groupId);
    await Promise.all([
        deleteGroup(groupId),
        members.forEach((memberId) => resetGroupId(memberId)),
    ]);
    res.json({ result: 'finishedNormally' });
});

// グループのメンバーリストを取得
async function getMembers(groupId) {
    const path = `${version}/groups/${groupId}/members`;
    const members = await admin.firestore().collection(path).get();
    return members.docs.map((m) => m.id);
}

// ユーザーのグループIDをリセット
async function resetGroupId(uid) {
    const path = `${version}/users/${uid}`;
    await admin.firestore().doc(path).update({ "groupId": null });
}

// グループからメンバーを削除
async function deleteMember(uid, groupId) {
    const path = `${version}/groups/${groupId}/members/${uid}`;
    await admin.firestore().doc(path).delete();
}

// グループを削除
async function deleteGroup(groupId) {
    const path = `${version}/groups/${groupId}`;
    await deleteDocumentRecursively(admin.firestore().doc(path));
}