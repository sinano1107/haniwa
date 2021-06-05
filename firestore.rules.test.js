// エミュレータホストの指定。デフォルトポートでエミュレータを起動した場合は不要
// process.env.FIRESTORE_EMULATOR_HOST = "localhost:58080";

const fs = require("fs");
const firebase = require("@firebase/testing");

// 認証なしFirestoreクライアントの取得
function getFirestore() {
    const app = firebase.initializeTestApp({
        projectId: "my-test-project"
    });

    return app.firestore();
}

// 認証付きFirestoreクライアントの取得
function getFirestoreWithAuth() {
    const app = firebase.initializeTestApp({
        projectId: "my-test-project",
        auth: {uid: "test_user", email: "test_user@example.com"}
    });

    return app.firestore();
}

describe("fruitsコレクションへの認証付きでのアクセスのみを許可", () => {
    beforeEach(async () => {
        // セキュリティルールの読み込み
        await firebase.loadFirestoreRules({
            projectId: "my-test-project",
            rules: fs.readFileSync("firestore.rules", "utf8")
        });
    });

    afterEach(async () => {
        // 使用したアプリの削除
        await Promise.all(firebase.apps().map(app => app.delete()))
    });

    describe('fruitsコレクションへの認証付きアクセスを許可', () => {
        test('認証なしでのデータ保存に失敗', async () => {
            const db = getFirestore();
            const doc = db.collection('fruits').doc('apple');
            await firebase.assertFails(doc.set({ color: 'res' }));
        });

        test('認証ありでのデータ保存に成功', async () => {
            const db = getFirestoreWithAuth();
            const doc = db.collection('fruits').doc('orange');
            await firebase.assertSucceeds(doc.set({ color: 'orange' }));
        });

        test('認証なしでの取得に失敗', async () => {
            const db = getFirestore();
            const doc = db.collection('fruits').doc('strawberry');
            await firebase.assertFails(doc.get());
        });

        test('認証ありでの取得に成功', async () => {
            const db = getFirestoreWithAuth();
            const doc = db.collection('fruits').doc('cherry');
            await firebase.assertSucceeds(doc.get());
        })
    });

    describe('fruits以外のコレクションへのアクセス禁止', () => {
        test('認証なしでのデータ保存に失敗', async () => {
            const db = getFirestore();
            const doc = db.collection('countries').doc('japan');
            await firebase.assertFails(doc.set({ language: 'japanese' }));
        });

        test('認証ありでのデータ保存に失敗', async () => {
            const db = getFirestoreWithAuth();
            const doc = db.collection('vegetables').doc('tomato');
            await firebase.assertFails(doc.set({ color: 'red' }));
        });

        test('認証なしでの取得に失敗', async () => {
            const db = getFirestore();
            const doc = db.collection('vehicles').doc('car');
            await firebase.assertFails(doc.get());
        });

        test('認証ありでの取得に失敗', async () => {
            const db = getFirestoreWithAuth();
            const doc = db.collection('prefectures').doc('tokyo');
            await firebase.assertFails(doc.get());
        });
    })
});