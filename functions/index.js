const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp(functions.config().firebase);

exports.sendFireNotifications = functions
  .region('asia-northeast3')
  .firestore
  .document('first_fireC/{documentId}')
  .onUpdate(
  async (snapshot, context) => {
    // Notification details.
    const data = snapshot.after.data();
    const location = data.Location;
    const roomName = data.Room_name;
    const detectedTime = data.detected_Time;
    const payload = {
      notification: {
        title: "Booriya!🔥 화재 감지 알림",
        body: `${detectedTime} ${location} ${roomName}에서 화재가 감지되었습니다.`,
      }
    };
    // Get the list of device tokens.
    const allTokens = await admin.firestore().collection('device_token').get();
    const tokens = [];
    allTokens.forEach((tokenDoc) => {
      tokens.push(tokenDoc.id);
    });

    try {
      if (tokens.length > 0) {
        // Send notifications to all tokens.
        const response = await admin.messaging().sendToDevice(tokens, payload);
      }
    } catch (error) {
      console.log(error);
    }
  });

exports.sendPersonNotifications = functions
  .region('asia-northeast3')
  .firestore
  .document('fire situation_C/{documentId}')
  .onUpdate(
    async (snapshot, context) => {
      // Notification details.
      const data = snapshot.after.data();
      const location = data.Location; // undefined
      const roomName = data.Room_name; // undefined
      const detectedTime = data.detected_Time; // undefined
      const humanCount = data.HumanCount; // undefined
      const payload = {
        notification: {
          title: "Booriya! ⚠ 인원 감지 알림",
          body: `${detectedTime} ${location} ${roomName}에서 ${humanCount}명이 감지되었습니다.`,
        }
      };
      // Get the list of device tokens.
      const allTokens = await admin.firestore().collection('device_token').get();
      const tokens = [];
      allTokens.forEach((tokenDoc) => {
        tokens.push(tokenDoc.id);
      });

      try {
        if (tokens.length > 0) {
          // Send notifications to all tokens.
          const response = await admin.messaging().sendToDevice(tokens, payload);
        }
      } catch (error) {
        console.log(error);
      }
  });
