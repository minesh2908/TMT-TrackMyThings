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
        body: `Your warranty for ${productData.productName} has been expired.`,
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

module.exports = { sendNotification };