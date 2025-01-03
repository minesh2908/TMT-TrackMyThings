// sendNotification.js
const { messaging } = require('./firebase.js');

async function sendNotification(pushToken, productData){
  let message;
  const warrantyEndsDate = new Date(productData.warrantyEndsDate) ;
  const today = new Date();
  today.setHours(0, 0, 0, 0);
  const timeDiff = warrantyEndsDate.getTime() - today.getTime();
  const daysLeft = Math.ceil(timeDiff / (1000 * 3600 * 24));
  console.log(daysLeft);
  if(daysLeft >=2){
     message = {
      notification: {
        title: "Product Warranty Expiry Reminder",
        body: `Your warranty for ${productData.productName} is expiring in ${daysLeft+1} days.`,
        image: productData.productImage
      },
      
      token: pushToken,
    };
    console.log(`Your warranty for ${productData.productName} is expiring in ${daysLeft+1} days.`);
  }  
  else if(daysLeft == 1){
    message = {
      notification: {
        title: "Hurry Up! Product Warranty Expiring tomorrow",
        body: `Your warranty for ${productData.productName} is expiring tomorrow.`,
        image: productData.productImage
      },
      token: pushToken,
    };
    console.log(`Your warranty for ${productData.productName} is expiring tomorrow.`);
  }
  else if(daysLeft == 0){
    message = {
      notification: {
        title: "Last Chance to claim! Product Warranty Expiring today",
        body: `Your warranty for ${productData.productName} is expiring today.`,
        image: productData.productImage
      },
      token: pushToken,
    };
    console.log(`Your warranty for ${productData.productName} is expiring today.`);
  }
  else{
    message = {
      notification: {
        title: "Product Warrant Expired",
        body: `Your Product warranty for ${productData.productName} has been expired.`,
        image: productData.productImage
      },
      token: pushToken,
    };
    console.log(`Your warranty for ${productData.productName} has been expired.`);
  }
      try {
        const response = await messaging.send(message);
        console.log(`Notification sent to ${pushToken} for product ${productData.productName}: ${response}`);
      } catch (error) {
        console.error(`Error sending notification to ${pushToken}:`, error);
      }
}

async function sendBroadcastNotification(title, body, imageUrl = null) {
  try {
      // Get all users with push tokens
      const userQuery = db.collection("userCollection");
      const userSnapshot = await userQuery.get();
      
      if (userSnapshot.empty) {
          console.log('No users found.');
          return {
              statusCode: 404,
              body: 'No users found to send notifications'
          };
      }

      const notifications = userSnapshot.docs
          .map(doc => doc.data().pushToken)
          .filter(pushToken => pushToken) // Filter out any null/undefined tokens
          .map(pushToken => {
              const message = {
                  notification: {
                      title,
                      body,
                      ...(imageUrl && { image: imageUrl })
                  },
                  token: pushToken
              };

              return messaging.send(message)
                  .then(response => {
                      console.log(`Notification sent successfully to ${pushToken}: ${response}`);
                  })
                  .catch(error => {
                      console.error(`Error sending notification to ${pushToken}:`, error);
                  });
          });

      // Wait for all notifications to be sent
      await Promise.all(notifications);
      
      return {
          statusCode: 200,
          body: 'Broadcast notifications sent successfully'
      };

  } catch (error) {
      console.error(`Error: ${error}`);
      return {
          statusCode: 500,
          body: JSON.stringify({ error: 'Failed to send broadcast notifications' })
      };
  }
}
module.exports = { sendNotification, sendBroadcastNotification  };