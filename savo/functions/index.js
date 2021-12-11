const functions = require("firebase-functions");
const admin= require("firebase-admin");
// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
// exports.myFunction = functions.firestore
//   .document('chat/{massage}')
//   .onWrite((snapshot, context) => { console.log(snapshot.data()) });

admin.initializeApp();
// let db=admin.firestore();


exports.myFunction = functions.firestore
    .document("chat/{massage}")
    .onWrite((snapshot, context) => {
    //   let data=snapshot.after.data;
      const chatsLength=snapshot.after.data().userChat.length -1;
      const titleMass=snapshot.after.data().userChat[chatsLength].mass;
      const token=snapshot.after.data().userChat[chatsLength].tokenSecound;
      const senderName=snapshot.after.data().userChat[chatsLength].senderName;
      const payload={
        notification: {
          title: senderName,
          body: titleMass,
          clickAction: "FLUTTER_NOTIFICATION_CLICK",
        },
      };
      return admin.messaging().sendToDevice(token, payload);
      // return admin.messaging().sendToTopic("chat",
      //     {notification: {
      //       title: snapshot.after.data().chatId,
      //       body: "kuy",
      //       clickAction: "FLUTTER_NOTIFICATION_CLICK",
      //     }});
    });
