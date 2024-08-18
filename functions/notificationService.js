const { retrieveProductData } = require('./retrieveData');
const { getUserToken } = require('./retrieveUserToken');
const { sendNotification } = require('./sendNotification');
const { messaging } = require('./firebase.js');
exports.handler = async (event, context) => {
    try {
        
        const productData30 = await retrieveProductData(30);
        if (productData30.length > 0) {
            const promises = [];
            productData30.forEach(async product => {
                // console.log(`User ID: ${product.userId}`)
                const userToken = await getUserToken(product.userId);
                console.log(`user token : ${userToken}`)
                if(userToken){
                //     console.log('Inside usertoken')
                // const notify =  await sendNotification(userToken, productData30);
                //   console.log('send ', notify);
                
                const message = {
                    notification: {
      
                      title: "Warranty Expiry Reminder",
                      body: `Your warranty for ${productData30.productName} is expiring in 3 days.`,
                      image:productData30.productImage
                    },
                    token: userToken,
                  };
      
                 
                  promises.push(messaging.send(message)
                    .then(response => {
                      console.log(`Notification sent for product ${productData30.productName}: ${response}`);
                    })
                    .catch(error => {
                      console.error(`Error sending notification to:`, error);
                    }));
                }
                // You can add more actions or data processing here
            });
            await Promise.all(promises);
        } else {
            console.log('No products found with 30 day warranty.');
        }

        // const userTokens30 = await getUserToken(productData30);
        // console.log('Push Tokens: ', userTokens30)

        // const productData7 = await retrieveProductData(7);
        // console.log('Product Data with 7 day warranty:', productData7);
        // const userTokens7 = await getUserToken(productData7);
        // console.log('Push Tokens: ', userTokens7)

        // const productData3 = await retrieveProductData(3);
        // console.log('Product Data with 3 day warranty:', productData3);
        // const userTokens3 = await getUserToken(productData3);
        // console.log('Push Tokens: ', userTokens3)

        return {
            statusCode: 200,
            body: JSON.stringify(productData30),
        };
    } catch (error) {
        console.error('Error fetching product data:', error);
        return {
            statusCode: 500,
            body: JSON.stringify({ error: 'Failed to fetch product data' }),
        };
    }
};
