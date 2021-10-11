const functions = require('firebase-functions');
const admin = require('firebase-admin');
const index = require('./index');
const version = index.version;

exports.getTagData = functions.region('asia-northeast1').https.onRequest(async (req, res) => {
    const tagId = req.body.data.tagId;
    const groupId = req.body.data.groupId;
    const path = `${version}/groups/${groupId}/tags/${tagId}`;
    functions.logger.log(path);
    const tag = await admin.firestore().doc(path).get();
    if (tag.exists) {
        return res.json({result: {
            result: 'finishedNormally',
            tag: tag.data()
        }});
    } else return res.json({result: { result: 'nothingQuest' }});
})