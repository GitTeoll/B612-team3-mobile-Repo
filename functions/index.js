/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */
const functions = require("firebase-functions");
const admin = require("firebase-admin");

var serviceAccount = require("./cycle-60fc2-firebase-adminsdk-1y3nb-7153d76ae6.json");

admin.initializeApp({
    credential: admin.credential.cert(serviceAccount)
});


const { onRequest } = require("firebase-functions/v2/https");
const logger = require("firebase-functions/logger");

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

//firebase_auth_remote_data_source의 body 에서 user값을 요청
exports.createCustomToken = functions.https.onRequest(async (request, response) => {
    const user = request.body;
    //uid값 수정 kakao + uid
    const uid = `kakao:${user.uid}`;
    //추가 정보 
    const updateParams = {
        //   email: user.email,
        //   photoURL: user.photoURL,
        //   displayName: user.displayName,
    };

    try {
        await admin.auth().updateUser(uid, updateParams);//기존 user가 존재하는경우 그 정보를 업데이트 함
    } catch (e) {
        updateParams["uid"] = uid;//uid 추가
        await admin.auth().createUser(updateParams);//신규 user의 경우 user를 생성함
    }

    //customToken 생성
    const token = await admin.auth().createCustomToken(uid);

    //token 전달
    response.send(token);
});