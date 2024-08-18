const { retrieveProductData } = require('./retrieveData');
const { getUserToken } = require('./retrieveUserToken')
exports.handler = async (event, context) => {
    try {
        
        const productData30 = await retrieveProductData(30);
        // console.log('Product Data with 30 day warranty:', productData30);
        // console.log(`Length: ${productData30.length}`);
        if (productData30.length > 0) {
            console.log('Test');
            productData30.forEach(async product => {
                console.log(`User ID: ${product.userId}`)
                const userToken = await getUserToken(product.userId);
                console.log(`user token : ${userToken}`)
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
