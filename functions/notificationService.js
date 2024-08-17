const { retrieveProductData } = require('./retrieveData');

exports.handler = async (event, context) => {
    try {
        
        const productData30 = await retrieveProductData(30);
        console.log('Product Data with 30 day warranty:', productData30);
        
        const productData7 = await retrieveProductData(7);
        console.log('Product Data with 7 day warranty:', productData7);

        const productData3 = await retrieveProductData(3);
        console.log('Product Data with 3 day warranty:', productData3);

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
