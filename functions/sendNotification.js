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

      const promises = []; // Declare and initialize the promises array

      // Send the notification
     await promises.push(messaging.send(message)
        .then(response => {
          console.log(`Notification sent to ${pushToken} for product ${productData.productName}: ${response}`);
        })
        .catch(error => {
          console.error(`Error sending notification to ${pushToken}:`, error);
        }));

      // Wait for all promises to resolve
      await Promise.all(promises);
}

module.exports = { sendNotification };