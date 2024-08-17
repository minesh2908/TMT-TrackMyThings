// Import the retrieveProductData function correctly using require
const { retrieveProductData } = require('./retrieveData');

exports.handler = async (event, context) => {
    try {
        // Await the async function to get the product data
        const productData = await retrieveProductData();
        
        // Log the product data properly
        console.log('Product Data:', productData);
        
        // Optionally, return the product data in your response if this is an API handler
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
