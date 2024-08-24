const { retrieveProductData, getUserToken } = require('./retrieveData');
const { sendNotification } = require('./sendNotification');

exports.handler = async (event, context) => {
    try {
        const productDataExpiredOneDay = await retrieveProductData(0);
        if (productDataExpiredOneDay.length > 0) {
            const promises = productDataExpiredOneDay.map(async product => {
                const userToken = await getUserToken(product.userId);
                if(userToken){
                    await sendNotification(userToken, product);
                }
            });
            await Promise.all(promises);
        } 
        return {
            statusCode: 200,
            body: 'Send Notifications of Yesterday expired product',
        };
    } catch (error) {
        console.error('Error fetching product data:', error);
        return {
            statusCode: 500,
            body: JSON.stringify({ error: 'Failed to fetch product data' }),
        };
    }
};
