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
        
        const productData7 = await retrieveProductData(7);
        if (productData7.length > 0) {
            const promises = productData7.map(async product => {
                const userToken = await getUserToken(product.userId);
                if(userToken){
                    await sendNotification(userToken, product);
                }
            });
            await Promise.all(promises);
        } else {
            console.log('No products found with 30 day warranty.');
        }
        const productData3 = await retrieveProductData(3);
        if (productData3.length > 0) {
            const promises = productData3.map(async product => {
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
