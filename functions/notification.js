const admin = require("firebase-admin");

let app;

if (!admin.apps.length) {
  const serviceAccount = JSON.parse(process.env.SERVICE_ACCOUNT_KEY);
  app = admin.initializeApp({ credential: admin.credential.cert(serviceAccount) });
} else {
  app = admin.app(); // Use the existing app instance
}

exports.handler = async (event, context) => {
  try {
    const firestore = admin.firestore();
    console.log(`firestore: ${firestore}`);
    
    const snapshot = await firestore.collection("productCollection").get();

    // Construct the notification message
    const message = {
      notification: {
        title: "Warranty Expiry Reminder",
        body: `Your warranty for Product is expiring in 3 days.`,
      },
      token: 'e4Iy6ZNtR1-Txbv5iOcg46:APA91bF9waq7uqAhj9iJe1Tfmth-HH8sx7ZkN_1nlIgSfFbAtc-9fXfdXkPfpszpjaYurQoFbFb07OsT5_IYg6W-4yI4ERrAGVOFoFy4gV2domqMrDvZTsckVT9Enq12tyW9pn_QTwDD', // Use the FCM token from Firestore if available
    };
    
    // Send the notification
    const response = await admin.messaging().send(message);
    console.log(`Notification sent: ${response}`);
    
    return {
      statusCode: 200,
      body: JSON.stringify({ message: "Notification scheduled successfully" }),
    };
  } catch (error) {
    console.log(`Here is error :  ${error}`);

    return {
      statusCode: 502,
      body: JSON.stringify({
        message: "Notification scheduled failed",
        error: error,
      }),
    };
  }
};
