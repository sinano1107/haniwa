const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();
const version = 'versions/v2';
exports.version = version;

const questClear = require('./quest_clear');
const continuationCheck = require('./continuation_check');
const get = require('./get');
const group = require('./group');
exports.questClear = questClear.questClear;
exports.continuationCheck = continuationCheck.continuationCheck;
exports.getTagData = get.getTagData;
exports.withdrawal = group.withdrawal;
exports.deleteGroup = group.deleteGroup;

// テスト関数
exports.test = functions.region('asia-northeast1').https.onRequest(async (_, res) => {
    const date = new Date();
    date.setHours(date.getHours() + 9);
    const string = `${date.getFullYear()}-${date.getMonth() + 1}-${date.getDate()}-${date.getHours()}-${date.getMinutes()}`;
    res.json({'result': string});
});
