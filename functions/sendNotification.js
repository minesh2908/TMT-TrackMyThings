// sendNotification.js
const { messaging } = require('./firebase.js');

async function sendNotification(pushToken, productData){
    const message = {
        notification: {
          title: "Warranty Expiry Reminder",
          body: `Your warranty for ${productData.productName} is expiring in 3 days.`,
          image: productData.productImage
        },
        token: pushToken,
      };

      try {
        const response = await messaging.send(message);
        console.log(`Notification sent to ${pushToken} for product ${productData.productName}: ${response}`);
      } catch (error) {
        console.error(`Error sending notification to ${pushToken}:`, error);
      }
}

module.exports = { sendNotification };