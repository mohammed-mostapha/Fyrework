import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
// import {firebaseConfig} from "firebase-functions";

admin.initializeApp();

const db = admin.firestore();

const fcm = admin.messaging();

// // Start writing Firebase Functions
// // https://firebase.google.com/docs/functions/typescript
//
// export const helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

export const notifyAllAboutAGig = functions.firestore.document("gigs/{gigId}")
    .onCreate(async (snapshot) => {
      const gigId = snapshot.id;
      // const createdAt = new Date(admin.firestore.Timestamp.now().seconds*1000).toLocaleDateString();
      // const createdAt = new Date(admin.firestore.Timestamp.now().seconds*1000).toUTCString();
      const createdAt = admin.firestore.FieldValue.serverTimestamp();
      const deToQuSn = await db.collection("devicesTokens").get();
      const notifications = db.collection("notifications");
      const devicesTokens: string | any[] = [];

      deToQuSn.forEach(async (deviceTokenDoc) => {
        // need to exlude the gigOwner by id
        devicesTokens.push(deviceTokenDoc.data().deviceToken);
      });

      const payload : admin.messaging.MessagingPayload = {
        notification: {
          title: " New Gig Created ",
          body: "Check whats going on there!",
          click_action: "FLUTTER_NOTIFICATION_CLICK",
          gigId: gigId,
        },
      };

      const notificationContents = {
        notificationTitle: "New Gig Created",
        notificationBody: "Check whats going on there!",
        click_action: "FLUTTER_NOTIFICATION_CLICK",
        notificationId: "",
        gigId: gigId,
        createdAt: createdAt,
        seen: false,
        generalNotification: true,
      };

      await notifications.add(notificationContents).then((notification) => {
        const notificationId = notification.id;
        notifications.doc(notificationId).update({"notificationId": notificationId});
      });
      return fcm.sendToDevice(devicesTokens, payload);
    });
