const { retrieveProductData, getUserToken } = require('./retrieveData');
// const { getUserToken } = require('./retrieveUserToken');
const { sendNotification } = require('./sendNotification');

exports.handler = async (event, context) => {
    try {
        const productData3 = await retrieveProductData(3);
        if (productData3.length > 0) {
            const promises = productData3.map(async product => {
                const userToken = await getUserToken(product.userId);
                console.log(productData3);
                if(userToken){
                    await sendNotification(userToken, product);
                }
            });
            await Promise.all(promises);
        } 

        return {
            statusCode: 200,
            body: 'Send Notifications of 3 days left product',
        };
    } catch (error) {
        console.error('Error fetching product data:', error);
        return {
            statusCode: 500,
            body: JSON.stringify({ error: 'Failed to fetch product data' }),
        };
    }
};
