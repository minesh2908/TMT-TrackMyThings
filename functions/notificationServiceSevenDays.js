const { retrieveProductData, getUserToken } = require('./retrieveData');
const { sendNotification } = require('./sendNotification');

exports.handler = async (event, context) => {
    try {
        const productData7 = await retrieveProductData(7);
        if (productData7.length > 0) {
            const promises = productData7.map(async product => {
                const userToken = await getUserToken(product.userId);
                if(userToken){
                    await sendNotification(userToken, product);
                }
            });
            await Promise.all(promises);
        } 
        return {
            statusCode: 200,
            body: 'Send Notifications of 7 days left product',
        };
    } catch (error) {
        console.error('Error fetching product data:', error);
        return {
            statusCode: 500,
            body: JSON.stringify({ error: 'Failed to fetch product data' }),
        };
    }
};
