const functions = require('firebase-functions');

const admin = require('firebase-admin');
admin.initializeApp();

// /groups/:groupId/quest/:questIdが編集された際に
// /groups/:groupId/tags/:tagId のコレクションからidが:questIdと等しいものを同じ値に編集する
exports.editTagQuest = functions.firestore
        .document('/groups/{groupId}/quests/{questId}')
        .onUpdate(async (change, context) => {
    // アップデートされた値を取得
    const groupId = context.params.groupId;
    const questId = context.params.questId;
    const data = change.after.data();
    
    // tagsコレクションからidが等しいものを探して編集
    await admin.firestore().collection(`/groups/${groupId}/tags`)
        .where('id', '==', questId)
        .get().then((querySnapShot) => {
            querySnapShot.forEach(async (doc) => {
                await doc.ref.update({
                    'name': data.name,
                    'minutes': data.minutes,
                    'point': data.point,
                });
                functions.logger.log('editTagQuest', `${doc.id}を編集しました`);
            });
        });
});

// /groups/:groupId/quest/:questIdが削除された際に
// /groups/:groupId/tags/:tagIdnのコレクションからidが:questIdと等しいものを同じ値に編集する
exports.deleteTagQuest = functions.firestore
    .document('/groups/{groupId}/quests/{questId}')
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
