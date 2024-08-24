const { retrieveProductData, getUserToken } = require('./retrieveData');
// const { getUserToken } = require('./retrieveUserToken');
const { sendNotification } = require('./sendNotification');

exports.handler = async (event, context) => {
    try {
        
        const productData30 = await retrieveProductData(30);
        if (productData30.length > 0) {
            const promises = productData30.map(async product => {
                const userToken = await getUserToken(product.userId);
                if(userToken){
                    await sendNotification(userToken, product);
                }
            });
            await Promise.all(promises);
        } else {
            console.log('No products found with 30 day warranty.');
        }

        return {
            statusCode: 200,
            body: 'Send Notifications of 30 days left product',
        };
    } catch (error) {
        console.error('Error fetching product data:', error);
        return {
            statusCode: 500,
            body: JSON.stringify({ error: 'Failed to fetch product data' }),
        };
    }
};
