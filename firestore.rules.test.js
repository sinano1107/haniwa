// エミュレータホストの指定。デフォルトポートでエミュレータを起動した場合は不要
// process.env.FIRESTORE_EMULATOR_HOST = 'localhost:58080';

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

// サーバータイムスタンプ
function serverTimestamp() {
    return firebase.firestore.FieldValue.serverTimestamp();
}

describe('Haniwaのテスト', () => {
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

    describe('groupsコレクション', () => {
        // 正しい形式のグループオブジェクト
        const correctGroup = {
            name: 'test-group-name',
            members: [testUid],
            createdAt: serverTimestamp(),
        };

        describe('create', () => {
            describe('groupsコレクションは認証されていないと作成できない', () => {
                test('認証なしでのデータ作成に失敗', async () => {
                    const db = getFirestore();
                    const collection = db.collection('groups');
                    await firebase.assertFails(collection.add(correctGroup));
                });

                test('認証ありでのデータ作成に成功', async () => {
                    const db = getFirestoreWithAuth();
                    const collection = db.collection('groups');
                    await firebase.assertSucceeds(collection.add(correctGroup));
                });
            });

            describe('groupsコレクションは認証されていても形式が不正であれば作成できない', () => {
                test('nameがstringではないと作成できない', async () => {
                    const db = getFirestoreWithAuth();
                    const collection = db.collection('groups');
                    const badData = { ...correctGroup, name: null };
                    await firebase.assertFails(collection.add(badData));
                });

                test('nameがstringであっても15字以上だと作成できない', async () => {
                    const db = getFirestoreWithAuth();
                    const collection = db.collection('groups');
                    const goodData = { ...correctGroup, name: '123456789012345' };
                    const badData = { ...correctGroup, name: '1234567890123456' };
                    await firebase.assertSucceeds(collection.add(goodData));
                    await firebase.assertFails(collection.add(badData));
                });

                test('membersがlistでなければ作成できない', async () => {
                    const db = getFirestoreWithAuth();
                    const collection = db.collection('groups');
                    const badData = { ...correctGroup, members: null };
                    await firebase.assertFails(collection.add(badData));
                });

                test('createdAtが正しくないと作成できない', async () => {
                    const db = getFirestoreWithAuth();
                    const collection = db.collection('groups');
                    const badData = { ...correctGroup, createdAt: Date(2021, 1, 1, 0, 0) };
                    await firebase.assertFails(collection.add(badData));
                });
            });
        });

        describe('read', () => {
            describe('groupsコレクションは認証されていないと読めない', () => {
                let id;

                beforeAll(async () => {
                    // テスト用にあらかじめデータを書き込んでおく処理
                    const db = getFirestoreWithAuth();
                    const collection = db.collection('groups');
                    id = (await collection.add(correctGroup)).id;
                })

                test('認証なしのデータ読み込みに失敗', async () => {
                    const db = getFirestore();
                    const collection = db.collection('groups');
                    await firebase.assertFails(collection.doc(id).get());
                });

                test('認証があってもメンバーではなかったら失敗', async () => {
                    const db = getFirestoreWithAuth('no-member-id');
                    const collection = db.collection('groups');
                    await firebase.assertFails(collection.doc(id).get());
                });

                test('認証ありかつメンバーであれば読み込みに成功', async () => {
                    const db = getFirestoreWithAuth();
                    const collection = db.collection('groups');
                    await firebase.assertSucceeds(collection.doc(id).get());
                });
            });
        });
    });
});