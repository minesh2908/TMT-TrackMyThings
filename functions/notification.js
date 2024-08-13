const admin = require("firebase-admin");

exports.handler = async (event, context) => {
  try {
    const serviceAccount = JSON.parse(process.env.SERVICE_ACCOUNT_KEY);
    
    admin.initializeApp({ credential: admin.credential.cert(serviceAccount) });
    
    const firestore = admin.firestore();
    console.log(`firestore: ${firestore}`);
    
    const snapshot = await firestore.collection("productCollection").get();
    console.log(`snapshot data: ${snapshot}`);
    
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
