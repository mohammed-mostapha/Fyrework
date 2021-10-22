import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

admin.initializeApp();

const db = admin.firestore();

const fcm = admin.messaging();

// // Start writing Firebase Functions
// // https://firebase.google.com/docs/functions/typescript
//
export const helloWorld = functions.https.onRequest((request, response) => {
  functions.logger.info("Hello logs!", {structuredData: true});
  response.send("Hello from Firebase!");
});

export const sendToDevice = functions.firestore.document("gigs/{gigId}")
    .onCreate(async (snapshot) => {
      const querySnapshot = await db.collection("devicesTokens").get();
      const devicesTokens: string | any[] = [];

      querySnapshot.forEach(async (deviceTokenDoc) => {
        devicesTokens.push(deviceTokenDoc.data().deviceToken);
      });

      const payload : admin.messaging.MessagingPayload = {
        notification: {
          title: " New Gig Created ",
          body: "Check whats going on there!",
          click_action: "FLUTTER_NOTIFICATION_CLICK",
        },
      };
      return fcm.sendToDevice(devicesTokens, payload);
    });
