const functions = require('firebase-functions');
const admin = require('firebase-admin');
const index = require('./index');
const common = require('./common');
const version = index.version;
const getJapanTime = common.getJapanTime;
const jsDay2dartDay = common.jsDay2dartDay;
const checkIsCleared = common.checkIsCleared;

exports.questClear = functions.region('asia-northeast1').https.onRequest(async (req, res) => {
    const uid = req.body.data.uid; // uid
    const groupId = req.body.data.groupId; // groupId
    const questId = req.body.data.questId; // questId
    const quest = await getQuest(groupId, questId);
    // クエストが存在しない
    if (quest == null) return res.json({ result: { result: 'nothingQuest' } })
    //=====チェック=====
    const isMember = checkIsMember(groupId, uid);
    const isWorkingDay = checkIsWorkingDay(quest.workingDays);
    const isCleared = checkIsCleared(groupId, questId);
    // そのuserがgroupに所属していなければ弾く
    if (!(await isMember)) return res.json({ result: { result: 'isNotMember' } });
    // そのクエストが勤務日でなければ弾く
    if (!(await isWorkingDay)) return res.json({ result: { result: 'notWorkingDay' } });
    // そのクエストを今日すでにやっていれば弾く
    if (await isCleared) return res.json({result: {result: 'isCleared'}});
    //=====処理=====
    let newStar;
    let record;
    await Promise.all([
        // 履歴を保存
        saveHistory(groupId, uid, quest, questId),
        // レコードを加算
        record = recordUpdate(groupId, uid, questId),
        // クエストのラストを今日に編集
        updateQuestLast(groupId, questId),
        // ポイントを加算
        newStar = addPoint(groupId, uid, quest.star)
    ]);
    res.json({result: {
        result: 'finishedNormary',
        newStar: await newStar,
        record: (await record).encode,
    }});
});

// クエストが今日勤務日か調べる
function checkIsWorkingDay(workingDays) {
    const date = getJapanTime();
    const dayOfWeek = jsDay2dartDay(date.getDay());
    return workingDays.includes(dayOfWeek);
}

// userがgroupに所属しているか確認
async function checkIsMember(groupId, uid) {
    const path = `${version}/groups/${groupId}/members/${uid}`;
    const qss = await admin.firestore().doc(path).get();
    return qss.exists;
}

// クエストを取得
async function getQuest(groupId, questId) {
    const path = `${version}/groups/${groupId}/quests/${questId}`;
    const quest = await admin.firestore().doc(path).get();
    return (quest.exists) ? quest.data() : null;
}

// ポイントを加算
async function addPoint(groupId, uid, star) {
    const path = `${version}/groups/${groupId}/members/${uid}`;
    const user = await admin.firestore().doc(path).get();
    const newStar = (user.data().star ?? 0) + Number(star);
    await user.ref.update({ 'star': newStar });
    return newStar;
}

// 履歴を保存
async function saveHistory(groupId, uid, quest, questId) {
    const jDate = getJapanTime();
    const dateString = `${jDate.getFullYear()}-${jDate.getMonth() + 1}-${jDate.getDate()}`;
    const path = `${version}/groups/${groupId}/histories/${dateString}`;
    const date = new Date();
    const setTime = admin.firestore().doc(path).set({ 'time': date });
    const addHistory = admin.firestore().collection(path + '/histories').add({
        'authorId': uid,
        'text': quest.name + 'をクリアした！',
        'questId': questId,
        'star': quest.star,
        'time': new Date(),
    });
    await Promise.all([setTime, addHistory]);
}

// クエストのラストを今日に設定
async function updateQuestLast(groupId, questId) {
    const path = `${version}/groups/${groupId}/quests/${questId}`;
    await admin.firestore().doc(path).update({'last': new Date()});
}

class Record {
    constructor(count, continuation, maxContinuation) {
        this.count = count;
        this.continuation = continuation;
        this.maxContinuation = maxContinuation;
    }

    get encode() {
        return {
            count: this.count,
            continuation: this.continuation,
            maxContinuation: this.maxContinuation,
        };
    }
}

// レコードのcount,continuationをカウントアップする
async function recordUpdate(groupId, uid, questId) {
    const path = `${version}/groups/${groupId}/members/${uid}/records/${questId}`;
    const record = (await admin.firestore().doc(path).get()).data();
    let count = record == undefined ? 0 : record.count;
    let continuation = record == undefined ? 0 : record.continuation;
    let maxContinuation = record == undefined ? 0 : record.maxContinuation;
    count += 1;
    continuation += 1;
    if (maxContinuation < continuation) maxContinuation = continuation;
    await admin.firestore().doc(path).set({
        'count': count,
        'continuation': continuation,
        'maxContinuation': maxContinuation,
    });
    return new Record(count, continuation, maxContinuation);
}
