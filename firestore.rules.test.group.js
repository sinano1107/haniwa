const fs = require('fs');
const firebase = require('@firebase/testing');
const projectId = 'my-test-project';
// テスト用ユーザーID
const testUid = 'test-user-id';

// 認証なしFirestoreクライアントの取得
function getFirestore() {
    const app = firebase.initializeTestApp({
        projectId: projectId
    });

    return app.firestore();
}

// 認証付きFirestoreクライアントの取得
function getFirestoreWithAuth(uid=testUid) {
    const app = firebase.initializeTestApp({
        projectId: projectId,
        auth: {uid: uid}
    });

    return app.firestore();
}

describe('groupコレクションのテスト', () => {
    beforeEach(async () => {
        // セキュリティルールの読み込み
        await firebase.loadFirestoreRules({
            projectId: projectId,
            rules: fs.readFileSync('firestore.rules', 'utf8')
        });
    });

    afterEach(async () => {
        // 使用したアプリの削除
        await Promise.all(firebase.apps().map(app => app.delete()))
    });

    describe('groups/{group}/members/{member}のアップデート', () => {
        let groupId;
        let memberId;

        beforeAll(async () => {
            // テスト用にあらかじめデータを書き込んでおく
            // ここで書くのやめた
        })

        test('認証なしではできない', async () => {
            const db = getFirestore();
            const path = `groups/${groupId}/members/${memberId}`;
            const doc = db.doc(path);
        })
    });
});