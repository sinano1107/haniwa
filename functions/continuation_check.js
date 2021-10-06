const functions = require('firebase-functions');
const admin = require('firebase-admin');
const index = require('./index');
const common = require('./common');
const version = index.version;
const getJapanTime = common.getJapanTime;
const jsDay2dartDay = common.jsDay2dartDay;
const checkIsCleared = common.checkIsCleared;

// firebase functions:shell
// firebase > scheduledFunction()
// で確認できます
exports.continuationCheck = functions.pubsub.schedule('55 23 * * *')
    .timeZone('Asia/Tokyo')
    .onRun(async (_) => {
        // 日本時間を保存
        const date = getJapanTime();
        functions.logger.log(`${date.getFullYear()}/${date.getMonth() + 1}/${date.getDate()}の継続チェックを開始します`);
        const dartDay = jsDay2dartDay(date.getDay());
        const path = `${version}/groups`;
        // 全グループを巡回
        const groups = await admin.firestore().collection(path).get();
        groups.docs.forEach(async (group) => {
            // 今日やらなければならないクエストを抽出
            const quests = await group.ref.collection('quests')
                .where('workingDays', 'array-contains', dartDay)
                .get();
            quests.forEach(async (quest) => {
                // そのクエストがクリア済みか検索
                const isCleared = await checkIsCleared(group.id, quest.id, date);
                // クリアしていなかった場合そのgroupメンバーのそのクエストのcontinuationをリセットする
                if (!isCleared) await continuationReset(group.id, quest.id);
            });
        });
        return null;
});

// groupの全メンバーの特定のクエストのレコードのcontinuationをリセットする
// すなわち継続をリセットする
async function continuationReset(groupId, questId) {
    const path = `${version}/groups/${groupId}/members`;
    const members = await admin.firestore().collection(path).get();
    members.forEach(async (member) => {
        const record = await member.ref.collection('records').doc(questId).get();
        // レコードが存在したら0に初期化
        if (record.exists) record.ref.update({ 'continuation': 0 });
    });
};