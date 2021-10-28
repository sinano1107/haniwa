const admin = require('firebase-admin');
const index = require('./index');
const version = index.version;
exports.deleteDocumentRecursively = deleteDocumentRecursively;
exports.getJapanTime = getJapanTime;
exports.jsDay2dartDay = jsDay2dartDay;
exports.checkIsCleared = checkIsCleared;

// サブコレクションも含め全て削除する
async function deleteDocumentRecursively(docRef) { 
    const collections = await docRef.listCollections();

    if (collections.length > 0) {
        for (const collection of collections) {
            const snapshot = await collection.get();
            for (const doc of snapshot.docs) {
                await deleteDocumentRecursively(doc.ref);
            }
        }
    }

    await docRef.delete();
};

// 日本時間を取得
function getJapanTime() {
    const date = new Date();
    date.setHours(date.getHours() + 9);
    return date;
}

// js曜日をdart曜日に変換
function jsDay2dartDay(jsDay) {
    // jsでは 0,1,2,3,4,5,6 = 日月火水木金土 なので
    // dartの 0,1,2,3,4,5,6 = 月火水木金土日 に変換する
    return (jsDay + 6) % 7;
}

// 今日すでにそのクエストをクリア済みか調べる
// historiesにそのquestIdのdocが存在するか調べる
async function checkIsCleared(groupId, questId, date = getJapanTime()) {
    const dateString = `${date.getFullYear()}-${date.getMonth() + 1}-${date.getDate()}`;
    const qss = await admin.firestore()
        .collection(`${version}/groups/${groupId}/histories/${dateString}/histories`)
        .where('questId', '==', questId)
        .get();
    return qss.docs.length != 0;
}