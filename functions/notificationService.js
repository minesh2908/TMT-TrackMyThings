import { retrieveProductData } from require('./retrieveData');

exports.handler = async(event, context)=>{
    const productData = retrieveProductData();
    console.log(`Product Data - ${productData}`);
}