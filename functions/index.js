const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();
const version = 'versions/v2';
exports.version = version;

const questClear = require('./quest_clear');
const continuationCheck = require('./continuation_check');
exports.questClear = questClear.questClear;
exports.continuationCheck = continuationCheck.continuationCheck;

// /groups/:groupId/quest/:questIdが編集された際に
// /groups/:groupId/tags/:tagId のコレクションからidが:questIdと等しいものを同じ値に編集する
exports.editTagQuest = functions.firestore
        .document(`${version}/groups/{groupId}/quests/{questId}`)
        .onUpdate(async (change, context) => {
    // アップデートされた値を取得
    const groupId = context.params.groupId;
    const questId = context.params.questId;
    const data = change.after.data();
    
    // tagsコレクションからidが等しいものを探して編集
    await admin.firestore().collection(`${version}/groups/${groupId}/tags`)
        .where('id', '==', questId)
        .get().then((querySnapShot) => {
            querySnapShot.forEach(async (doc) => {
                await doc.ref.update({
                    'name': data.name,
                    'point': data.point,
                    'last': data.last,
                });
                functions.logger.log('editTagQuest', `${doc.id}を編集しました`);
            });
        });
});

// /groups/:groupId/quest/:questIdが削除された際に
// /groups/:groupId/tags/:tagIdのコレクションからidが:questIdと等しいものを同じ値に編集する
exports.deleteTagQuest = functions.firestore
    .document(`${version}/groups/{groupId}/quests/{questId}`)
    .onDelete(async (_, context) => {
        const groupId = context.params.groupId;
        const questId = context.params.questId;
        // tagsコレクションからidが等しいものを探してidをnullにする
        await admin.firestore().collection(`/groups/${groupId}/tags`)
            .where('id', '==', questId)
            .get().then((querySnapShot) => {
                querySnapShot.forEach(async (doc) => {
                    await doc.ref.update({
                        'id': null,
                    });
                    functions.logger.log('deleteTagQuest', `${doc.id}のidをnullに設定しました`);
                });
            });
    });

// テスト関数
exports.test = functions.https.onRequest(async (_, res) => {
    const date = new Date();
    date.setHours(date.getHours() + 9);
    const string = `${date.getFullYear()}-${date.getMonth() + 1}-${date.getDate()}-${date.getHours()}-${date.getMinutes()}`;
    res.json({'result': string});
});
