const admin = require("firebase-admin");

let app;

if (!admin.apps.length) {
  const serviceAccount = JSON.parse(process.env.SERVICE_ACCOUNT_KEY);
  app = admin.initializeApp({ credential: admin.credential.cert(serviceAccount) });
} else {
  app = admin.app();
}

exports.handler = async (event, context) => {
  try {
    const firestore = admin.firestore();

    // Calculate the target date (3 days from now)
    const today = new Date();
    today.setDate(today.getDate() + 3);
    const targetDate = today.toISOString(); // Format as 'YYYY-MM-DD'
    console.log(targetDate);
    // Fetch products whose warranty ends in 3 days
    const productSnapshot = await firestore.collection("productCollection")
      .where("warrantyEndsDate", "==", targetDate)
      .get();

    if (productSnapshot.empty) {
      console.log("No products with expiring warranties found.");
      return {
        statusCode: 200,
        body: JSON.stringify({ message: "No products with expiring warranties found." }),
      };
    }

    const promises = [];
    productSnapshot.forEach(async (productDoc) => {
      const productData = productDoc.data();
      const userId = productData.userId;

      // Fetch user data using userId
      const userSnapshot = await firestore.collection("userCollection")
        .where("userId", "==", userId)
        .get();

      if (!userSnapshot.empty) {
        userSnapshot.forEach((userDoc) => {
          const userData = userDoc.data();
          const pushToken = userData.pushToken;

          if (pushToken) {
            // Construct the notification message
            const message = {
              notification: {
                title: "Warranty Expiry Reminder",
                body: `Your warranty for ${productData.productName} is expiring in 3 days.`,
              },
              token: pushToken,
            };

            // Send the notification
            promises.push(admin.messaging().send(message)
              .then(response => {
                console.log(`Notification sent to ${userData.name} for product ${productData.productName}: ${response}`);
              })
              .catch(error => {
                console.error(`Error sending notification to ${userData.name}:`, error);
              }));
          }
        });
      }
    });

    await Promise.all(promises);

    return {
      statusCode: 200,
      body: JSON.stringify({ message: "Notification check completed successfully." }),
    };
  } catch (error) {
    console.log(`Here is error :  ${error}`);

    return {
      statusCode: 502,
      body: JSON.stringify({
        message: "Notification check failed",
        error: error,
      }),
    };
  }
};
