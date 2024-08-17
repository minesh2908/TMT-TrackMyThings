import { db } from require('./firebase.js');

async function retrieveProductData() {
    try {
        const productSnapshot = await db.collection("productCollection").get();
        if (productSnapshot.empty) {
            console.log("No products found.");
            return [];
          }
        
        const products = [];
        productSnapshot.forEach(doc => {
            products.push({ id: doc.id, ...doc.data() });
        });
        
        return products;
    } catch (error) {
        console.log(`Error : ${error}`);
        return [];
    }
    

}

module.exports = {retrieveProductData};
