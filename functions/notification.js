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
    const targetDate = today.toISOString().split('T')[0]; // Format as 'YYYY-MM-DD'

    // Fetch all products
    const productSnapshot = await firestore.collection("productCollection").get();//3 day 1 week 1 month 

    if (productSnapshot.empty) {
      console.log("No products found.");
      return {
        statusCode: 200,
        body: JSON.stringify({ message: "No products found." }),
      };
    }

    // Fetch products whose warranty ends in 3 days
   const expiringProductsSnapshot =[];
 
    productSnapshot.forEach((productDoc) => {
      const productData = productDoc.data();
      const warrantyEndsDate = new Date(productData.warrantyEndsDate).toISOString().split('T')[0];
      
      if (warrantyEndsDate === targetDate) {
        expiringProductsSnapshot.push(productDoc);
      }
    });
   

    if (expiringProductsSnapshot.empty) {
      console.log("No products with expiring warranties found.");
      return {
        statusCode: 200,
        body: JSON.stringify({ message: "No products with expiring warranties found." }),
      };
    }
    
    const promises = [];
    expiringProductsSnapshot.forEach(async (productDoc) => {
      const productData = productDoc.data();
      console.log(`Product Date- ${productData.productName}`);
      const userId = productData.userId;
      console.log(`userId- ${userId}`);
      // Fetch user data using userId
      const userSnapshot = await firestore.collection("userCollection")
        .where("userId", "==", userId)
        .get();

      if (!userSnapshot.empty) {
        userSnapshot.forEach((userDoc) => {
          const userData = userDoc.data();
          const pushToken = userData.pushToken;
          const productImage = productData.productImage;
          console.log(`Product Image- ${productImage}`);
          if (pushToken) {
            // Construct the notification message
            const message = {
              notification: {

                title: "Warranty Expiry Reminder",
                body: `Your warranty for ${productData.productName} is expiring in 3 days.`,
                image:productImage
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
