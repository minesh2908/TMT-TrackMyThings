const { retrieveProductData } = require('./retrieveData');

exports.handler = async (event, context) => {
    try {
        const dayLeft = 30;
        const productData = await retrieveProductData(dayLeft);
        console.log('Product Data:', productData);
        
        return {
            statusCode: 200,
            body: JSON.stringify(productData),
        };
    } catch (error) {
        console.error('Error fetching product data:', error);
        return {
            statusCode: 500,
            body: JSON.stringify({ error: 'Failed to fetch product data' }),
        };
    }
};
