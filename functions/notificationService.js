const { retrieveProductData } = require('./retrieveData');
const { getUserToken } = require('./retrieveUserToken')
const { sendNotification } = require('./sendNotification')
exports.handler = async (event, context) => {
    try {
        
        const productData30 = await retrieveProductData(30);
        if (productData30.length > 0) {
            productData30.forEach(async product => {
                // console.log(`User ID: ${product.userId}`)
                const userToken = await getUserToken(product.userId);
                console.log(`user token : ${userToken}`)
                if(userToken){
                const notify =  await sendNotification(userToken, productData30);
                  console.log('send ', notify);
                }
                // You can add more actions or data processing here
            });
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
